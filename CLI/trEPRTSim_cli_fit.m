function [dataset, command] = trEPRTSim_cli_fit(varargin)
% TREPRTSIM_CLI_FIT Subfunction of the trEPRTSim CLI handling the fitting
% part. 
%
% Usage
%   trEPRTsim_cli_fit
%   trEPRTSim_cli_fit(dataset)
%   dataset = trEPRTSim_cli_fit
%   dataset = trEPRTSim_cli_fit(dataset)
%   [dataset,<command>] = trEPRTSim_cli_fit(dataset,<command>)
%
%   dataset  - struct
%              Full trEPR toolbox dataset including TSim structure
%
%   command  - string
%              Additional information what to do (bypassing certain loops)
%
% Please note: Currently, only datasets can be read that don't need
% additional parameters for trEPRload, i.e. only datasets contained in a
% single file can be read from within this function.
%
% However, creating a single file containing the dataset of interest is
% quite easy using the following two lines:
%
%   data = trEPRload(<dir>,'combine',true);
%   trEPRsave(<filename>,data);
%
% This will read all files in the directory <dir>, combine them and write
% the result to <filename>. Here, <filename> need not to have an extension.

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-10-07

if nargin % If we have input arguments
    if isstruct(varargin{1})
        dataset = varargin{1};
    end
else
    % Create (empty) dataset
    % TODO: Handle missing parameters, such as field range, ...
    dataset = trEPRTSim_dataset();
end

% Get config values
conf = trEPRTSim_conf();

