function [dataset, command] = trEPRTSim_cli_fit(varargin)
% TREPRTSIM_CLI_FIT Subfunction of the trEPRTSim CLI handling the fitting part.
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


% (c) 2013, Deborah Meyer, Till Biskup
% 2013-10-02

if nargin % If we have input arguments
    if isstruct(varargin{1})
        dataset = varargin{1};
    end
else
    % Create (empty) dataset
    % TODO: Handle missing parameters, such as field range, ...
    dataset = trEPRTSim_dataset();
 
end



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
                        % Change parameters
                        fitiniloop = 1;
                        valueloop = 0;
                    case 'i'
                        % Change initial values
                        fitiniloop = 1;
                        valueloop = 1;
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
                        % Lower boundary values
                        fitiniloop = 1;
                        valueloop = 1;
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
                        command = 'exit';
                        disp('Goodbye!');
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
                        % [saveFilename,pathname] = uiputfile(...
                        % '*.tez','DialogTitle',suggestedFilename);
                        
                        % Save dataset
                        [status] = trEPRsave(saveFilename,dataset);
                        if ~isempty(status)
                            disp('Some problems with saving data');
                        end
                        clear status saveFilename suggestedFilename;
                        saveloop = true;
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
                        % TODO: Overwrite inipar
                        conf = trEPRTSim_conf();
                        dataset.TSim.sim.Sys = conf.Sys;
                        dataset = trEPRTSim_SysExp2par(dataset);
                        
                        saveloop = false;
                        fitloop = false;
                    case 'd'
                        % New data
                        saveloop = false;
                        fitloop = false;
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
            end
        end
    end
end
end

