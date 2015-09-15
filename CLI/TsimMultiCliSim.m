function dataset = TsimMultiCliSim(dataset)
% TSIMMULTICLISIM Subfunction of the TsimMulti CLI handling the
% simulation part.
%
% If the user decides at some point to start a fit with the given
% simulation parameters, control is handed back to the caller.
%
% Usage
%   dataset = TsimMultiCliSim(dataset)
%
%   dataset  - struct
%              Full trEPR toolbox dataset including Tsim structure
%

% Copyright (c) 2013-15, Deborah Meyer, Till Biskup
% 2015-09-15

% Empty fit branch of Tsim structure
tempdataset = TsimDataset();
dataset.Tsim.fit = tempdataset.Tsim.fit;


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
   
    celldatasets{Triplet}.Tsim(1).remarks.purpose = purpose;
    
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
           
            superdataset = TsimMultiMakeSuperposition(celldatasets, weighting);
                   
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
    
    for counter = 1:length(dataset.Tsim)
    dataset.Tsim(counter).remarks.comment = comment;
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
                    datestr(now,'yyyy-mm-dd_HH-MM') '_simMulti.tez']);
                % The "easy" way: consequently use CLI
                saveFilename = input(...
                    sprintf('Filename (%s): ',suggestedFilename),...
                    's');
                if isempty(saveFilename)
                    saveFilename = suggestedFilename;
                end
                % Save dataset
                % Clear tempSpectrum onyl in dataset that is saved
                savedataset = dataset;
                for counter =1:length(savedataset.Tsim)
                    savedataset.Tsim(counter).fit.spectrum.tempSpectrum = [];
                end
                [status] = trEPRsave(saveFilename,savedataset);
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
                
                
                
                
                if ~ishandle(h)
                    disp('You stupid git deleted your figure!')
                    saveloop = true;
                    continue
                end
                % Suggest reasonable filename
                [path,name,~] = fileparts(dataset.file.name);
                suggestedFilename = fullfile(path,[name '_simMulti']);
                % The "easy" way: consequently use CLI
                saveFilename = input(...
                    sprintf('Filename (%s): ',suggestedFilename),...
                    's');
                if isempty(saveFilename)
                    saveFilename = suggestedFilename;
                end
                % Put FigureFileName in Dataset
                for counter = 1:length(dataset.Tsim)
                    dataset.Tsim(counter).results.figureFileName = [saveFilename '-fig'];
                end
                % Export figure as .pdf and as .fig
                
                commonFigureExport(h,[saveFilename '-fig']);
                
                % Save dataset
                % Clear tempSpectrum onyl in dataset that is saved
                savedataset = dataset;
                for counter =1:length(savedataset.Tsim)
                    savedataset.Tsim(counter).fit.spectrum.tempSpectrum = [];
                end
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
                disp(dataset.Tsim(1).sim.routine);
                disp(' ')
                oldRoutine = dataset.Tsim(1).sim.routine;
                dataset = TsimChangeSimRoutine(dataset);
                newRoutine = dataset.Tsim(1).sim.routine;
                
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