fitdataloop = true;
while fitdataloop
    
    disp(' ');
    % fitting was chosen
    filename = '';
    while isempty(filename)
        filename = input(sprintf('%s\n%s',...
            'Please enter the filename of the experimental data',...
            'you wish to fit (''q'' to quit): '),'s');
        if strcmpi(filename,'q')
            % Quit
            command = 'exit';
            disp('Goodbye!');
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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Some necessary tests of the dataset loaded, such as 1D or 2D,
    % preprocessing, and selecting slice (in case of 2D)
    
    % Check whether data are 2D or 1D, and in case of 2D, take maximum
    if min(size(data.data)) > 1
        disp(' ');
        disp('2D data detected');
        % For the time being, perform a pretrigger offset compensation on
        % the data... (should be done by the user manually or within the
        % toolbox, respectively.)
        disp(' ');
        disp('Perform pretrigger offset compensation (POC)');
        data.data = trEPRPOC(...
            data.data,data.parameters.transient.triggerPosition);
        % In case of fsc2 data, perform BGC
        if isfield(data,'file') && isfield(data.file,'format') ...
                && strcmpi(data.file.format,'fsc2')
            disp(' ');
            disp('Perform simple background correction (BGC)');
            data.data = trEPRBGC(data.data);
        end
        % Take maximum
        disp(' ');
        disp('Take slice at maximum (if unhappy, provide 1D dataset)');
        [~,idxMax] = max(max(data.data));
        spectrum = data.data(:,idxMax);
    else
        spectrum = data.data;
    end
    disp(' ');
    
    % In case we couldn't read a frequency value from the (too old) fsc2
    % file, ask user to provide a reasonable value...
    if isempty(data.parameters.bridge.MWfrequency.value)
        disp(' ');
        disp('Dataset is missing MW frequency value. Please provide one.');
        MWfreqloop = true;
        MWfreqDefault = 9.70;
        while MWfreqloop
            MWfreq = input(...
                sprintf('MW frequency in GHz [%f]: ',MWfreqDefault),'s');
            if isempty(MWfreq)
                MWfreq = MWfreqDefault;
                data.parameters.bridge.MWfrequency.value = MWfreq;
                data.parameters.bridge.MWfrequency.unit = 'GHz';
                MWfreqloop = false;
            end
            if ~isnan(str2double(MWfreq))
                data.parameters.bridge.MWfrequency.value = ...
                    str2double(MWfreq);
                data.parameters.bridge.MWfrequency.unit = 'GHz';
                MWfreqloop = false;
            end
        end
        disp(' ');
    end
    
    % If MWfrequency is a vector and not a scalar, average
    if ~isscalar(data.parameters.bridge.MWfrequency.value)
        data.parameters.bridge.MWfrequency.value = ...
            mean(data.parameters.bridge.MWfrequency.value);
    end

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    dataset.TSim.sim.Sys
    
    % Merging parameters from experimental dataset.
    data.TSim = dataset.TSim;
    dataset = data;
    clear data;
    
    dataset.TSim.sim.Exp
    
    % Get fit parameters
    parameters = trEPRTSim_fitpar();
    fitpardescription = parameters(:,3);
            
    % Initialize fit parameters in dataset
    dataset = trEPRTSim_fitini(dataset);
    
        
    fitouterloop = true;
    while fitouterloop
        
        fitloop = true;
        while fitloop
            
            fitiniloop = true;
            while fitiniloop
                
                option = [ ...
                    strtrim(cellstr(num2str((1:length(fitpardescription))')))...
                    fitpardescription ...
                    ];
                % Choose fit parameters
                answer = cliMenu(option,...
                    'title','Please chose one or more fit parameters',...
                    'default',num2str(find(dataset.TSim.fit.fitini.tofit)),...
                    'multiple',true);
                
                display(' ');
                
                % Convert answer into tofit parameter in dataset
                dataset.TSim.fit.fitini.tofit = ...
                    zeros(1,length(dataset.TSim.fit.fitini.tofit));
                dataset.TSim.fit.fitini.tofit(str2double(answer)) = 1;
                
                % Initialize fit parameters in dataset
                dataset = trEPRTSim_fitini(dataset);
                
                
                
                valueloop = true;
                while valueloop
                    
                    % Hier kaeme: Display chosen fitting parameters with
                    % values, upper and lower boundaries
                    trEPRTSim_parDisplay(dataset,'fitpar');
                    
                    display(' ');
                    
                    % Ask for different things
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
                            % Change parameters
                            fitiniloop = true;
                            valueloop = false;
                        case 'i'
                            % Change initial values
                            fitiniloop = true;
                            valueloop = true;
                            
                            disp('Please enter new values for the initial values:');
                            for k=1:length(dataset.TSim.fit.inipar)
                                dataset.TSim.fit.inipar(k) = cliInput(...
                                    dataset.TSim.fit.fitini.fitparameters{k},...
                                    'default',num2str(dataset.TSim.fit.inipar(k)),...
                                    'numeric',true);
                            end
                            % Transfer parameters from inipar to fitpar
                            dataset.TSim.fit.fitini.fitpar(...
                                dataset.TSim.fit.fitini.tofit) = ...
                                dataset.TSim.fit.inipar;
                        case 'l'
                            % Lower boundary values
                            fitiniloop = true;
                            valueloop = true;
                            
                            disp('Please enter new values for the lower boundaries:');
                            for k=1:length(dataset.TSim.fit.fitini.lb)
                                dataset.TSim.fit.fitini.lb(k) = cliInput(...
                                    dataset.TSim.fit.fitini.fitparameters{k},...
                                    'default',num2str(dataset.TSim.fit.fitini.lb(k)),...
                                    'numeric',true);
                            end
                        case 'u'
                            % Upper Boundary values
                            fitiniloop = true;
                            valueloop = true;
                            
                            disp('Please enter new values for the upper boundaries:');
                            for k=1:length(dataset.TSim.fit.fitini.ub)
                                dataset.TSim.fit.fitini.ub(k) = cliInput(...
                                    dataset.TSim.fit.fitini.fitparameters{k},...
                                    'default',num2str(dataset.TSim.fit.fitini.ub(k)),...
                                    'numeric',true);
                            end
                        case 'c'
                            % Continue
                            fitiniloop = false;
                            valueloop = false;
                        case 'q'
                            % Quit
                            command = 'exit';
                            disp('Goodbye!');
                            return;
                        otherwise
                            % Shall never happen
                            disp('booo!');
                            
                    end
                    
                    % Initialize fit parameters in dataset
                    dataset = trEPRTSim_fitini(dataset);
                    
                    disp(' ');
                    
                end % valueloop
            end % fitiniloop
            
            fitinnerloop = true;
            while fitinnerloop
                
                fitoptionloop = true;
                while fitoptionloop
                    % TODO: Display fitting options (lsqcurvefit, levenberg-marquardt,
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
                            fitoptionloop = true;
                        case 't'
                            % Change MaxIter
                            TolFun = input(...
                                sprintf('Number of iterations (%i): ',...
                                dataset.TSim.fit.fitopt.TolFun));
                            if ~isempty(MaxIter)
                                dataset.TSim.fit.fitopt.TolFun = TolFun;
                            end
                            fitoptionloop = true;
                            %                                 case 'r'
                            %                                     fitoptionloop = 1;
                            %                                     disp('Not yet implemented.');
                            %                                     fitoptionloop = 1;
                        case 'f'
                            fitoptionloop = false;
                        case 'q'
                            % Quit
                            command = 'exit';
                            disp('Goodbye!');
                            return;
                        otherwise
                            disp('WTF!');
                    end
                end
                
                % Enter purpose
                disp('Enter a purpose:');
                purpose = input('> ','s');
                dataset.TSim.remarks.purpose = purpose;
                
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
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                % Calculate difference between fit and signal
                difference = spectrum-...
                    dataset.calculated*dataset.TSim.sim.Exp.scale;
                
                % Print fit results
                report = trEPRTSim_fitreport(dataset);
                
                disp('');
                
                cellfun(@(x)fprintf('%s\n',x),report);
                
                % PLOTTING: the final fit in comparison to the measured signal
                close(figure(1));
                figure('Name', ['Data from ' filename])
                subplot(6,1,[1 5]);
                plot(...
                    dataset.axes.y.values,...
                    [spectrum,dataset.calculated*dataset.TSim.sim.Exp.scale]);
                legend({'Original','Fit'},'Location','SouthEast');
                subplot(6,1,6);
                plot(dataset.axes.y.values,difference);
                xlabel('{\it magnetic field} / mT')
                subplot(6,1,[1 5]);
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                % Enter comment
                disp('Enter a comment:');
                comment = input('> ','s');
                dataset.TSim.remarks.comment = comment;
                
                % Write history
                % (Orwell style - we're creating our own)
                dataset = trEPRTSim_history('write',dataset);
                
                saveloop = true;
                while saveloop
                    
                    % Ask how to continue
                    option = {... 
                        'a','Save dataset';...
                        % 'r','report parameters';...
                        % 'e','Fit again with fitted values as starting point';...
                        'f','Fit again with fitted values as starting point';...
                        'n','Start new fit with initial values from config';...
                        'b','Start new fit with same initial values as before';...
                        'd','Start a fit with new data';...
                        's','Start a simulation';...
                        'q','Quit'};
                    answer = cliMenu(option,'title',...
                        'How to continue?','default','f');
                    
                    display(' ');
                    
                    switch lower(answer)
                        case 'a'
                            % Suggest reasonable filename
                            [path,name,~] = fileparts(filename);
                            suggestedFilename = fullfile(path,[name '_fit.tez']);
                            % The "easy" way: consequently use CLI
                            saveFilename = input(...
                                sprintf('Filename (%s): ',suggestedFilename),...
                                's');
                            if isempty(saveFilename)
                                saveFilename = suggestedFilename;
                            end
                            % The "convenient" way: Matlab(r) UI:
                            % [saveFilename,pathname] = uiputfile(...
                            % '*.tez','DialogTitle',suggestedFilename);
                            
                            % Save dataset
                            [status] = trEPRsave(saveFilename,dataset);
                            if ~isempty(status)
                                disp('Some problems with saving data');
                            end
                            clear status saveFilename suggestedFilename;
                            saveloop = true;
%                         case 'r'
%                             % show parameters on command line
%                             report = trEPRTSim_fitreport(dataset);
%                             display(report);
%                             saveloop = true;
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
                            fitinnerloop = false;
                            fitloop = true;
                     
                        case 'q'
                            % Quit
                            % Suggest reasonable filename
                            [path,name,~] = fileparts(filename);
                            suggestedFilename = fullfile(...
                                path,[name '_fit-' datestr(now,30) '.tez']);
                            saveFilename = suggestedFilename;
                            % Save dataset
                            [status] = trEPRsave(saveFilename,dataset);
                            if ~isempty(status)
                                disp('Some problems with saving data');
                            end
                            clear status saveFilename suggestedFilename;
                            command = 'exit';
                            disp('Goodbye!');
                            return;
%                         case 'e'
%                             % Write fit results to initial values
%                             dataset.TSim.fit.inipar = ...
%                                 dataset.TSim.fit.fittedpar;
%                             
%                             % Write parameters back to Sys, Exp
%                             dataset = trEPRTSim_par2SysExp(...
%                                 dataset.TSim.fit.fittedpar,...
%                                 dataset);
%                             
%                             % Fit again
%                             saveloop = false;
%                             fitinnerloop = true;
                        case 'n'
                            % New fit with default initial parameters from
                            % config
                            dataset.TSim.sim.Sys = conf.Sys;
                            dataset.TSim.sim.Exp.Temperature = ...
                                conf.Exp.Temperature;
                            dataset = trEPRTSim_SysExp2par(dataset);
                            
                            saveloop = false;
                            fitinnerloop = false;
                        case 'b'
                            % New fit with same initial parameters as before
                            % Write parameters back to Sys, Exp
                            dataset = trEPRTSim_par2SysExp(...
                                dataset.TSim.fit.inipar,...
                                dataset);
                            saveloop = false;
                            fitinnerloop = false;
                        case 'd'
                            % New data
                            saveloop = false;
                            fitinnerloop = false;
                            fitouterloop = false;
                        case 's'
                            % Simulation (with fit values as starting point)
                            command = 'sim';
                            return;
                        otherwise
                            % Shall never happen
                            disp(['You did bullshit... '...
                                'however you managed. '...
                                'Congratulations!']);
                    end
                end % saveloop
            end % fitinnerloop
        end % fitloop
    end % fitouterloop
end % fitdataloop

end
