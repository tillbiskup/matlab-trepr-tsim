function [dataset, command] = trEPRTSim_cli_sim(varargin)
% TREPRTSIM_CLI_FIT Subfunction of the trEPRTSim CLI handling the fitting part.
%
% Usage
%   trEPRTsim_cli_sim
%   trEPRTSim_cli_sim(dataset)
%   dataset = trEPRTSim_cli_sim
%   dataset = trEPRTSim_cli_sim(dataset)
%   [dataset,<command>] = trEPRTSim_cli_sim(dataset,<command>)
%
%   dataset  - struct
%              Full trEPR toolbox dataset including TSim structure
%
%   command  - string
%              Additional information what to do (bypassing certain loops)


% (c) 2013, Deborah Meyer, Till Biskup
% 2013-09-16


if nargin % If we have input arguments
    if isstruct(varargin{1})
        dataset = varargin{1};
    end
else
    % Create (empty) dataset
    % TODO: Handle missing parameters, such as field range, ...
    dataset = trEPRTSim_dataset();
 
    % Initialize minimal simulation parameters
    dataset = trEPRTSim_simini(dataset);   
end


simouterloop = true;
while simouterloop == 1
    
    
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
%           'r','Change simulation routine'
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
                command = 'exit';
                return;
            otherwise
                % Shall never happen
                disp('Moron!');
        end
        
    end
    
    % Enter purpose
    disp('Enter a purpose:');
    purpose = input('> ','s');
    dataset.TSim.remarks.purpose = purpose;
    
    % Hier wird simuliert
    % Calculate spectrum
    dataset = trEPRTSim_sim(dataset);
    
    figure(1);
    plot(dataset.axes.y.values,dataset.calculated);
    xlabel('{\it magnetic field} / mT');
    ylabel('{\it intensity} / a.u.');
    
    % Enter comment
    disp('Enter a comment:');
    comment = input('> ','s');
    dataset.TSim.remarks.comment = comment;
    
    
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
                [dataset,command] = trEPRTSim_cli_fit(dataset);
            case 'q'
                % quit
                command = 'exit';
               return;
            otherwise
                % Shall never happen
                simouterloop = true;
        end
    end
end
 

end
