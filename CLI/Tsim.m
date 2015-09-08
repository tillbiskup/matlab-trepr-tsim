function dataset=Tsim()
% TSIM for simulating spin-polarized EPR spectra
% of triplets.
%
% Usage
%   dataset = Tsim()
%
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%

% Copyright (c) 2013-2015, Deborah Meyer, Till Biskup
% 2015-09-08


% Check for dependencies
[status, missing] = TsimDependency();
if (status == 1)
    disp('There are files missing required for the fit:');
    cellfun(@disp, missing);
    return
else
    % Remove unwanted variables from workspace
    clear status missing
end

TsimWelcomeMessage
disp(' ')

% Load existing data
answer = cliMenu({'y','Yes';'n','No';'q','Quit'},'default','n','title',...
    'Do you wish to load an existing (experimental) dataset');

switch answer
    case 'y'
        
        dataset = loaddata();
        if isempty(fieldnames(dataset))
            return;
        end
        
        %%%%%%%%%%%%%%%%%%%
        if isfield(dataset,'calculated') && ~isempty(dataset.calculated) && isempty(dataset.data)
            % only simulation
            % Figure
            figure();
            b = TsimMakeShinyPicture(dataset);
            set(b,'Tag','simulationDataFigure');
            
            % Should not be necessary
            % TSim structure is added
            if  ~isfield(dataset,'TSim')
                dataset = TsimDataset(dataset);
            end    
        end
        %%%%%%%%%%%%%%%%%%%%%%
        if isfield(dataset,'calculated') && ~isempty(dataset.calculated) && ~isempty(dataset.data)
            % simulation and experimental
            
            % Figure
            figure();
            b = TsimMakeShinyPicture(dataset);
            set(b,'Tag','experimentalDataAndFitFigure');
            
            % Should not be necessary
            % TSim structure is added
            if  ~isfield(dataset,'TSim')
                dataset = TsimDataset(dataset);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        if (~isfield(dataset,'calculated') || isempty(dataset.calculated)) && ~isempty(dataset.data)
            % only experimental
            
            % Figure
            figure();
            b = TsimMakeShinyPicture(dataset);
            set(b,'Tag','experimentalDataFigure');
            
            if  ~isfield(dataset,'TSim')
                % TSim structure is added
                dataset = TsimDataset(dataset);
            end  
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        dataset = TsimCliSim(dataset);
        return;
        
    case 'n'
        % load nothing and start simulation
        dataset = TsimDataset();
        dataset = TsimCliSim(dataset);
        return;
    case 'q'
        disp('Goodbye!');
        return;
    otherwise
        % Shall never happen
        disp('Buuh')
end



end

function dataset = loaddata()
loaddatasetloop = true;
% Load dataset
while loaddatasetloop
    
    disp(' ');
    datasetname = '';
    while isempty(datasetname)
        datasetname = input(sprintf('%s\n%s',...
            'Please enter the name of the dataset',...
            'you wish to load (''q'' to quit): '),'s');
        if strcmpi(datasetname,'q')
            % Quit
            disp('Goodbye!');
            dataset = struct();
            return;
        end
        
        if ~exist(datasetname,'file')
            fprintf('\nFile "%s" not found. Please try again\n\n',...
                datasetname);
            datasetname = '';
        end
    end
    
    % Load dataset using <trEPRTload>
    [dataset, warnings] = trEPRload(datasetname);
    if size(warnings)
        loaddatasetloop = true;
    else
        loaddatasetloop = false;
    end
    
    clear warnings
end % loaddatasetloop
end