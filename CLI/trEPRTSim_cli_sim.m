function [simdataset, command] = trEPRTSim_cli_sim(varargin)
% TREPRTSIM_CLI_SIM Subfunction of the trEPRTSim CLI handling the
% simulation part.
%
% If the user decides at some point to start a fit with the given
% simulation parameters, control is handed back to the caller.
%
% Usage
%   trEPRTsim_cli_sim
%   trEPRTSim_cli_sim(expdataset)
%   expdataset = trEPRTSim_cli_sim
%   expdataset = trEPRTSim_cli_sim(expdataset)
%   [expdataset,<command>] = trEPRTSim_cli_sim(expdataset,<command>)
%
%   dataset  - struct
%              Full trEPR toolbox dataset including TSim structure
%
%   command  - string
%              Additional information what to do (bypassing certain loops)

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-12-03

if nargin % If we have input arguments
    if isstruct(varargin{1})
        expdataset = varargin{1};
        simdataset = expdataset;
        
        % Optional display of experimental data to look at while
        % simulating
        option = {'y','Yes';'n','No'};
        answer = cliMenu(option, 'title','Do you wish to display your experimental data?','default','y');
        
        disp(' ');
        
        switch lower(answer)
            case 'y'
                
                % Plotting of the already loaded experimental spectrum
                close(figure(1));
                plot(expdataset.axes.y.values,expdataset.data)
                legend({'Originaldata'},'Location','SouthEast');
                
            case 'n'
                % do nothing
        end
        
    end
else
    % Create (empty) dataset
    simdataset = trEPRTSim_dataset();
    

    % Optional Loading of potential experimental data to look at while
    % simulating
    option = {'y', 'Yes';'n','No'};
    answer = cliMenu(option,'title','Do you wish to load experimental data?','default','n');
    
    disp(' ');
    
    switch lower(answer)
        case 'y'
            
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
            
            % Load experimental data using <trEPRTSim_load>.
            expdataset = trEPRTSim_load(filename);
            
            
            % Plotting of maxima experimental spectrum
            [~,idxMax] = max(max(expdataset.data));
            close(figure(1));
            plot(expdataset.axes.y.values,expdataset.data(:,idxMax))
            legend({'Originaldata'},'Location','SouthEast');
            
            
        case 'n'
            % do nothing
    end
     
    
end

