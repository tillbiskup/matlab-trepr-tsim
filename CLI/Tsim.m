function dataset=Tsim()
% TSIM for simulating spin-polarized EPR spectra
% of triplets.
%
% Usage
%   dataset = Tsim()
%
%
%   dataset - struct
%             Full trEPR toolbox dataset including Tsim structure
%

% Copyright (c) 2013-2015, Deborah Meyer, Till Biskup
% 2015-09-14



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
    case 'n'
        % load nothing and start simulation
        dataset = TsimDataset();
        dataset = TsimCliSim(dataset);
        return;
    case 'q'
        fprintf('\nPlease don''t forget:\n\n')
        fprintf(TsimDisclaimerCitation)
        fprintf('\n')
        disp('Goodbye!');
        return;
    otherwise
        % Shall never happen
        disp('Buuh')
end



% Check what kind of dataset and what size of data you have
% only simulation, only experimental or simulation and experimental
% and display some figures

if isfield(dataset,'calculated') && ~isempty(dataset.calculated) && isempty(dataset.data)
    % only simulation
    % Figure
    figure();
    b = TsimMakeShinyPicture(dataset);
    set(b,'Tag','simulationDataFigure');
    
    % Should not be necessary
    % Tsim structure is added
    if  ~isfield(dataset,'Tsim')
        dataset = TsimDataset(dataset);
    end
    
    dataset = TsimCliSim(dataset);
    return;
    
end

if isfield(dataset,'calculated') && ~isempty(dataset.calculated) && ~isempty(dataset.data)
    % simulation and experimental
    
    % Figure
    figure();
    b = TsimMakeShinyPicture(dataset);
    set(b,'Tag','experimentalDataAndFitFigure');
    
    % Should not be necessary
    % Tsim structure is added
    if  ~isfield(dataset,'Tsim')
        dataset = TsimDataset(dataset);
    end
    
    % Ask what to do
    option = {'f', 'fit';'s','simulate'};
    answer = cliMenu(option,'title','Do you wish to simulate or fit?','default','f');
    
    disp(' ');
    
    switch lower(answer)
        case 's'
            dataset = TsimCliSim(dataset);
            return;
        case 'f'
            dataset = TsimCliFit(dataset);
            return;
    end
end

if (~isfield(dataset,'calculated') || isempty(dataset.calculated)) && ~isempty(dataset.data)
    % only experimental
    
    % Figure
    figure();
    b = TsimMakeShinyPicture(dataset);
    set(b,'Tag','experimentalDataFigure');
    
    if  ~isfield(dataset,'Tsim')
        % Tsim structure is added
        dataset = TsimDataset(dataset);
    end
    
    % Ask what to do
    option = {'f', 'fit';'s','simulate'};
    answer = cliMenu(option,'title','Do you wish to simulate or fit?','default','f');
    
    disp(' ');
    
    switch lower(answer)
        case 's'
            dataset = TsimCliSim(dataset);
            return;
        case 'f'
            dataset = TsimCliFit(dataset);
            return;
    end
end

%%%
disp('You seem to have a rather strange dataset... Goodbye!')

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