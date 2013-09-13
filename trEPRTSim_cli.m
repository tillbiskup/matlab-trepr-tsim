% TREPRTSIM_CLI CLI for simulating and fitting spin-polarized EPR spectra
% of triplets.
%
% Integral part of the TSim module of the trEPR toolbox.

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-09-13

% For the time being, erase everything in the workspace... (quite rude)
clear all; close all;

% Check for dependencies
[status, missing] = trEPRTSim_dependency();
if (status == 1)
     disp('There are files missing required for the fit:');
     cellfun(@disp, missing);
    return
end

% Read initial values from config file
conf = trEPRTSim_conf;

% Chose wether it shall be simulated or fitted
answer = cliMenu({'f','Fit';'s','Simulate';'q','Quit'},'default','f','title',...
    'Do you wish to simulate or to fit?');

switch answer
    case 'f'
        action = 'fit';
    case 's'
        action = 'sim';
    case 'q'
        disp('Goodbye!');
        return;
    otherwise
        % Shall never happen
        action = '';
end


outerloop = true;
while outerloop
    
    switch lower(action)
        case {'fit','f'}
            
            fitdataloop = 1;
            while fitdataloop == 1
                
                disp(' ');
                % fitting was chosen
                filename = '';
                while isempty(filename)
                    filename = input(sprintf('%s\n%s',...
                        'Please enter the filename of the experimental data',...
                        'you wish to fit (''q'' to quit): '),'s');
                    if strcmpi(filename,'q')
                        % Deborah told me to be too polite...
                        disp('Fuck off and Goodbye!');
                        return;
                    end
                    
                    if ~exist(filename,'file')
                        fprintf('\nFile "%s" not found. Please try again\n\n',...
                            filename);
                        filename = '';
                    end
                end
                
                % Load experimental data using <trEPRload>.
                data = trEPRload(filename);
 
                % Convert Gauss -> mT
                data = trEPRconvertUnits(data,'g2mt');
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                

% AND THERE GOES THE NICE, BEAUTIFUL AND SHINY NEW CLI...

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

