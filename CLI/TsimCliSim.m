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
% 2015-08-26

% Empty fit branch of TSim structure
tempdataset = TsimDataset();
dataset.TSim.fit = tempdataset.TSim.fit;


simouterloop = true;
while simouterloop
   
            disp('How many Triplets should be simulated');
            NumOfTrip = input('> ','s');
            NumOfTrip = str2double(NumOfTrip);
   
    
     celldatasets = cell(1,NumOfTrip);
      
    for Triplet = 1:NumOfTrip
       
        celldatasets{Triplet} = dataset ;
        siminiloop = true;
        while siminiloop
            [celldatasets{Triplet}, siminiloop, quit] = TsimIniSimCli(celldatasets{Triplet});
            if quit
                % Quit
                disp('Goodbye!');
                return;
            end
        end  % siminiloop
        
    end % for loop over number of triplets
   
    % Enter purpose
    disp(' ');
    disp('Enter a purpose:');
    purpose = input('> ','s');
   
    celldatasets{Triplet}.TSim.remarks.purpose = purpose;
    
    
    % Calculate spectrum (actual simulation)
    
    for Triplet = 1:NumOfTrip
        celldatasets{Triplet} = TsimSim(celldatasets{Triplet});
      
        figure(Triplet)
        h = TsimMakeShinyPicture(celldatasets{Triplet});
        set(h,'Tag',['superSimulationFigure', num2str(Triplet)]);
        
    end % for loop over number of triplets
        
if length(celldatasets) ~= 1
       
    weighting = ones(1,length(celldatasets));
        
        superpositionloop = true;
        while superpositionloop
            superdataset = TsimMakeSuperposition(celldatasets, weighting);
                     
            figure(Triplet + 1)
            c = TsimMakeShinyPicture(superdataset);
            set(c,'Tag','superPositionSimulationFigure');
            
            disp('Your current weithing is:');
            disp(' ');
            disp(weighting);
            disp(' ');
            
            prompt = 'Please enter values for weighting the simulations. Hit enter for return';
            answerstr = cliInput(prompt);
            
            if  isempty(answerstr)
                superpositionloop = false;
                dataset = superdataset;
            else
                weighting = str2num(answerstr);
                superpositionloop = true;
                
            end
        end  % superpositionloop
else
    dataset = celldatasets{1};
    
    figure();
    h = TsimMakeShinyPicture(dataset);
    set(h,'Tag','simulationFigure');
end
    
    
    % Enter comment
    disp('Enter a comment:');
    comment = input('> ','s');
    if iscell(dataset.TSim)
        dataset.TSim{1}.remarks.comment = comment;
    else
        dataset.TSim.remarks.comment = comment;
    end
    
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
                    clear status saveFilename suggestedFilename;
                  
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
                disp(dataset.TSim.sim.routine);
                disp(' ')
                oldRoutine = dataset.TSim.sim.routine;
                dataset = TsimChangeSimRoutine(dataset);
                newRoutine = dataset.TSim.sim.routine;
                
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

