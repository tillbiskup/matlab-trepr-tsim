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
            'r','Export figure and report parameters';...
            'n','Start a new simulation';...
            'c','Write parameters to configuration'
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
            case 'c'
                % Write Parameters in Config
                TsimSimpar2ConfigFile(dataset)
                saveloop = true;
                simouterloop = true;
            case 'r'
                % figureexport and report
                % Get figure handel
                    h = gcf;
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
                    clear status saveFilename suggestedFilename;
                    close(figure(1));
                saveloop = true;
                simouterloop = true;
            case 'n'
                % New simulation
                simouterloop = true;
                saveloop = false;        
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
            case 'e'
                % Quit without saving
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

