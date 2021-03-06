function dataset = TsimCliFit(dataset)
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
    if size(dataset.data) > 1
        [dataset, quit] = TsimDefineFitsection(dataset);
        if quit
            % Quit
            disp('Goodbye!');
            return;
        end
    else
        % 1D data
        dataset.Tsim.fit.spectrum.tempSpectrum = dataset.data;
        dataset.Tsim.fit.spectrum.tempSpectrum = dataset.Tsim.fit.spectrum.tempSpectrum./sum(abs(dataset.Tsim.fit.spectrum.tempSpectrum));
    end
    
    siminiloop = true;
    while siminiloop
        [dataset, siminiloop, quit ] = TsimIniSimCli(dataset);
        if quit
            % Quit
            disp('Goodbye!');
            return;
        end
    end % siminiloop
    
    % Fitparameters are initialized
    dataset = TsimIniFitpar(dataset);
    
    fitinnerloop = true;
    while fitinnerloop
        
        fitiniloop = true;
        while fitiniloop
               
            disp(' ');
            
            % Display current set of fitting parameters with
            % their values and boundaries
            disp('Simulation parameters currently released for fitting in the wild:')
            
            disp(' ');
            TsimParDisplay(dataset,'fit');
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
                    dataset = TsimChangeSimValues(dataset);
                    
                    % Copy Values from Simpar to fitpar inivalue
                    dataset = TsimCopySimparValues2Initialvalue(dataset);
                    
                    % Check if boundaries are compatible with inivalue and possibly change them
                    dataset = TsimCheckBoundaries(dataset);
                    
                    fitiniloop = true;
                case 'p'
                    % Choose different/additional fitting parameters
                    dataset = TsimChangeFitpar(dataset);
                    
                    % Copy Values from Simpar to fitpar inivalue
                    dataset = TsimCopySimparValues2Initialvalue(dataset);
                    
                    % Change Boundaries according to fitparvector with values
                    % from config
                    dataset = TsimMakeBoundaries(dataset);
                    
                    % Check if boundaries are compatible with inivalue and possibly change them
                    dataset = TsimCheckBoundaries(dataset);
                    
                    fitiniloop = true;
                case 'b'
                    % Change boundary
                    dataset = TsimChangeBoundary(dataset);
                    
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
            TsimParDisplay(dataset,'opt');
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
                    dataset = TsimDefineWeightRegion(dataset);
                    dataset = TsimWeightSpectrum(dataset,'spectrum');
                    fitalgorithmloop = true;
                case 'i'
                    % Max number of iterations
                    dataset = TsimChangeFitopt(dataset,'MaxIter');
                    fitalgorithmloop = true;
                case 't'
                    % Change termination tolerance
                    dataset = TsimChangeFitopt(dataset,'TolFun');
                    fitalgorithmloop = true;
                case 'f'
                    % Maximum Number of function calls
                    dataset = TsimChangeFitopt(dataset,'MaxFunEval');
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
        dataset.Tsim.remarks.purpose = purpose;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
        % Fitting
        dataset = TsimFit(dataset);
        
        h = TsimMakeShinyPicture(dataset);
        
        % Pardisplay
        disp(' ');
        TsimParDisplay(dataset,'fitreport');
        disp(' ');
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
        % Enter comment
        disp('Enter a comment:');
        comment = input('> ','s');
        dataset.Tsim.remarks.comment = comment;
        
       
        % Write history
        % (Orwell style - we're creating our own)
        dataset = TsimHistory('write',dataset);
        
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
                    savedataset = dataset;
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
                    [path,name,~] = fileparts(dataset.file.name);
                    suggestedFilename = fullfile(path,[name '_fit']);
                    % The "easy" way: consequently use CLI
                    saveFilename = input(...
                        sprintf('Filename (%s): ',suggestedFilename),...
                        's');
                    if isempty(saveFilename)
                        saveFilename = suggestedFilename;
                    end
                    % Put FigureFileName in Dataset
                    dataset.Tsim.results.figureFileName = [saveFilename '-fig'];
                    
                    % Export figure as .pdf and as .fig
                    % Try to make axis the same size
                    set(h,'Units','centimeters');
                    set(h,'Position',[1.5, 1.5, 14, 9]);
                    
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
                    savedataset = dataset;
                    savedataset.Tsim.fit.spectrum.tempSpectrum = [];
                    [status] = trEPRsave(saveFilename,savedataset);
                    if ~isempty(status)
                        disp('Some problems with saving data');
                    end                    
                    
                    % Make Report
                    TsimReport(dataset,'template','TsimFitReport-de.tex');
                                        
                    clear status saveFilename suggestedFilename savedataset;
                    
                    saveloop = true;
                case 'w'
                    % Write Parameters in Config
                    TsimSimpar2ConfigFile(dataset)
                    saveloop = true;
                    
                    
                    
                case 'f'
                   
                    if ishandle(h)
                        close(h);
                    end
                    % Don't clear tempSpectrum
                    % Copy Values from Simpar to fitpar inivalue
                    dataset = TsimCopySimparValues2Initialvalue(dataset);
                    
                    % Check if boundaries are compatible with inivalue and possibly change them
                    dataset = TsimCheckBoundaries(dataset);
                    
                    % Fit again
                    saveloop = false;
                    
                case 'i'
                   
                    if ishandle(h)
                        close(h);
                    end
                    % Don't clear tempSpectrum
                    % New fit with same initial parameters as before
                    dataset = TsimFitpar2simpar(dataset.Tsim.fit.initialvalue,dataset);
                    dataset = TsimApplyConventions(dataset);
                    
                    
                    % Fit again
                    saveloop = false;
                    
                case 'c'
                   
                    if ishandle(h)
                        close(h);
                    end
                    % New fit with default initial parameters from
                    % config
                    % Clear simpar and fitpar and tempSpectrum
                    dataset.Tsim.fit.spectrum.tempSpectrum = [];
                    fields2beremoved = fieldnames(dataset.Tsim.sim.simpar);
                    for k = 1: length(fields2beremoved)
                        dataset.Tsim.sim.simpar = rmfield(dataset.Tsim.sim.simpar,(fields2beremoved(k)));
                    end
                    dataset.Tsim.fit.fitpar = {};
                    saveloop = false;
                    fitinnerloop = false;
                    
                case 'p'
                   
                    if ishandle(h)
                        close(h);
                    end
                    % New fit with final values as starting parameters but
                    % different section
                    % Clear tempSpectrum
                    dataset.Tsim.fit.spectrum.tempSpectrum = [];
                    % Copy Values from Simpar to fitpar inivalue
                    dataset = TsimCopySimparValues2Initialvalue(dataset);
                    
                    % Check if boundaries are compatible with inivalue and possibly change them
                    dataset = TsimCheckBoundaries(dataset);
                  
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
                    disp(dataset.Tsim.sim.routine);
                    disp(' ')
                    
                    oldRoutine = dataset.Tsim.sim.routine;
                    dataset = TsimChangeSimRoutine(dataset);
                    newRoutine = dataset.Tsim.sim.routine;
                    
                    if ~strcmpi(oldRoutine,newRoutine)
                        % Check simpar and possibly change it but don't change
                        % values
                        dataset = TsimCleanUpSimpar(dataset,oldRoutine);
                        % Check fitpar. Is there a parameter that is now not
                        % possible anymore. Change fitpar and analogously lb and
                        % ub.
                        dataset = TsimKickOutFitpar(dataset);
                        
                        %Clear initialvalues
                        dataset.Tsim.fit.initialvalues = [];
                        
                    end
                    % Copy Values from Simpar to fitpar inivalue
                    dataset = TsimCopySimparValues2Initialvalue(dataset);
                    
                    % Check if boundaries are compatible with inivalue and possibly change them
                    dataset = TsimCheckBoundaries(dataset);
                    
                    saveloop = false;
                    fitinnerloop = false;
                         
                case 'q'
                   
                    if ishandle(h)
                        close(h);
                    end
                    % Quit
                    % Suggest reasonable filename
                    % Clear tempSpectrum
                    dataset.Tsim.fit.spectrum.tempSpectrum = [];
                    [path,name,~] = fileparts(dataset.file.name);
                    suggestedFilename = fullfile(...
                        path,[name '_fit-' datestr(now,30) '.tez']);
                    saveFilename = suggestedFilename;
                    % Save dataset
                    [status] = TsimSave(saveFilename,dataset);
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
                    dataset.Tsim.fit.spectrum.tempSpectrum = [];
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




