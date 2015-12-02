function MultiDataset = TsimCliFit(MultiDataset)
% TSIMCLIFIT Subfunction of the Tsim CLI handling the fitting
% part.
%
% Usage
%   dataset=TsimCliFit(dataset)
%
%   dataset  - struct
%              Full trEPR toolbox dataset including Tsim structure
%

% Copyright (c) 2013-15, Deborah Meyer, Till Biskup
% 2015-09-14



fitouterloop = true;
while fitouterloop
    
    % Check if 2d or 1d data
    % Fitsection can be defined for each datset individually
    for numberOfDatasets = 1:length(MultiDataset)
        if size(MultiDataset{numberOfDatasets}.data) > 1
            [MultiDataset{numberOfDatasets}, quit] = TsimDefineFitsection(MultiDataset{numberOfDatasets});
            if quit
                % Quit
                disp('Goodbye!');
                return;
            end
        else
            % 1D data
            MultiDataset{numberOfDatasets}.Tsim.fit.spectrum.tempSpectrum = MultiDataset{numberOfDatasets}.data;
            MultiDataset{numberOfDatasets}.Tsim.fit.spectrum.tempSpectrum = MultiDataset{numberOfDatasets}.Tsim.fit.spectrum.tempSpectrum./sum(abs(MultiDataset{numberOfDatasets}.Tsim.fit.spectrum.tempSpectrum));
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% only once the simulation parameters and fit parameters are initialized,
% since it is a global fit
% This is done in the firs dataset of the MultiDataset
disp('')
disp('Please choose simulation and fitparameters for all your datasets')
disp('')
disp('The values of parameters that are in a fixed realtion to each other are for the first spectrum')
disp('')