% In case we couldn't read a frequency value from the (too old) fsc2 file,
% assume some reasonable value... (that works with the provided example
% files).
if isempty(data.parameters.bridge.MWfrequency.value)
    data.parameters.bridge.MWfrequency.value = 9.67737;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                

                % Create dataset merging parameters from experimental
                % dataset.
                dataset = trEPRTSim_dataset(data);
                
                % Get fit parameters
                parameters = trEPRTSim_fitpar();
                fitpardescription = parameters(:,3);
                
                fitouterloop = 1;
                while fitouterloop == 1
                    
                    fitiniloop = true;
                    while fitiniloop == 1
                        
                        option = [ ...
                            strtrim(cellstr(num2str((1:length(fitpardescription))')))...
                            fitpardescription ...
                            ];
                        % Choose fit parameters
                        answer = cliMenu(option,...
                            'title','Please chose one or more fit parameters',...
                            'default','1, 2, 6, 7','multiple',true);
                        
                        display(' ');
                        
                        % Convert answer into tofit parameter in dataset
                        dataset.TSim.fit.fitini.tofit = ...
                            zeros(1,length(dataset.TSim.fit.fitini.tofit));
                        dataset.TSim.fit.fitini.tofit(str2double(answer)) = 1;
                        
                        % Initialize fit parameters in dataset
                        dataset = trEPRTSim_fitini(dataset);
                        
                        valueloop = true;
                        while valueloop == 1
                            
                            % Hier käme: Display chosen fitting parameters with
                            % values, upper and lower boundaries
                            % trEPRTSim_parDisplay(dataset,'fit');
                        
                            %Ask for different things
                            option = {...
                                'p','Fit different parameters';...
                                'i','Change initial values';...
                                'l','Change lower boundary values';...
                                'u','Change upper boundary values';...
                                'c','Continue';...
                                'q','Quit'};
                            answer = cliMenu(option,'title',...
                                'How to continue?','default','c');
                            
                            display(' ');
                            
                            switch lower(answer)
                                case 'p'
                                    % Parameters
                                    fitiniloop = 1;
                                    valueloop = 0;
                                case 'i'
                                    % Starting values
                                    fitiniloop = 1;
                                    valueloop = 1;
                                    % hier käme: ändere starting values
                                    iniparloop = true;
                                    while iniparloop
                                        disp('Please enter the initial values in the following order:');
                                        disp(parameters(dataset.TSim.fit.fitini.tofit,1)');
                                        inipar = input('> ','s');
                                        inipar = str2num(inipar); %#ok<ST2NM>
                                        if ~any(isnan(inipar)) && ...
                                                (length(inipar) == length(dataset.TSim.fit.inipar))
                                            dataset.TSim.fit.inipar = inipar;
                                            iniparloop = false;
                                        end
                                    end
                                case 'l'
                                    % Lower Boundary values
                                    fitiniloop = 1;
                                    valueloop = 1;
                                    % hier käme: ändere lower boundary values
                                    lbloop = true;
                                    while lbloop
                                        disp('Please enter the lower boundaries in the following order:');
                                        disp(parameters(dataset.TSim.fit.fitini.tofit,1)');
                                        lb = input('> ','s');
                                        lb = str2num(lb); %#ok<ST2NM>
                                        if ~any(isnan(lb)) && ...
                                                (length(lb) == length(dataset.TSim.fit.inipar))
                                            dataset.TSim.fit.fitini.lb = lb;
                                            lbloop = false;
                                        end
                                    end
                                case 'u'
                                    % Upper Boundary values
                                    fitiniloop = 1;
                                    valueloop = 1;
                                    % hier käme: ändere upper boundary values
                                    ubloop = true;
                                    while ubloop
                                        disp('Please enter the upper boundaries in the following order:');
                                        disp(parameters(dataset.TSim.fit.fitini.tofit,1)');
                                        ub = input('> ','s');
                                        ub = str2num(ub); %#ok<ST2NM>
                                        if ~any(isnan(ub)) && ...
                                                (length(ub) == length(dataset.TSim.fit.inipar))
                                            dataset.TSim.fit.fitini.ub = ub;
                                            ubloop = false;
                                        end
                                    end
                                case 'c'
                                    % Continue
                                    fitiniloop = 0;
                                    valueloop = 0;
                                case 'q'
                                    % Quit
                                    return;
                                otherwise
                                    % Shall never happen
                                    disp('booo!');
                                    
                            end
                        end
                    end
                    
                    fitloop = 1;
                    while fitloop == 1
                        
                        fitoptionloop = 1;
                        while fitoptionloop == 1
                            % Hier käme: Display fittingoptions (lsqcurvefit, levenberg-marquardt,
                            % Tolfun,... all die dinge werden momentan gar nicht genutzt,
                            % number of iterations, maxiter)
                            % and simulation routine (pepper,...)
                            
                            % Ask for changes
                            option = {...
%                                 'a','Change fitting algorithm';...
                                'i',sprintf(...
                                    'Change maximum number of iterations (%i)',...
                                    dataset.TSim.fit.fitopt.MaxIter);
                                't',sprintf(...
                                    'Change termination tolerance on the function value (%.2e)',...
                                    dataset.TSim.fit.fitopt.TolFun);...
%                                'r','Change simulation routine';...
                                'f','Start fitting';...
                                'q','Quit'};
                            answer = cliMenu(option,'title',...
                                'How to continue?','default','f');
                            
                            display(' ');
                            
                            switch lower(answer)
%                                 case 'a'
%                                     disp('Not yet implemented.');
%                                     fitoptionloop = 1;
                                case 'i'
                                    % Change MaxIter
                                    MaxIter = input(...
                                        sprintf('Number of iterations (%i): ',...
                                        dataset.TSim.fit.fitopt.MaxIter));
                                    if ~isempty(MaxIter)
                                        dataset.TSim.fit.fitopt.MaxIter = MaxIter;
                                    end
                                    fitoptionloop = 1;
                                case 't'
                                    % Change MaxIter
                                    TolFun = input(...
                                        sprintf('Number of iterations (%i): ',...
                                        dataset.TSim.fit.fitopt.TolFun));
                                    if ~isempty(MaxIter)
                                        dataset.TSim.fit.fitopt.TolFun = TolFun;
                                    end
                                    fitoptionloop = 1;
%                                 case 'r'
%                                     fitoptionloop = 1;
%                                     disp('Not yet implemented.');
%                                     fitoptionloop = 1;
                                case 'f'
                                    fitoptionloop = 0;
                                case 'q'
                                    % Quit
                                    return;
                                otherwise
                                    disp('WTF!');
                            end
                            
                        end
                        
                        % Finally: START FITTING! YEAH!
                        % Took us six bloody weeks to come to this point...
                        options = optimset(dataset.TSim.fit.fitopt);
                        fitfun = @(x,Bfield)trEPRTSim_fit(x,Bfield,spectrum,dataset);
                        dataset.TSim.fit.fittedpar = lsqcurvefit(fitfun, ...
                            dataset.TSim.fit.inipar, ...
                            dataset.axes.y.values, ...
                            spectrum, ...
                            dataset.TSim.fit.fitini.lb, ...
                            dataset.TSim.fit.fitini.ub, ...
                            options);
                        
                        dataset = trEPRTSim_par2SysExp(...
                            dataset.TSim.fit.fittedpar,...
                            dataset);
                        
                        % Calculate spectrum with final fit parameters.
                        dataset = trEPRTSim_sim(dataset);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Calculate difference between fit and signal
    difference = spectrum-dataset.calculated; 
        
    % Print fit results
    report = trEPRTSim_fitreport(dataset);
    
    disp('');
    
    cellfun(@(x)fprintf('%s\n',x),report);
    
    % PLOTTING: the final fit in comparison to the measured signal
    close(figure(1));
    figure('Name', ['Data from ' filename])
    plot(...
        dataset.axes.y.values,...
        [spectrum,dataset.calculated*dataset.TSim.sim.Exp.scale]);
    legend({'Original','Fit'},'Location','SouthEast');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
                        % Write history
                        % (Orwell style - we're creating our own)
                        dataset = trEPRTSim_history('write',dataset);
                        
                        saveloop = true;
                        while saveloop
                            
                            % Ask how to continue
                            option = {...
                                'a','Save dataset';...
                                'f','Fit again with fitted values as starting point';...
                                'n','Start new fit from beginning';...
                                'd','Start a fit with new data';...
                                's','Start a simulation';...
                                'q','Quit'};
                            answer = cliMenu(option,'title',...
                                'How to continue?','default','f');
                            
                            display(' ');
                            
                            switch lower(answer)
                                case 'a'
                                    % Suggest reasonable filename
                                    [path,name,ext] = fileparts(filename);
                                    suggestedFilename = fullfile(path,[name '_fit.tez']);
                                    % The "easy" way: consequently use CLI
                                    saveFilename = input(...
                                        sprintf('Filename (%s): ',suggestedFilename),...
                                        's');
                                    if isempty(saveFilename)
                                        saveFilename = suggestedFilename;
                                    end
                                    % The "convenient" way: Matlab(r) UI:
%                                     [saveFilename,pathname] = uiputfile(...
%                                         '*.tez','DialogTitle',suggestedFilename);
                                    % Save dataset
                                    [status] = trEPRsave(saveFilename,dataset);
                                    if ~isempty(status)
                                        disp('Some problems with saving data');
                                    end
                                    clear status saveFilename suggestedFilename;
                                    saveloop = true;
                                case 'q'
                                    % quit
                                    return;
                                case 'f'
                                    % Write fit results to initial values
                                    dataset.TSim.fit.inipar = ...
                                        dataset.TSim.fit.fittedpar;
                                    % Write parameters back to Sys, Exp
                                    dataset = trEPRTSim_par2SysExp(...
                                        dataset.TSim.fit.fittedpar,...
                                        dataset);
                                    % Fit again
                                    saveloop = false;
                                    fitloop = true;
                                case 'n'
                                    % New fit
                                    saveloop = false;
                                    fitloop = false;
                                case 'd'
                                    % New data
                                    saveloop = false;
                                    fitloop = false;
                                    fitouterloop = false;
                                case 's'
                                    % Simulation (with fit values as starting point)
                                    saveloop = false;
                                    fitouterloop = false;
                                    fitloop = false;
                                    fitdataloop = false;
                                    action = 'sim';
                                    break;
                                otherwise
                                    % Shall never happen
                                    disp(['You did bullshit... '...
                                        'however you managed. '...
                                        'Congratulations!']);
                            end
                        end
                    end
                end
            end
            
            display(' ');
            
        case {'sim','s'}

            % Create (empty) dataset
            % TODO: Handle missing parameters, such as field range, ...
            dataset = trEPRTSim_dataset();

            simouterloop = true;
            while simouterloop == 1
                
                disp(' ');
                
                % Simulation was chosen
                % Hier käme: Initialize minimal simulation parameters trEPRTSim_simini
                dataset = trEPRTSim_simini(dataset);

                siminiloop = true;
                while siminiloop == 1
                    
                    % Display minimal set of simulation parameters with
                    % their initial values
                    disp('The simulation parameters currently chosen:')
                    trEPRTSim_parDisplay(dataset,'sim');
                    
                    disp(' ');
                    
                    % Werte ändern oder Zahl der Parameter ändern oder simulieren
                    option ={...
                        'v','Change values of chosen simulation parameters';...
                        'p','Choose additional simulation parameters';...
%                         'r','Change simulation routine'
                        's','Start simulation';...
                        'q','Quit'};
                    answer = cliMenu(option, 'default','s');
                    
                    switch lower(answer)
                        case 'v'
                            % Change values

                            disp('Sorry, not implemented yet... come back later.');
                            disp(' ');
                            
                            siminiloop = 1;
                        case 'p'
                            % Display all possible simulation parameters with
                            % their initial values
                            disp('All possible simulation parameters:')
                            trEPRTSim_parDisplay(dataset,'simall');
                            
                            display(' ');
                            % Change parameters
                            addParams = input('Additional parameters: ','s');
                            
                            disp('Sorry, not implemented yet... come back later.');
                            disp(' ');
                            
                            siminiloop = 1;
                        case 'r'
                            % Change simulation routine
                            siminiloop = 1;
                        case 's'
                            % Simulate
                            siminiloop = 0;
                        case 'q'
                            % Quit
                            return;
                        otherwise
                            % Shall never happen
                            disp('Moron!');
                    end
                    
                end
                
                % Hier wird simuliert
                % Calculate spectrum
                dataset = trEPRTSim_sim(dataset);
                
                figure(1);
                plot(dataset.axes.y.values,dataset.calculated);
                xlabel('{\it magnetic field} / mT');
                ylabel('{\it intensity} / a.u.');
                        
                % Write history
                % (Orwell style - we're creating our own)
                dataset = trEPRTSim_history('write',dataset);
                
                saveloop = true;
                while saveloop
                    option = {...
                        'a','Save dataset';...
                        'n','Start a new simulation';...
                        'f','Start a fit';...
                        'q','Quit'};
                    answer = cliMenu(option,'title',...
                        'How to continue?','default','q');
                    
                    display(' ')
                    
                    switch lower(answer)
                        case 'a'
                            % Suggest reasonable filename
                            suggestedFilename = fullfile(pwd,['trEPRTSim_'...
                                datestr(now,'yyyy-mm-dd_HH-MM') '_sim.tez']);
                            % The "easy" way: consequently use CLI
                            saveFilename = input(...
                                sprintf('Filename (%s): ',suggestedFilename),...
                                's');
                            if isempty(saveFilename)
                                saveFilename = suggestedFilename;
                            end
                            % The "convenient" way: Matlab(r) UI:
%                             [saveFilename,pathname] = uiputfile(...
%                                 '*.tez','DialogTitle',suggestedFilename);
                            % Save dataset
                            [status] = trEPRsave(saveFilename,dataset);
                            if ~isempty(status)
                                disp('Some problems with saving data');
                            end
                            clear status saveFilename suggestedFilename;
                            saveloop = true;
                            simouterloop = 1;
                        case 'n'
                            % New simulation
                            simouterloop = 1;
                            saveloop = false;
                        case 'f'
                            % Start fit
                            saveloop = false;
                            simouterloop = false;
                            action = 'fit';
                        case 'q'
                            % quit
                            return;
                        otherwise
                            % Shall never happen
                            simouterloop = true;
                    end
                end
            end
            
    end
    
end



