% Copyright (C) 2005 Moritz Kirste
% 
% This file ist free software.
% 
% Author:			Moritz Kirste <kirstem@physik.fu-berlin.de>
% Maintainer:		Moritz Kirste <kirstem@physik.fu-berlin.de>
% Created:			2005/10/10
% Version:			$Revision: 1.5 $
% Last Modification:	$Date: 2005/11/30 15:01:31 $
% Keywords:			transient EPR, simulation, EasySpin,
% Keywords:         zero-field-splitting
%
%
%
%   This file uses EasySpin: http://www.easyspin.org/


%   DOCUMENTATION :
% 	Idea of this programm is to fit an EPR spectra and therefore get the
% 	zero-field-splitting-parameters  and the polarisation of the
% 	measurement.

clear all close all

% Check for dependencies
[status, missing] = trEPRTSim_dependency();
if (status == 1)
     disp('There are files missing required for the fit:');
     cellfun(@disp, missing);
    return
end
    
filename = input('Enter filename: ','s');

% The experimental data are loaded by the function <trEPRload>.
data = trEPRload(filename);

% Convert Gauss -> mT
Bfield = (data.axes.y.values)/10;

% Check whether data are 2D or 1D, and in case of 2D, take maximum
if min(size(data.data)) > 1
    % For the time being, perform a pretrigger offset compensation on the
    % data... (should be done by the user manually or within the toolbox,
    % respectively.)
    data.data = trEPRPOC(...
        data.data,data.parameters.transient.triggerPosition);
    % In case of fsc2 data, perform BGC
    if isfield(data,'file') && isfield(data.file,'format') ...
            && strcmpi(data.file.format,'fsc2')
        data.data = trEPRBGC(data.data);
    end
    % Take maximum
    [~,idxMax] = max(max(data.data));
    spectrum = data.data(:,idxMax);
else
    spectrum = data.data;
end

frequency = data.parameters.bridge.MWfrequency.value;
% In case we couldn't read a frequency value from the (too old) fsc2 file,
% assume some reasonable value... (that works with the provided example
% files).
if isempty(frequency)
    frequency = 9.67737;
end

npts = length(spectrum);
	
	
% User_input is a variable that is changed at the end of the program
% where the user is asked what he wants to do next. By choosing 1 the  
% program ends.
user_input = 0;
while user_input ~= 1
    
    % Initialization of those parts of Sys and Exp that are always 
    % the same.
    [Sys,Exp] = trEPRTSim_simini();
    
    % Replace parameters taken from experimental data
    Exp.mwFreq = frequency;
    Exp.nPoints = npts;
    Exp.Range = [Bfield(1) Bfield(end)];
   
    % INITILIZATION OF THE FIT-PARAMETERS
    [inipar,lb,ub,fitpar,tofit] = trEPRTSim_fitini(Sys,Exp);
    
    disp([inipar ; lb ; ub]);
    disp([fitpar ; tofit]);
    
    % User is asked to define the number of iterations lsqcurvefit should
    % run with at the most (see lsqcurvefit documentation)
    %iterations = input('Number of iterations for the fitting: ');
    iterations = 1;

    disp(' ')  
    disp('Fitting has started')
    disp(' ')
    
    % THE FIT ITSELF : lsqcurvefit trys to fit the function <trEPRTSim_fit>
    % with the initialized fitparameters till it reaches the maximum number
    % of iterations or it reaches the termination tolerance on the function
    % value called TolFun wich is 1.0e-10 (see lsqcurvefit
    % documentation). The final or best parameters are returned in the
    % vector fitout 
    options = optimset('MaxIter',iterations, 'TolFun', 1.0e-10);
    fitfun = @(x,Bfield)trEPRTSim_fit(x,Bfield,Sys,Exp,spectrum,fitpar,tofit);
    fittedpar = lsqcurvefit(fitfun, inipar, Bfield, spectrum, lb, ub, options);
    
    [Sys,Exp] = trEPRTSim_par2SysExp(fittedpar,fitpar,tofit,Sys,Exp);
    
    % Calculate spectrum with final fit parameters.
    [finalfit] = trEPRTSim_sim(Sys,Exp);
    % Correcting magnetic field by field offset.
    % Bfield = Bfield+DeltaB;
        
    % Calculate difference between fit and signal
    difference = spectrum-finalfit; 
        
    % Print fit results
    report = trEPRTSim_fitreport(tofit,inipar,fittedpar,lb,ub);
    
    disp('');
    
    cellfun(@(x)fprintf('%s\n',x),report);
    
    % PLOTTING: the final fit in comparison to the measured signal
    close(figure(1));
    figure('Name', ['Data from ' filename])
    plot(Bfield,[spectrum,finalfit*Exp.scale]);
    legend({'Original','Fit'},'Location','SouthEast');
    
    
    % USER-MENU: Giving the user the option to quit, to save the data, to
    % see and save the difference between signal and fit or to start the
    % fitting again. The menu gives back the variable user_input.
    while (user_input ~= 1)
        text = sprintf('Chosse one of the following options?');
        user_input = menu(text,'Quit','Save figure and data','Plot and save difference','Fit again'); 
        
        
        % QUIT == 1 , THE WHILE-LOOP IS STOPPED 
        % and the while-loop of the whole programm is stopped too (see above)
        
        
        % SAVING == 2 
        if user_input == 2
            % saving fitresults in the file <probename_simergebn.txt> by
            % using c-code (see matlab documentation)  here the char-array
            % results is needed
            pointer = fopen([samplename,'_simergebn.txt'],'wt');
            fprintf(pointer,report);
            fclose(pointer);
            
            % saving figure in the file <probename_simulation.fig>
            saveas(gcf,[samplename,'_simulation.fig']);
            
            % saving data in the file <probename_simulation.dat> by using
            % the double array savingdata which has the form 
            % [Bfield Signal finalfit difference]
            savingdata(:,1) = Bfield;
            savingdata(:,2) = spectrum;
            savingdata(:,3) = finalfit;
            savingdata(:,4) = difference;
            save([samplename,'_simulation.dat'], 'savingdata', '-ascii');
        end
        
        
        % DIFFERENCE SEEING AND SAVING == 3
        if user_input == 3
            figure('Name', ['Difference-data from' filename])
            plot(Bfield,difference);
            legend({'Difference'}, 0);
            % saving difference-figure
            saveas(gcf,[samplename,'_difference_sim_sig.fig']);
        end 
        
        
        % FIT AGAIN == 4
        % this while-loop is stopped and the while loop of the whole
        % program is started again
        if user_input == 4
            break   
        end
        
    end
end