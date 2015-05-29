function dataset = TsimCliSim(dataset)
% TSIMCLISIM Subfunction of the Tsim CLI handling the
% simulation part.
%
% If the user decides at some point to start a fit with the given
% simulation parameters, control is handed back to the caller.
%
% Usage
%   dataset = TsimCliSim(dataset)
%
%   dataset  - struct
%              Full trEPR toolbox dataset including Tsim structure
%

% Copyright (c) 2013-15, Deborah Meyer, Till Biskup
% 2015-05-29



simouterloop = true;
while simouterloop
        
    % Initialize minimal simulation parameters
    dataset = TsimIniSimpar(dataset);
        
    siminiloop = true;
    while siminiloop
        
        disp(' ');
        
        % Display current set of simulation parameters with
        % their values
        disp('The simulation parameters currently chosen:')
        
        disp(' ');
        
        TsimParDisplay(dataset,'sim');
        
        disp(' ');
        
        % Change values, numbers of simulation parameters, or start
        % simulation (changing simulation routine not implemented yet)
        option ={...
            'v','Change values of chosen simulation parameters';...
            'p','Choose additional simulation parameters';...
            'r','Change simulation routine'
            's','Start simulation';...
            'q','Quit'};
        answer = cliMenu(option, 'default','s');
        
        disp(' ');
        
        switch lower(answer)
            case 'v'
                % Change values
                dataset = TsimChangeSimValues(dataset);
                siminiloop = true;
            case 'p'
                % Choose different simulation parameters
                dataset = TsimChangeSimpar(dataset);
                siminiloop = true;
            case 'r'
                % Change simulation routine
                dataset = TsimChangeSimRoutine(dataset);           
                siminiloop = true;
            case 's'
                % Start simulation
                siminiloop = false;
            case 'q'
                % Quit
                disp('Goodbye!');
                return;
            otherwise
                % Shall never happen
                disp('Moron!');
        end
    end % siminiloop
    
    % Enter purpose
    disp(' ');
    disp('Enter a purpose:');
    purpose = input('> ','s');
    dataset.TSim.remarks.purpose = purpose;
    
    % Calculate spectrum (actual simulation)
    dataset = TsimSim(dataset);
    
    figure();
    plot(linspace(...
        dataset.TSim.sim.EasySpin.Exp.Range(1),...
        dataset.TSim.sim.EasySpin.Exp.Range(2),...
        dataset.TSim.sim.EasySpin.Exp.nPoints ...
        ),dataset.calculated);
    xlabel('{\it magnetic field} / mT');
    ylabel('{\it intensity} / a.u.');
    
    % Enter comment
    disp('Enter a comment:');
    comment = input('> ','s');
    dataset.TSim.remarks.comment = comment;
    
    % Write history
    % (Orwell style - we're creating our own)
    dataset = TsimHistory('write',dataset);
    
    saveloop = true;
    while saveloop
        option = {...
            'a','Save dataset';...
            'n','Start a new simulation';...
            'f','Start a fit using your simulation values as starting values';...
            'q','Quit'};
        answer = cliMenu(option,'title',...
            'How to continue?','default','n');
        
        display(' ')
        
        switch lower(answer)
            case 'a'
                % Suggest reasonable filename
                suggestedFilename = fullfile(pwd,['Tsim'...
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
                simouterloop = true;
            case 'n'
                % New simulation
                simouterloop = 1;
                saveloop = false;
            case 'f'
%                 
%                 % Start fit - give therefore control back to caller
%                 % Test if there is experimental data and if there is
%                 % transfer TSim structure from simdataset into expdataset        
%                 if ~exist('expdataset','var');
%                     command = 'fit';
%                     return;
%                 end
%                 
%                 if ~isempty(simdataset.data);
%                     expdataset.TSim = simdataset.TSim;
%                     simdataset = expdataset;
%                 end
%                 command = 'fit';
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
                [status] = trEPRsave(saveFilename,dataset);
                if ~isempty(status)
                    disp('Some problems with saving data');
                end
                clear status saveFilename suggestedFilename;
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