simouterloop = true;
while simouterloop
    
    % Get config values, also done in trEPRTSim_simini
    % conf = trEPRTSim_conf();
    
    % Initialize minimal simulation parameters
    simdataset = trEPRTSim_simini(simdataset); 
    
    
    siminiloop = true;
    while siminiloop
        
        disp(' ');
        
        % Display minimal set of simulation parameters with
        % their initial values
        disp('The simulation parameters currently chosen:')
        trEPRTSim_parDisplay(simdataset,'sim');
        
        disp(' ');
        
        % Change values, numbers of simulation parameters, or start
        % simulation (changing simulation routine not implemented yet)
        option ={...
            'v','Change values of chosen simulation parameters';...
            'p','Choose different simulation parameters';...
            %           'r','Change simulation routine'
            's','Start simulation';...
            'q','Quit'};
        answer = cliMenu(option, 'default','s');
        
        disp(' ');
        
        switch lower(answer)
            case 'v'
                % Change values
                
                % Get simulation parameters
                simpar = trEPRTSim_simpar;
                
                % Select only the additional ones
                addsimpar = simpar(~[simpar{:,5}],:);
                
                addsimpar2change = addsimpar(...
                    ismember(addsimpar(:,1),simdataset.TSim.sim.addsimpar),:);
                if ~isempty(addsimpar2change)
                    par2change = [simpar([simpar{:,5}],:) ; addsimpar2change];
                else
                    par2change = simpar([simpar{:,5}],:);
                end
                
                % Temporarily get Sys,Exp as direct structures
                Sys = simdataset.TSim.sim.Sys;
                Exp = simdataset.TSim.sim.Exp;
               
                
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
                simdataset.TSim.sim.Sys = Sys;
                simdataset.TSim.sim.Exp = Exp;
                clear Sys Exp
                
                % Change parameters
                simdataset = trEPRTSim_simini(simdataset);
            case 'p'
                % Choose different simulation parameters
                % Idea: similar as in fit, show all possible parameters
                 
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
                        simdataset.TSim.sim.addsimpar),1))
                    defaultAddSimPar = ...
                        num2str(length(addsimpardescription)+1);
                else
                    defaultAddSimPar = ...
                        num2str(find(ismember(addsimpar(:,1),...
                        simdataset.TSim.sim.addsimpar))');
                end
                
                answer = cliMenu(option,...
                    'title','Please chose simulation parameters',...
                    'default',defaultAddSimPar,'multiple',true);
                
                if str2double(answer) < length(addsimpardescription)+1
                    simdataset.TSim.sim.addsimpar = ...
                        addsimpar(str2double(answer),1);
                else
                    simdataset.TSim.sim.addsimpar = {};
                end
                
                % Change parameters
                simdataset = trEPRTSim_simini(simdataset);
                
                siminiloop = true;
            case 'r'
                % Change simulation routine
                siminiloop = true;
            case 's'
                % Start simulation
                siminiloop = false;
            case 'q'
                % Quit
                command = 'exit';
                disp('Goodbye!');
                return;
            otherwise
                % Shall never happen
                disp('Moron!');
        end
    end % siminiloop
    
    % Enter purpose
    disp('Enter a purpose:');
    purpose = input('> ','s');
    simdataset.TSim.remarks.purpose = purpose;
    
    % Calculate spectrum (actual simulation)
    simdataset = trEPRTSim_sim(simdataset);
    
    figure();
    plot(linspace(...
        simdataset.TSim.sim.Exp.Range(1),...
        simdataset.TSim.sim.Exp.Range(2),...
        simdataset.TSim.sim.Exp.nPoints ...
        ),simdataset.calculated);
    xlabel('{\it magnetic field} / mT');
    ylabel('{\it intensity} / a.u.');
    
    % Enter comment
    disp('Enter a comment:');
    comment = input('> ','s');
    simdataset.TSim.remarks.comment = comment;
    
    % Write history
    % (Orwell style - we're creating our own)
    simdataset = trEPRTSim_history('write',simdataset);
    
    saveloop = true;
    while saveloop
        option = {...
            'a','Save dataset';...
            'n','Start a new simulation';...
            'f','Start a fit';...
            'q','Quit'};
        answer = cliMenu(option,'title',...
            'How to continue?','default','n');
        
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
                [status] = trEPRTSim_save(saveFilename,simdataset);
                if ~isempty(status)
                    disp('Some problems with saving data');
                end
                clear status saveFilename suggestedFilename;
                saveloop = true;
                simouterloop = true;
            case 'n'
                % New simulation
                simouterloop = 1;
                saveloop = false;
            case 'f'
                % Start fit - give therefore control back to caller
                % Transfer TSim structure from simdataset into expdataset
                expdataset.TSim = simdataset.TSim;
                simdataset = expdataset;
                command = 'fit';
                return;
            case 'q'
                % Quit
                % Automatically save dataset to default filename
                % Suggest reasonable filename
                if exist('filename','var')
                    [path,name,~] = fileparts(filename);
                    suggestedFilename = fullfile(...
                        path,[name '_sim-' datestr(now,30) '.tez']);
                else
                    suggestedFilename = fullfile(...
                        pwd,['sim-' datestr(now,30) '.tez']);
                end
                saveFilename = suggestedFilename;
                % Save dataset
                [status] = trEPRTSim_save(saveFilename,simdataset);
                if ~isempty(status)
                    disp('Some problems with saving data');
                end
                clear status saveFilename suggestedFilename;
                command = 'exit';
                disp('Goodbye!');
                return;
            otherwise
                % Shall never happen
                disp('Something very strange happened...')
                simouterloop = true;
        end
    end % saveloop
end % simouterloop

end
