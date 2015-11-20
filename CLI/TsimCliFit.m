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
        
        h = TsimMakeShinyPicture(MultiDataset);
        
        % Pardisplay
        disp(' ');
        TsimParDisplay(MultiDataset,'fitreport');
        disp(' ');
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
        % Enter comment
        disp('Enter a comment:');
        comment = input('> ','s');
        MultiDataset.Tsim.remarks.comment = comment;
        
       
        % Write history
        % (Orwell style - we're creating our own)
        MultiDataset = TsimHistory('write',MultiDataset);
        
        saveloop = true;
        while saveloop
            
            % Ask how to continue
            option = {...
                'a','Save dataset';...
                'r','Export figure, save dataset and create report';...
                'w','Write parameters to configuration';...
                ' ',' ';...
                'f','Start new fit with final values as starting point';...
                'i','Start new fit with same initial values as before' ;...
                'p','Start new fit on different position in your 2-D data with final values as starting point';...
                'c','Start new fit on different position in your 2-D data with initial values from configuration';...
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
                    % Get figure handel
                    if ~ishandle(h)
                        disp('You stupid git deleted your figure!')
                        saveloop = true;
                        continue
                    end
                    % Suggest reasonable filename
                    [path,name,~] = fileparts(MultiDataset.file.name);
                    suggestedFilename = fullfile(path,[name '_fit']);
                    % The "easy" way: consequently use CLI
                    saveFilename = input(...
                        sprintf('Filename (%s): ',suggestedFilename),...
                        's');
                    if isempty(saveFilename)
                        saveFilename = suggestedFilename;
                    end
                    % Put FigureFileName in Dataset
                    MultiDataset.Tsim.results.figureFileName = [saveFilename '-fig'];
                    
                    % Export figure as .pdf and as .fig
                    
                    commonFigureExport(h,[saveFilename '-fig']);
                    
%                     [status] = fig2file(h, [saveFilename '-fig'], 'fileType', 'pdf' );
%                     if ~isempty(status)
%                         disp('Some problems with exporting pdf-figure');
%                     end                     
%                     [status] = fig2file(h, [saveFilename '-fig'], 'fileType', 'fig' );
%                     if ~isempty(status)
%                         disp('Some problems with exporting fig-figure');
%                     end
                    
                    % Save dataset
                    % Clear tempSpectrum onyl in dataset that is saved
                    savedataset = MultiDataset;
                    savedataset.Tsim.fit.spectrum.tempSpectrum = [];
                    [status] = trEPRsave(saveFilename,savedataset);
                    if ~isempty(status)
                        disp('Some problems with saving data');
                    end                    
                    
                    % Make Report
                    TsimReport(MultiDataset,'template','TsimFitReport-de.tex');
                                        
                    clear status saveFilename suggestedFilename savedataset;
                    
                    saveloop = true;
                case 'w'
                    % Write Parameters in Config
                    TsimSimpar2ConfigFile(MultiDataset)
                    saveloop = true;
                    
                    
                    
                case 'f'
                   
                    if ishandle(h)
                        close(h);
                    end
                    % Don't clear tempSpectrum
                    % Copy Values from Simpar to fitpar inivalue
                    MultiDataset = TsimCopySimparValues2Initialvalue(MultiDataset);
                    
                    % Check if boundaries are compatible with inivalue and possibly change them
                    MultiDataset = TsimCheckBoundaries(MultiDataset);
                    
                    % Fit again
                    saveloop = false;
                    
                case 'i'
                   
                    if ishandle(h)
                        close(h);
                    end
                    % Don't clear tempSpectrum
                    % New fit with same initial parameters as before
                    MultiDataset = TsimFitpar2simpar(MultiDataset.Tsim.fit.initialvalue,MultiDataset);
                    MultiDataset = TsimApplyConventions(MultiDataset);
                    
                    
                    % Fit again
                    saveloop = false;
                    
                case 'c'
                   
                    if ishandle(h)
                        close(h);
                    end
                    % New fit with default initial parameters from
                    % config
                    % Clear simpar and fitpar and tempSpectrum
                    MultiDataset.Tsim.fit.spectrum.tempSpectrum = [];
                    fields2beremoved = fieldnames(MultiDataset.Tsim.sim.simpar);
                    for k = 1: length(fields2beremoved)
                        MultiDataset.Tsim.sim.simpar = rmfield(MultiDataset.Tsim.sim.simpar,(fields2beremoved(k)));
                    end
                    MultiDataset.Tsim.fit.fitpar = {};
                    saveloop = false;
                    fitinnerloop = false;
                    
                case 'p'
                   
                    if ishandle(h)
                        close(h);
                    end
                    % New fit with final values as starting parameters but
                    % different section
                    % Clear tempSpectrum
                    MultiDataset.Tsim.fit.spectrum.tempSpectrum = [];
                    % Copy Values from Simpar to fitpar inivalue
                    MultiDataset = TsimCopySimparValues2Initialvalue(MultiDataset);
                    
                    % Check if boundaries are compatible with inivalue and possibly change them
                    MultiDataset = TsimCheckBoundaries(MultiDataset);
                  
                    saveloop = false;
                    fitinnerloop = false;
                    
                    
                    
                    
                case 's'
                   
                    if ishandle(h)
                        close(h);
                    end
                    % New fit with final values as starting parameters but
                    % different simulation routine, same section
                    disp('The simulation routines currently in use:')
                    disp(' ')
                    disp(MultiDataset.Tsim.sim.routine);
                    disp(' ')
                    
                    oldRoutine = MultiDataset.Tsim.sim.routine;
                    MultiDataset = TsimChangeSimRoutine(MultiDataset);
                    newRoutine = MultiDataset.Tsim.sim.routine;
                    
                    if ~strcmpi(oldRoutine,newRoutine)
                        % Check simpar and possibly change it but don't change
                        % values
                        MultiDataset = TsimCleanUpSimpar(MultiDataset,oldRoutine);
                        % Check fitpar. Is there a parameter that is now not
                        % possible anymore. Change fitpar and analogously lb and
                        % ub.
                        MultiDataset = TsimKickOutFitpar(MultiDataset);
                        
                        %Clear initialvalues
                        MultiDataset.Tsim.fit.initialvalues = [];
                        
                    end
                    % Copy Values from Simpar to fitpar inivalue
                    MultiDataset = TsimCopySimparValues2Initialvalue(MultiDataset);
                    
                    % Check if boundaries are compatible with inivalue and possibly change them
                    MultiDataset = TsimCheckBoundaries(MultiDataset);
                    
                    saveloop = false;
                    fitinnerloop = false;
                         
                case 'q'
                   
                    if ishandle(h)
                        close(h);
                    end
                    % Quit
                    % Suggest reasonable filename
                    % Clear tempSpectrum
                    MultiDataset.Tsim.fit.spectrum.tempSpectrum = [];
                    [path,name,~] = fileparts(MultiDataset.file.name);
                    suggestedFilename = fullfile(...
                        path,[name '_fit-' datestr(now,30) '.tez']);
                    saveFilename = suggestedFilename;
                    % Save dataset
                    [status] = TsimSave(saveFilename,MultiDataset);
                    if ~isempty(status)
                        disp('Some problems with saving data');
                    end
                    clear status saveFilename suggestedFilename;
                    disp('Goodbye!');
                    return
                case 'e'
                    
                    if ishandle(h)
                        close(h);
                    end
                    % Quit without saving
                    % Clear tempSpectrum
                    MultiDataset.Tsim.fit.spectrum.tempSpectrum = [];
                    disp('Goodbye!');
                    return,
                otherwise
                   
                    if ishandle(h)
                        close(h);
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




