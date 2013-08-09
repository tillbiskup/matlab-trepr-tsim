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
%   This file uses EasySpin written and maintained by the EPR group at the
%   ETH Zuerich. 
%   Contact : easyspin@esr.phys.chem.ethz.ch 
%   EasySpin is freely dowloadable at <http://www.easyspin.ethz.ch/>
%   <quotation source="http://www.easyspin.ethz.ch/">
%   "EasySpin is a Matlab toolbox for solving problems in Electron Paramagnetic 
%   Resonance (EPR) spectroscopy. 
%   Lisence:
%   You may download and work with EasySpin free of charge and without any
%   restrictions. You may copy and distribute verbatim copies of EasySpin.
%   You may not use or modify EasySpin or a part of it for other software
%   which is not freely available at no cost. You may not reverse engineer
%   or disassemble EasySpin. EasySpin comes without warranty of any kind. 
%   If you use results obtained with EasySpin in any scientific
%   publication, cite the appropriate articles. "
%   </quotation>



%   DOCUMENTATION :
% 	Idea of this programm is to fit an EPR spectra and therefore get the
% 	zero-field-splitting-parameters  and the polarisation of the
% 	measurement.
%
% 	The file awaits a probe-name of an EPR spectrum and loads a file of the
% 	spectrum like <probe-name_spectrum.dat> and a file of the measurement
% 	like <probe-name_1.dat> to get the xperimental data. It reads out the
% 	parameter microwave-frequency and Bfield-start and -end by using the
% 	function <read_fsc2_data> and initialices a Sys and a Exp structure
% 	with the read out data (see EasySpin documentation). It calls the
% 	sub-function <trEPRTSim_fitini> to initialice the user-chosen
% 	fit-parameter. Afterwards it asks the user to give the number of
% 	iterations the fit should run. Then it calls the matlab-function
% 	<lsqcurvefit> which trys to change the fit-parameter so that the
% 	measured signal and the fit-signal provided by the sub-function
% 	<trEPRTSim_fit> are most possible equal. lsqcurvefit runs till it
% 	reaches the user-provided maximum number of iterations or till the the
% 	difference between fit and signal is smaller then 1.0e-10 and then
% 	gives back the best possible fit-parameter. Now
% 	<trEPRTSim_final_fit(fitout)> returns the final-fit with the best
% 	parameter and gives back the parameter DeltaB which is needed to ajust
% 	the Bfield  due to the false measurement of the magnetic-field. Then
% 	the difference between the signal and the fit is calculated, the
% 	final-parameters are beeing displayed and the final-fit is plotted in
% 	comparison to the measured data signal. The user can now deside wether
% 	to quit, save the data-results in an file called
% 	<probename_simulation.dat>, in the form [Bfield Signal finalfit
% 	difference], the plot in a file called <probename_simulation.fig> and
% 	the final-parameter in a file called  <probename_simergebn.txt>  or
% 	plot and save the difference between fit and signal or fit again.

clear all close all
% Sys and Exp are needed by EasySpin, spectrum is the measured signal and
% inifactor defines which parameters should be fittet. All these parameters
% are needed by some of the sub-functions and are therefore global
global Sys
global Exp
global spectrum
global inifactor

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

% First column in "spectrum" is B0 axis
spectrum(:,1) = data.axes.y.values;

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
    spectrum(:,2) = data.data(:,idxMax);
else
    spectrum(:,2) = data.data;
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
    
    
    % Signal and Bfield are read out from the loaded spectrum
    % therefore it is possible to change their values without changing the
    % original data    
    Signal = spectrum(:,2);
    Bfield = spectrum(:,1);
    
    disp(' ')  
    disp('Fitting is started')
    disp(' ')
    
    % Initialization of those parts of Sys and Exp that are always 
    % the same.
    g = 2.0034;
    Sys = struct('S', 1, 'g', [g g g]);
    Exp = struct('mwFreq',frequency,'nPoints',npts,'Harmonic',0);
    
    
    % INITILIZATION OF THE FIT-PARAMETERS
    [par,lb,ub] = trEPRTSim_fitini();
    
    % User is asked to define the number of iterations lsqcurvefit should
    % run with at the most (see lsqcurvefit documentation)
    iterations = input('Number of iterations for the fitting: ');

    % THE FIT ITSELF : lsqcurvefit trys to fit the function <trEPRTSim_fit>
    % with the initialized fitparameters till it reaches the maximum number
    % of iterations or it reaches the termination tolerance on the function
    % value called TolFun wich is 1.0e-10 (see lsqcurvefit
    % documentation). The final or best parameters are returned in the
    % vector fitout 
    options = optimset('MaxIter',iterations, 'TolFun', 1.0e-10);
    par = lsqcurvefit(@trEPRTSim_fit, par, Bfield, Signal, lb, ub, options);
    
    % Calculate spectrum with final fit parameters.
    [finalfit,DeltaB] = trEPRTSim_sim(par,Bfield);
    % Correcting magnetic field by field offset.
    Bfield = Bfield+DeltaB;
        
    % Calculate difference between fit and signal
    difference = Signal-finalfit; 
        
    % Print fit results
    results = trEPRTSim_fitreport(par,Sys.g);
        
    % PLOTTING: the final fit in comparison to the measured signal
    close(figure(1));
    figure('Name', ['Data from ' filename])
    plot(Bfield,[Signal,finalfit]);
    legend({'Original','Fit'}, 0);
    
    
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
            fprintf(pointer,results);
            fclose(pointer);
            
            % saving figure in the file <probename_simulation.fig>
            saveas(gcf,[samplename,'_simulation.fig']);
            
            % saving data in the file <probename_simulation.dat> by using
            % the double array savingdata which has the form 
            % [Bfield Signal finalfit difference]
            savingdata(:,1) = Bfield;
            savingdata(:,2) = Signal;
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