Firstdataset = MultiDataset{1};

    siminiloop = true;
    while siminiloop
        [Firstdataset, siminiloop, quit ] = TsimIniSimCli(Firstdataset);
        if quit
            % Quit
            disp('Goodbye!');
            return;
        end
    end % siminiloop
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    % Take care of diffrent range of spectra in eache dataset and put in
    % the routin in every dataset
    routine = Firstdataset.Tsim.sim.routine;
    for bla = 1:length(MultiDataset)
        MultiDataset{bla}.Tsim.sim.routine = routine;
        MultiDataset{bla} = TsimIniSimpar(MultiDataset{bla});
    end
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Fitparameters are initialized
    Firstdataset = TsimIniFitpar(Firstdataset);
    
    fitinnerloop = true;
    while fitinnerloop
        
        fitiniloop = true;
        while fitiniloop
               
            disp(' ');
            
            % Display current set of fitting parameters with
            % their values and boundaries
            disp('Simulation parameters currently released for fitting in the wild:')
            
            disp(' ');
            TsimParDisplay(Firstdataset,'fit');
            disp(' ');
            
            % Change some things
            option ={...
                'p','Choose different/additional simulation parameters released for fitting';...
                'i','Change initial values'
                'b','Change boundary values'
                'c','continue'
                'q','Quit'};
            answer = cliMenu(option, 'default','c');
            
            disp(' ');
            
            switch lower(answer)
                case 'i'
                    % Change values of simulationparameters for fit
                    Firstdataset = TsimChangeSimValues(Firstdataset);
                    
                    % Copy Values from Simpar to fitpar inivalue
                    Firstdataset = TsimCopySimparValues2Initialvalue(Firstdataset);
                    
                    % Check if boundaries are compatible with inivalue and possibly change them
                    Firstdataset = TsimCheckBoundaries(Firstdataset);
                    
                    fitiniloop = true;
                case 'p'
                    % Choose different/additional fitting parameters
                    Firstdataset = TsimChangeFitpar(Firstdataset);
                    
                    % Copy Values from Simpar to fitpar inivalue
                    Firstdataset = TsimCopySimparValues2Initialvalue(Firstdataset);
                    
                    % Change Boundaries according to fitparvector with values
                    % from config
                    Firstdataset = TsimMakeBoundaries(Firstdataset);
                    
                    % Check if boundaries are compatible with inivalue and possibly change them
                    Firstdataset = TsimCheckBoundaries(Firstdataset);
                    
                    fitiniloop = true;
                case 'b'
                    % Change boundary
                    Firstdataset = TsimChangeBoundary(Firstdataset);
                    
                    fitiniloop = true;
                case 'c'
                    % Continue
                    fitiniloop = false;
                case 'q'
                    % Quit
                    disp('Goodbye!');
                    return;
                otherwise
                    % Shall never happen
                    disp('Moron!');
            end
            
        end
       
        fitalgorithmloop = true;
        while fitalgorithmloop
      
            disp('Additional fitting Parameters currently initialized')
            disp(' ');
            TsimParDisplay(Firstdataset,'opt');
            disp(' ');
            
            
            % Change some things
            option ={...
                'w','Define regions in your spectrum that are weighted differently';...
                'i','Change maximum number of iterations'
                't','Change termination tolerance on the function value'
                'f','Change maximum number of function calls'
                's','Start fitting'
                'q','Quit'};
            answer = cliMenu(option, 'default','s');
            
            disp(' ');
            
            switch lower(answer)
                case 'w'
                    % weight regions differently
                    Firstdataset = TsimDefineWeightRegion(Firstdataset);
                    Firstdataset = TsimWeightSpectrum(Firstdataset,'spectrum');
                    fitalgorithmloop = true;
                case 'i'
                    % Max number of iterations
                    Firstdataset = TsimChangeFitopt(Firstdataset,'MaxIter');
                    fitalgorithmloop = true;
                case 't'
                    % Change termination tolerance
                    Firstdataset = TsimChangeFitopt(Firstdataset,'TolFun');
                    fitalgorithmloop = true;
                case 'f'
                    % Maximum Number of function calls
                    Firstdataset = TsimChangeFitopt(Firstdataset,'MaxFunEval');
                    fitalgorithmloop = true;
                case 's'
                    % start fitting
                    fitalgorithmloop = false;
                case 'q'
                    % Quit
                    disp('Goodbye!');
                    return;
                otherwise
                    % Shall never happen
                    disp('Moron!');
            end
            
        end % fitalgorithmloop
        
        % Enter purpose
        disp(' ');
        display('Enter a purpose:');
        purpose = input('> ','s');
        disp(' ');
        Firstdataset.Tsim.remarks.purpose = purpose;
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Here we take care of the global fit stuff
        MultiDataset{1} = Firstdataset;
        MultiDataset = TsimChooseParametersWithFixedRelations(MultiDataset);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Fitting
        MultiDataset = TsimFit(MultiDataset);
        
        % Pardisplay
        for bla = 1:length(MultiDataset)
            TsimMakeShinyPicture(MultiDataset{bla});
            set(gcf,'Tag',['TsimGlobal' num2str(bla)]);
            disp(' ');
            TsimParDisplay(MultiDataset{bla},'fitreport');
            disp(' ');
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Enter comment
        disp('Enter a comment:');
        comment = input('> ','s');
        
        for bla = 1:length(MultiDataset)
            MultiDataset{bla}.Tsim.remarks.comment = comment;
            
            % Write history
            % (Orwell style - we're creating our own)
            MultiDataset{bla} = TsimHistory('write',MultiDataset{bla});
        end
        saveloop = true;
        while saveloop
            
            assignin('base', 'Multidataset', MultiDataset)
            
            % Ask how to continue
            option = {...
                'a','Save dataset';...
                'r','Export figure, save dataset and create report';...
                'w','Write parameters to configuration';...
                ' ',' ';...
                'f','Start new fit with final values as starting point';...
                'i','Start new fit with same initial values as before' ;...
                ' ',' ';...
                's','Start new fit with final values as starting point using a different simulation routine';...
                ' ',' ';...
                'q','Quit';...
                'e','Exit; No autosaving'};
            
            
            answer = cliMenu(option,'title',...
                'How to continue?','default','f');
            
            disp(' ');
            
            
            switch lower(answer)
                case 'a'
                    % Suggest reasonable filename
                    suggestedFilename = fullfile(pwd,['Tsim'...
                        datestr(now,'yyyy-mm-dd_HH-MM') '_fit.tez']);
                    % The "easy" way: consequently use CLI
                    saveFilename = input(...
                        sprintf('Filename (%s): ',suggestedFilename),...
                        's');
                    if isempty(saveFilename)
                        saveFilename = suggestedFilename;
                    end
                    % Save dataset
                    % Clear tempSpectrum onyl in dataset that is saved
                    savedataset = MultiDataset;
                    savedataset.Tsim.fit.spectrum.tempSpectrum = [];
                    [status] = trEPRsave(saveFilename,savedataset);
                    if ~isempty(status)
                        disp('Some problems with saving data');
                    end
                    clear status saveFilename suggestedFilename savedataset;
                    
                    saveloop = true;
                case 'r'
                    
                    for bla = 1:length(MultiDataset)
                        % Suggest reasonable filename
                        [path,name,~] = fileparts(MultiDataset{bla}.file.name);
                        suggestedFilename = fullfile(path,[name '_fit']);
                        % The "easy" way: consequently use CLI
                        saveFilename = input(...
                            sprintf('Filename (%s): ',suggestedFilename),...
                            's');
                        if isempty(saveFilename)
                            saveFilename = suggestedFilename;
                        end
                        
                        pff = findobj('-regexp','Tag',['TsimGlobal' num2str(bla)]);
                        
                        
                        % Put FigureFileName in Dataset
                        MultiDataset{bla}.Tsim.results.figureFileName = [saveFilename '-fig'];
                        
                        % Export figure as .pdf and as .fig
                        
                        commonFigureExport(pff,[saveFilename '-fig']);
                        
                        % Save dataset
                        % Clear tempSpectrum onyl in dataset that is saved
                        savedataset = MultiDataset{bla};
                        savedataset.Tsim.fit.spectrum.tempSpectrum = [];
                        [status] = trEPRsave(saveFilename,savedataset);
                        if ~isempty(status)
                            disp('Some problems with saving data');
                        end
                        
                    end
                    
                    % Make Reports
                    for bla = 1:length(MultiDataset)
                    TsimReport(MultiDataset{bla},'template','TsimFitReport-de.tex');
                    end
                    
                    clear status saveFilename suggestedFilename savedataset;
                    
                    saveloop = true;
                case 'w'
                    % Write Parameters in Config
                    TsimSimpar2ConfigFile(MultiDataset{1})
                    saveloop = true;
                    
                    
                    
                case 'f'
                    
                    for bla = 1:length(MultiDataset)
                        pff = findobj('-regexp','Tag',['TsimGlobal' num2str(bla)]);
                        if ishandle(pff)
                            close(pff);
                        end
                    end
                    % Don't clear tempSpectrum
                    % Copy Values from Simpar to fitpar inivalue
                    for bla = 1:length(MultiDataset)
                        MultiDataset{bla} = TsimCopySimparValues2Initialvalue(MultiDataset{bla});
                        
                        % Check if boundaries are compatible with inivalue and possibly change them
                        MultiDataset{bla} = TsimCheckBoundaries(MultiDataset{bla});
                    end
                    % Fit again
                    saveloop = false;
                    
                case 'i'
                    for bla = 1:length(MultiDataset)
                        pff = findobj('-regexp','Tag',['TsimGlobal' num2str(bla)]);
                        if ishandle(pff)
                            close(pff);
                        end
                    end
                    % Don't clear tempSpectrum
                    % New fit with same initial parameters as before
                    for bla = 1:length(MultiDataset)
                        MultiDataset{bla} = TsimFitpar2simpar(MultiDataset{bla}.Tsim.fit.initialvalue,MultiDataset{bla});
                        MultiDataset{bla} = TsimApplyConventions(MultiDataset{bla});
                        
                    end
                    % Fit again
                    saveloop = false;
                    
                    
                case 's'
                    
                    for bla = 1:length(MultiDataset)
                        pff = findobj('-regexp','Tag',['TsimGlobal' num2str(bla)]);
                        if ishandle(pff)
                            close(pff);
                        end
                    end
                    % New fit with final values as starting parameters but
                    % different simulation routine, same section
                    disp('The simulation routines currently in use:')
                    disp(' ')
                    disp(MultiDataset{1}.Tsim.sim.routine);
                    disp(' ')
                    
                    oldRoutine = MultiDataset{1}.Tsim.sim.routine;
                    MultiDataset{1} = TsimChangeSimRoutine(MultiDataset{1});
                    newRoutine = MultiDataset{1}.Tsim.sim.routine;
                    for bla = 1:length(MultiDataset)
                        MultiDataset{bla}.Tsim.sim.routine = newRoutine;
                    end
                    
                    if ~strcmpi(oldRoutine,newRoutine)
                        % Check simpar and possibly change it but don't change
                        % values
                        for bla = 1:length(MultiDataset)
                            MultiDataset{bla} = TsimCleanUpSimpar(MultiDataset{bla},oldRoutine);
                            % Check fitpar. Is there a parameter that is now not
                            % possible anymore. Change fitpar and analogously lb and
                            % ub.
                            MultiDataset{bla} = TsimKickOutFitpar(MultiDataset{bla});
                            
                            %Clear initialvalues
                            MultiDataset{bla}.Tsim.fit.initialvalues = [];
                        end
                        
                    end
                    
                    for bla = 1:length(MultiDataset)
                        % Copy Values from Simpar to fitpar inivalue
                        MultiDataset{bla} = TsimCopySimparValues2Initialvalue(MultiDataset{bla});
                        
                        % Check if boundaries are compatible with inivalue and possibly change them
                        MultiDataset{bla} = TsimCheckBoundaries(MultiDataset{bla});
                    end
                    saveloop = false;
                    fitinnerloop = false;
                    
                case 'q'
                    
                    for bla = 1:length(MultiDataset)
                        pff = findobj('-regexp','Tag',['TsimGlobal' num2str(bla)]);
                        if ishandle(pff)
                            close(pff);
                        end
                    end
                    % Quit
                    % Suggest reasonable filename
                    % Clear tempSpectrum
                    for bla = 1:length(MultiDataset)
                        MultiDataset{bla}.Tsim.fit.spectrum.tempSpectrum = [];
                        [path,name,~] = fileparts(MultiDataset{bla}.file.name);
                        suggestedFilename = fullfile(...
                            path,[name '_fit-' datestr(now,30) '.tez']);
                        saveFilename = suggestedFilename;
                        % Save dataset
                        [status] = TsimSave(saveFilename,MultiDataset{bla});
                        if ~isempty(status)
                            disp('Some problems with saving data');
                        end
                        clear status saveFilename suggestedFilename;
                        disp('Goodbye!');
                    end
                    return
                case 'e'
                    
                    for bla = 1:length(MultiDataset)
                        pff = findobj('-regexp','Tag',['TsimGlobal' num2str(bla)]);
                        brr = findobj('-regexp','Tag',['TsimGlobalExp' num2str(bla)]);
                        if ishandle(pff)
                            close(pff);
                        end
                        if ishandle(brr)
                            close(brr);
                        end
                        
                        MultiDataset{bla}.Tsim.fit.spectrum.tempSpectrum = [];
                    end
                    % Quit without saving
                    % Clear tempSpectrum
                    
                    disp('Goodbye!');
                    return,
                otherwise
                    
                    for bla = 1:length(MultiDataset)
                        pff = findobj('-regexp','Tag',['TsimGlobal' num2str(bla)]);
                        if ishandle(pff)
                            close(pff);
                        end
                    end
                    
                    % Shall never happen
                    disp(['You did bullshit... '...
                        'however you managed. '...
                        'Congratulations!']);
            end
        end % saveloop
    end % fitinnerloop
end % fitouterloop

end




