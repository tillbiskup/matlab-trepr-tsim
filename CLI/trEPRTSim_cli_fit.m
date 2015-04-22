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

% Copyright (c) 2013-15, Deborah Meyer, Till Biskup
% 2015-04-22

% If we have input arguments
% simdataset = varargin{1};
% expdataset = simdataset;

% colordefinitions for picture
simlinecolor = [0 0.6 0];
explinecolor = [0 0 0];
zerolinecolor = [0.5 0.5 0.5];
residuumlinecolor = [0 0 1];


if nargin
    if isstruct(varargin{1})
        expdataset = varargin{1};
        
        
        % Test if there is experimental data
        if ~isempty(expdataset.data);
        
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
        else % only simulation was made
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
        [expdataset, status] = trEPRTSim_load(filename);
        if status
            loaddataloop = true;
        else
            loaddataloop = false;
        end
       
    end % loaddataloop
    
    
    % Initialize minimal simulation parameters
    expdataset = trEPRTSim_simini(expdataset); 

    siminiloop = true;
    while siminiloop
        
 
        
        % Display minimal set of simulation parameters with
        % their initial values
        disp('The parameters for simulation are as follow:')
        trEPRTSim_parDisplay(expdataset,'sim');
        
        disp(' ');
        option ={...
            'v','Change values of chosen simulation parameters';...
            'p','Choose additional simulation parameters';...
            'c','Continue';...
            'q','Quit'};
        answer = cliMenu(option, 'default','c');
        
        disp(' ');
        
        switch lower(answer)
            case 'v'
                % Change values
                % Get simulation parameters
                simpar = trEPRTSim_simpar;
                
                % Select only the additional ones
                addsimpar = simpar(~[simpar{:,5}],:);
                
                addsimpar2change = addsimpar(...
                    ismember(addsimpar(:,1),expdataset.TSim.sim.addsimpar),:);
                if ~isempty(addsimpar2change)
                    par2change = [simpar([simpar{:,5}],:) ; addsimpar2change];
                else
                    par2change = simpar([simpar{:,5}],:);
                end
                
                % Temporarily get Sys,Exp as direct structures
                Sys = expdataset.TSim.sim.Sys;
                Exp = expdataset.TSim.sim.Exp;
                Opt = expdataset.TSim.sim.Opt;
                
                
                par2changeValues = cell(1,length(par2change));
                for k=1:length(par2change)
                    par2changeValues{k} = eval(par2change{k,2});
                end
                
                disp('Please enter new values for the parameters:');
                for k=1:length(par2change)
                    par2changeValues{k} = cliInput(par2change{k,1},...
                        'default',num2str(par2changeValues{k}),...
                        'numeric',true);
                end
                % Assign (changed) values back to Sys and Exp
                % Need to do that after all values are present
                for k=1:length(par2change)
                    switch par2change{k,1}
                        case {'D','E'}
                            D = par2changeValues{...
                                ismember(par2change(:,1),{'D'})};
                            E = par2changeValues{...
                                ismember(par2change(:,1),{'E'})};
                            Sys.D = [-D/3+E -D/3-E 2*D/3];
                        otherwise
                            eval([par2change{k,2} '=' ...
                                ['[' num2str(par2changeValues{k}) ']'] ';']);
                    end
                end
                expdataset.TSim.sim.Sys = Sys;
                expdataset.TSim.sim.Exp = Exp;
                expdataset.TSim.sim.Opt = Opt;
                clear Sys Exp Opt
                
                % Change parameters
                expdataset = trEPRTSim_simini(expdataset);
            case 'p'
                % Choose additional simulation parameters
                % Get simulation parameters
                simpar = trEPRTSim_simpar;
                % Select only the additional ones
                addsimpar = simpar(~[simpar{:,5}],:);
                addsimpardescription = addsimpar(:,3);
                option = [ ...
                    strtrim(cellstr(num2str((1:length(addsimpardescription)+1)')))...
                    [addsimpardescription ; 'No additional parameters'] ...
                    ];
                
                % Get default value, depending on "addsimpar" value
                if isempty(find(ismember(addsimpar(:,1),...
                        expdataset.TSim.sim.addsimpar),1))
                    defaultAddSimPar = ...
                        num2str(length(addsimpardescription)+1);
                else
                    defaultAddSimPar = ...
                        num2str(find(ismember(addsimpar(:,1),...
                        expdataset.TSim.sim.addsimpar))');
                end
                
                answer = cliMenu(option,...
                    'title','Please chose additional simulation parameters',...
                    'default',defaultAddSimPar,'multiple',true);
                
                if str2double(answer) < length(addsimpardescription)+1
                    expdataset.TSim.sim.addsimpar = ...
                        addsimpar(str2double(answer),1);
                else
                    expdataset.TSim.sim.addsimpar = {};
                end
                
                % Change parameters
                expdataset = trEPRTSim_simini(expdataset);
                siminiloop = true;
                
            case 'q'
                % Quit
                command = 'exit';
                disp('Goodbye!');
                return;
            case 'c'
                % contiue
               siminiloop = false;
            otherwise
                % Shall never happen
                disp('Moron!');
        end
        
        
    end % siminiloop

   
    % Get fit parameters
    fitparameters = trEPRTSim_fitpar();
    fitpardescription = fitparameters(:,3);
    
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
                
                disp(' ');
                
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
                            
                            % User could also write a string that is not a
                            % number; which then causes pepper to crash
                            % since value of parameter is NaN
                            disp('Please enter new values for the initial values:');
                            for k=1:length(expdataset.TSim.fit.inipar)
                                expdataset.TSim.fit.inipar(k) = trEPRguiSanitiseNumericInput(cliInput(...
                                    expdataset.TSim.fit.fitini.fitparameters{k},...
                                    'default',num2str(expdataset.TSim.fit.inipar(k)),...
                                    'numeric',false));
                                
                            end
                            % Transfer parameters from inipar to fitpar
                            expdataset.TSim.fit.fitini.fitpar(...
                                expdataset.TSim.fit.fitini.tofit) = ...
                                expdataset.TSim.fit.inipar;
                        case 'l'
                            % Lower boundary values
                            fitiniloop = true;
                            valueloop = true;
                            
                            % User could also write a string that is not a
                            % number; which then causes pepper to crash
                            % since value of parameter is NaN
                            disp('Please enter new values for the lower boundaries:');
                            for k=1:length(expdataset.TSim.fit.fitini.lb)
                                expdataset.TSim.fit.fitini.lb(k) = trEPRguiSanitiseNumericInput(cliInput(...
                                    expdataset.TSim.fit.fitini.fitparameters{k},...
                                    'default',num2str(expdataset.TSim.fit.fitini.lb(k)),...
                                    'numeric',false));
                            end
                        case 'u'
                            % Upper Boundary values
                            fitiniloop = true;
                            valueloop = true;
                            
                            % User could also write a string that is not a
                            % number; which then causes pepper to crash
                            % since value of parameter is NaN
                            disp('Please enter new values for the upper boundaries:');
                            for k=1:length(expdataset.TSim.fit.fitini.ub)
                                expdataset.TSim.fit.fitini.ub(k) = trEPRguiSanitiseNumericInput(cliInput(...
                                    expdataset.TSim.fit.fitini.fitparameters{k},...
                                    'default',num2str(expdataset.TSim.fit.fitini.ub(k)),...
                                    'numeric',false));
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
                
                cutoutloop = true;
                  m = 1;
                while cutoutloop
                  
                    option = {'r', 'cut out a region of spectrum';...
                        'c','continue'};
                    answer = cliMenu(option,'title','Tills wish shall be granted...',...
                        'default','c');
                    
                    display(' ');
                    
                    switch lower(answer)
                        case 'c'
                            % Do nothing
                            cutoutloop = false;
                        case 'r'
                            % Cut out a region
                            InitialValue = input(...
                                sprintf('Initial Value in mT:'));
                            
                            if ~isempty(InitialValue)
                                expdataset.TSim.fit.fitcut.cutpoints(m,1) = InitialValue;
                            end
                            
                            FinalValue = input(...
                                sprintf('Final Value in mT:'));
                            
                            if ~isempty(FinalValue)
                                expdataset.TSim.fit.fitcut.cutpoints(m,2) = FinalValue;
                            end
                            display(' ');
                            m = m+1;
                            
                           expdataset = trEPRTSim_fitcut(expdataset);
                            
                            cutoutloop = true;
                        otherwise
                            disp('Hab Mist gemacht')
                            
                    end
                    
                end % Cutoutloop
                
                
                
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
                            % Change TolFun
                            TolFun = input(...
                                sprintf('TolFun (%i): ',...
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
                    % Set maximum in calculation structure
                    expdataset.calculation.position = idxMax;
                else
                    spectrum = expdataset.data;
                end
                
                % Check if someone has mutilated spectrum
                if ~isempty(expdataset.TSim.fit.fitcut.mutilatedData)
                    spectrum = expdataset.TSim.fit.fitcut.mutilatedData;
                    Bfield = expdataset.TSim.fit.fitcut.mutilatedField;
                else
                    Bfield = expdataset.axes.y.values;
                end
                
                % Finally: START FITTING! YEAH!
                % Took us six bloody weeks to come to this point...
                set(gcf,'DefaultAxesColorOrder',[explinecolor; simlinecolor]);
                options = optimset(expdataset.TSim.fit.fitopt);
                fitfun = @(x,Bfield)trEPRTSim_fit(x,Bfield,spectrum,expdataset);
                expdataset.TSim.fit.fittedpar = lsqcurvefit(fitfun, ...
                    expdataset.TSim.fit.inipar, ...
                    Bfield, ...
                    spectrum, ...
                    expdataset.TSim.fit.fitini.lb, ...
                    expdataset.TSim.fit.fitini.ub, ...
                    options);
                
                % Normalize Populations
                %expdataset = trEPRTSim_normalizePopulations(expdataset);
                
                expdataset = trEPRTSim_par2SysExp(...
                    expdataset.TSim.fit.fittedpar,...
                    expdataset);
                
                
                
                % Calculate spectrum with final fit parameters.
                expdataset = trEPRTSim_sim(expdataset);
                
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                % Calculate difference between fit and signal
                % Check if someone has mutilated spectrum
                if ~isempty(expdataset.TSim.fit.fitcut.mutilatedData)
                    if min(size(expdataset.data)) > 1
                        % Take maximum
                        [~,idxMax] = max(max(expdataset.data));
                        spectrum = expdataset.data(:,idxMax);
                    else
                        spectrum = expdataset.data;
                    end
                end
                difference = spectrum-...
                    expdataset.calculated*expdataset.TSim.sim.Exp.scale;
                
                % Print fit results
                report = trEPRTSim_fitreport(expdataset);
                
                disp('');
                
                cellfun(@(x)fprintf('%s\n',x),report);
                
                % PLOTTING: the final fit in comparison to the measured signal
                close(figure(1));
                %set(gcf,'DefaultAxesColorOrder',[explinecolor; simlinecolor]);
                figure('Name', ['Data from ' expdataset.file.name])
                
                %%%%%%%%%%%%%
                zeroLineProperties = struct(...
                    'Color',zerolinecolor,...
                    'LineStyle','--', ...
                    'LineWidth',1 ...
                    );
           
                %%%%%%%%%%%%%
                set(gcf,'DefaultAxesColorOrder',[explinecolor; simlinecolor]);
                subplot(6,1,[1 5]);
                plot(...
                    expdataset.axes.y.values,...
                    [spectrum,expdataset.calculated*expdataset.TSim.sim.Exp.scale],...
                    'LineWidth',1);
                legend({'Original','Fit'},'Location','SouthEast');
                set(gca,'XTickLabel',{})
                addZeroLines(zeroLineProperties)
                subplot(6,1,6);
                plot(expdataset.axes.y.values,difference,'LineWidth',1,'Color',residuumlinecolor);
                xlabel('{\it magnetic field} / mT');
                addZeroLines(zeroLineProperties)
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
                        'e','Export figure';...
                        % 'e','Fit again with fitted values as starting point';...
                        'f','Fit again with fitted values as starting point';...
                        'n','Start new fit with initial values from config';...
                        'b','Start new fit with same initial values as before';...
                        'd','Start a fit with new data';...
                        's','Start a simulation';...
                        'q','Quit'};
                    

                    answer = cliMenu(option,'title',...
                        'How to continue?','default','f');
                    
                    disp(' ');
                    
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
                            close(figure(1));
                            saveloop = true;
                            %                         case 'r'
                            %                             % show parameters on command line
                            %                             report = trEPRTSim_fitreport(dataset);
                            %                             display(report);
                            %                             saveloop = true;
                        case 'e'
                            % Get figure handel
                            h = gcf;
                            % Suggest reasonable filename
                            [path,name,~] = fileparts(expdataset.file.name);
                            suggestedFilename = fullfile(path,[name '_fit']);
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
                            
                            % Export figure as .fig and as .pdf
                            [status] = fig2file(h, saveFilename, 'fileType', 'fig' );
                            if ~isempty(status)
                                disp('Some problems with exporting fig-figure');
                            end
                            [status] = fig2file(h, saveFilename, 'fileType', 'pdf' );
                            if ~isempty(status)
                                disp('Some problems with exporting pdf-figure');
                            end
                            clear status saveFilename suggestedFilename;
                            close(figure(1));
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
                            
                            close(figure(1));
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
                            close(figure(1));
                            saveloop = false;
                            fitinnerloop = false;
                        case 'b'
                            % New fit with same initial parameters as before
                            % Write parameters back to Sys, Exp
                            expdataset = trEPRTSim_par2SysExp(...
                                expdataset.TSim.fit.inipar,...
                                expdataset);
                            close(figure(1));
                            saveloop = false;
                            fitinnerloop = false;
                        case 'd'
                            % New Fit with New data
                            close(figure(1));
                            saveloop = false;
                            fitinnerloop = false;
                            fitloop = false;
                            fitouterloop = false;
                            fitdataloop = true;
                            loaddataloop = true;
                        case 's'
                            % Simulation (with fit values as starting point)
                            close(figure(1));
                            command = 'sim';
                            return;
                        otherwise
                            % Shall never happen
                            disp(['You did bullshit... '...
                                'however you managed. '...
                                'Congratulations!']);
                    end
                end % saveloop
                
                % Clear fitcut
                expdataset.TSim.fit.fitcut = structfun(@(x)[],...
                    expdataset.TSim.fit.fitcut,'UniformOutput',false);
                
            end % fitinnerloop
        end % fitloop
    end % fitouterloop
end % fitdataloop

end


function addZeroLines(lineProperties)

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');

hLine = [];

if prod(xLimits) <= 0
    hold on
    hLine(end+1) = line([0 0],yLimits);
    hold off
end

if prod(yLimits) <= 0
    hold on
    hLine(end+1) = line(xLimits,[0 0]);
    hold off
end

% Set line properties
for lHandle = 1:length(hLine)
    set(hLine(lHandle),lineProperties);
end

end
