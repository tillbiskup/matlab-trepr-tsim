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
% 2015-09-14

% Empty fit branch of Tsim structure
tempdataset = TsimDataset();
dataset.Tsim.fit = tempdataset.Tsim.fit;

simouterloop = true;
while simouterloop
        
        
    siminiloop = true;
    while siminiloop
        [dataset, siminiloop, quit] = TsimIniSimCli(dataset);
        if quit
            % Quit
            disp('Goodbye!');
            return;
        end
    end % siminiloop
    
    % Enter purpose
    disp(' ');
    disp('Enter a purpose:');
    purpose = input('> ','s');
    dataset.Tsim.remarks.purpose = purpose;
    
    % Calculate spectrum (actual simulation)
    dataset = TsimSim(dataset);
    figure();
    h = TsimMakeShinyPicture(dataset);
    set(h,'Tag','simulationFigure');
    
    % Enter comment
    disp('Enter a comment:');
    comment = input('> ','s');
    dataset.Tsim.remarks.comment = comment;
    
    % Write history
    % (Orwell style - we're creating our own)
    dataset = TsimHistory('write',dataset);
    
    saveloop = true;
    while saveloop
        option = {...
            'a','Save dataset';...
            'r','Export figure and report parameters';...
            'n','Start a new simulation with same routine';...
            's','Start a new simulation with different routine';...
            'w','Write parameters to configuration'
            'q','Quit';...
            'e','Exit; No autosaving'};
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
                % Save dataset
                [status] = trEPRsave(saveFilename,dataset);
                if ~isempty(status)
                    disp('Some problems with saving data');
                end
                clear status saveFilename suggestedFilename;
                saveloop = true;
                simouterloop = true;
            case 'w'
                % Write Parameters in Config
                TsimSimpar2ConfigFile(dataset)
                saveloop = true;
                simouterloop = true;
            case 'r'
                % figureexport and report
                % Suggest reasonable filename
                [path,name,~] = fileparts(dataset.file.name);
                suggestedFilename = fullfile(path,[name '_simfig']);
                % The "easy" way: consequently use CLI
                saveFilename = input(...
                    sprintf('Filename (%s): ',suggestedFilename),...
                    's');
                if isempty(saveFilename)
                    saveFilename = suggestedFilename;
                end
                
                % Export figure as .fig and as .pdf
                [status] = fig2file(h, saveFilename, 'fileType', 'fig' );
                if ~isempty(status)
                    disp('Some problems with exporting fig-figure');
                end
                [status] = fig2file(h, saveFilename, 'fileType', 'pdf' );
                if ~isempty(status)
                    disp('Some problems with exporting pdf-figure');
                end
                
                % Save dataset
                % Clear tempSpectrum onyl in dataset that is saved
                savedataset = dataset;
                savedataset.Tsim.fit.spectrum.tempSpectrum = [];
                [status] = trEPRsave(saveFilename,savedataset);
                if ~isempty(status)
                    disp('Some problems with saving data');
                end
                
                % Make Report
                TsimReport(dataset,'template','TsimSimReport-de.tex');
                
                clear status saveFilename suggestedFilename savedataset;
                if ishandle(h)
                    close(h);
                end
                
                saveloop = true;
                simouterloop = true;
                
            case 'n'
                % New simulation
                
                simouterloop = true;
                saveloop = false;
                
            case 's'
                % New simulation different routine but same parameters
               
                if ishandle(h)
                    close(h);
                end
                disp('The simulation routines currently in use:')
                disp(' ')
                disp(dataset.Tsim.sim.routine);
                disp(' ')
                oldRoutine = dataset.Tsim.sim.routine;
                dataset = TsimChangeSimRoutine(dataset);
                newRoutine = dataset.Tsim.sim.routine;
                
                if ~strcmpi(oldRoutine,newRoutine)
                    % Check simpar and possibly change it but don't change
                    % values
                    dataset = TsimCleanUpSimpar(dataset,oldRoutine);
                end
                
                
                simouterloop = true;
                saveloop = false;
                %
            case 'q'
                % Quit
                % Automatically save dataset to default filename
                % Suggest reasonable filename
               
                if ishandle(h)
                    close(h);
                end
                
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
                disp('Goodbye! Your dataset has been saved.');
                return;
            case 'e'
              
                if ishandle(h)
                    close(h);
                end
                % Quit without saving
                disp('Goodbye!');
                return;
            otherwise
               
                if ishandle(h)
                    close(h);
                end
                % Shall never happen
                disp('Something very strange happened...')
                simouterloop = true;
        end
    end % saveloop
end % simouterloop

end

