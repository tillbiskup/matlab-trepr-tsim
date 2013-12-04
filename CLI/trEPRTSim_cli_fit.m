function [expdataset, command] = trEPRTSim_cli_fit(varargin)
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
% 2013-12-03

% If we have input arguments
if nargin
    if isstruct(varargin{1})
        simdataset = varargin{1};
        expdataset = simdataset;
        
        option = {'n','new data';'a','already loaded data'};
        answer = cliMenu(option,...
            'title','Do you wish to fit your already loaded data, or rather load new data?',...
            'default','a');
        
        switch lower(answer)
            case 'a'
                % überspringe loaddataloop
                loaddataloop = false;
            case 'n'
                % load new data
                loaddataloop = true;
        end
    end
else
    % Create (empty) dataset
    % TODO: Handle missing parameters, such as field range, ...
    expdataset = trEPRTSim_dataset();
    
    % Get config values
    conf = trEPRTSim_conf();
    
    loaddataloop = true;
end


fitdataloop = true;
while fitdataloop
    
    
    while loaddataloop
        
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
        
        % Load experimental data using <trEPRTSim_load>
        expdataset = trEPRTSim_load(filename);
        
        
        
        loaddataloop = false;
    end
    
    % Get fit parameters
    parameters = trEPRTSim_fitpar();
    fitpardescription = parameters(:,3);
    
    % Initialize fit parameters in dataset
    expdataset = trEPRTSim_fitini(expdataset);
    
    
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
                    'default',num2str(find(expdataset.TSim.fit.fitini.tofit)),...
                    'multiple',true);
                
                display(' ');
                
                % Convert answer into tofit parameter in dataset
                expdataset.TSim.fit.fitini.tofit = ...
                    zeros(1,length(expdataset.TSim.fit.fitini.tofit));
                expdataset.TSim.fit.fitini.tofit(str2double(answer)) = 1;
                
                % Initialize fit parameters in dataset
                expdataset = trEPRTSim_fitini(expdataset);
                
                
                
                valueloop = true;
                while valueloop
                    
                    % Hier kaeme: Display chosen fitting parameters with
                    % values, upper and lower boundaries
                    trEPRTSim_parDisplay(expdataset,'fitpar');
                    
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
                            for k=1:length(expdataset.TSim.fit.inipar)
                                expdataset.TSim.fit.inipar(k) = cliInput(...
                                    expdataset.TSim.fit.fitini.fitparameters{k},...
                                    'default',num2str(expdataset.TSim.fit.inipar(k)),...
                                    'numeric',true);
                            end
                            % Transfer parameters from inipar to fitpar
                            expdataset.TSim.fit.fitini.fitpar(...
                                expdataset.TSim.fit.fitini.tofit) = ...
                                expdataset.TSim.fit.inipar;
                        case 'l'
                            % Lower boundary values
                            fitiniloop = true;
                            valueloop = true;
                            
                            disp('Please enter new values for the lower boundaries:');
                            for k=1:length(expdataset.TSim.fit.fitini.lb)
                                expdataset.TSim.fit.fitini.lb(k) = cliInput(...
                                    expdataset.TSim.fit.fitini.fitparameters{k},...
                                    'default',num2str(expdataset.TSim.fit.fitini.lb(k)),...
                                    'numeric',true);
                            end
                        case 'u'
                            % Upper Boundary values
                            fitiniloop = true;
                            valueloop = true;
                            
                            disp('Please enter new values for the upper boundaries:');
                            for k=1:length(expdataset.TSim.fit.fitini.ub)
                                expdataset.TSim.fit.fitini.ub(k) = cliInput(...
                                    expdataset.TSim.fit.fitini.fitparameters{k},...
                                    'default',num2str(expdataset.TSim.fit.fitini.ub(k)),...
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
                    expdataset = trEPRTSim_fitini(expdataset);
                    
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
                        expdataset.TSim.fit.fitopt.MaxIter);
                        't',sprintf(...
                        'Change termination tolerance on the function value (%.2e)',...
                        expdataset.TSim.fit.fitopt.TolFun);...
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
                                expdataset.TSim.fit.fitopt.MaxIter));
                            if ~isempty(MaxIter)
                                expdataset.TSim.fit.fitopt.MaxIter = MaxIter;
                            end
                            fitoptionloop = true;
                        case 't'
                            % Change MaxIter
                            TolFun = input(...
                                sprintf('Number of iterations (%i): ',...
                                expdataset.TSim.fit.fitopt.TolFun));
                            if ~isempty(MaxIter)
                                expdataset.TSim.fit.fitopt.TolFun = TolFun;
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
                expdataset.TSim.remarks.purpose = purpose;
                
                
                % Define spectrum
                % Check whether data are 2D or 1D, and in case of 2D, take maximum
                if min(size(expdataset.data)) > 1
                    % Take maximum
                    [~,idxMax] = max(max(expdataset.data));
                    spectrum = expdataset.data(:,idxMax);
                else
                    spectrum = expdataset.data;
                end
                
                
                
                % Finally: START FITTING! YEAH!
                % Took us six bloody weeks to come to this point...
                options = optimset(expdataset.TSim.fit.fitopt);
                fitfun = @(x,Bfield)trEPRTSim_fit(x,Bfield,spectrum,expdataset);
                expdataset.TSim.fit.fittedpar = lsqcurvefit(fitfun, ...
                    expdataset.TSim.fit.inipar, ...
                    expdataset.axes.y.values, ...
                    spectrum, ...
                    expdataset.TSim.fit.fitini.lb, ...
                    expdataset.TSim.fit.fitini.ub, ...
                    options);
                
                expdataset = trEPRTSim_par2SysExp(...
                    expdataset.TSim.fit.fittedpar,...
                    expdataset);
                
                % Calculate spectrum with final fit parameters.
                expdataset = trEPRTSim_sim(expdataset);
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                % Calculate difference between fit and signal
                difference = spectrum-...
                    expdataset.calculated*expdataset.TSim.sim.Exp.scale;
                
                % Print fit results
                report = trEPRTSim_fitreport(expdataset);
                
                disp('');
                
                cellfun(@(x)fprintf('%s\n',x),report);
                
                % PLOTTING: the final fit in comparison to the measured signal
                close(figure(1));
                figure('Name', ['Data from ' expdataset.file.name])
                subplot(6,1,[1 5]);
                plot(...
                    expdataset.axes.y.values,...
                    [spectrum,expdataset.calculated*expdataset.TSim.sim.Exp.scale]);
                legend({'Original','Fit'},'Location','SouthEast');
                subplot(6,1,6);
                plot(expdataset.axes.y.values,difference);
                xlabel('{\it B_{0}} / mT','fontsize',20);
                
                subplot(6,1,[1 5]);
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                % Enter comment
                disp('Enter a comment:');
                comment = input('> ','s');
                expdataset.TSim.remarks.comment = comment;
                
                % Write history
                % (Orwell style - we're creating our own)
                expdataset = trEPRTSim_history('write',expdataset);
                
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
                            [path,name,~] = fileparts(expdataset.file.name);
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
                            [status] = trEPRTSim_save(saveFilename,expdataset);
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
                            expdataset.TSim.fit.inipar = ...
                                expdataset.TSim.fit.fittedpar;
                            
                            % Write parameters back to Sys, Exp
                            expdataset = trEPRTSim_par2SysExp(...
                                expdataset.TSim.fit.fittedpar,...
                                expdataset);
                            
                            % Fit again
                            saveloop = false;
                            fitinnerloop = false;
                            fitloop = true;
                            
                        case 'q'
                            % Quit
                            % Suggest reasonable filename
                            [path,name,~] = fileparts(expdataset.file.name);
                            suggestedFilename = fullfile(...
                                path,[name '_fit-' datestr(now,30) '.tez']);
                            saveFilename = suggestedFilename;
                            % Save dataset
                            [status] = trEPRTSim_save(saveFilename,expdataset);
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
                            expdataset.TSim.sim.Sys = conf.Sys;
                            expdataset.TSim.sim.Exp.Temperature = ...
                                conf.Exp.Temperature;
                            expdataset = trEPRTSim_SysExp2par(expdataset);
                            
                            saveloop = false;
                            fitinnerloop = false;
                        case 'b'
                            % New fit with same initial parameters as before
                            % Write parameters back to Sys, Exp
                            expdataset = trEPRTSim_par2SysExp(...
                                expdataset.TSim.fit.inipar,...
                                expdataset);
                            saveloop = false;
                            fitinnerloop = false;
                        case 'd'
                            % New data
                            saveloop = false;
                            fitinnerloop = false;
                            fitouterloop = false;
                            loaddataloop = true;
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

