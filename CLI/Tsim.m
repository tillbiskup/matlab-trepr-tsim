function dataset=Tsim()
% TREPRTSIM for simulating spin-polarized EPR spectra
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
% 2015-05-29



% Check for dependencies
[status, missing] = trEPRTSim_dependency();
if (status == 1)
    disp('There are files missing required for the fit:');
    cellfun(@disp, missing);
    return
else
    % Remove unwanted variables from workspace
    clear status missing
end

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
        % load nothing and start simlation;
        disp('Welcome to BetterTSim, the simulation program for triplett spectra!');
        dataset = trEPRTSim_dataset();
        dataset = trEPRTSim_cli_sim(dataset);
        return;
    case 'q'
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
    disp('Welcome to BetterTSim, the simulation program for triplett spectra!');
    
    figure(1);
    plot(dataset.axes.y.values,dataset.calculated);
    
    % Should not be necessary
    % TSim structure is added
    if  ~isfield(dataset,'TSim')
        dataset = trEPRTSim_dataset(dataset);
    end
    
    dataset = trEPRTSim_cli_sim(dataset);
    return;
    
end

if isfield(dataset,'calculated') && ~isempty(dataset.calculated) && ~isempty(dataset.data)
    % simulation and experimental
    disp('Welcome to BetterTSim, the simulation and fitting program for triplett spectra!');
    if size(dataset.data) > 1
        [~,idxMax] = max(max(dataset.data));
        
        figure(1);
        plot(dataset.axes.y.values,dataset.data(:,idxMax))
        legend({'Originaldata'},'Location','SouthEast');
    else
        figure(1);
        plot(expdataset.axes.y.values,expdataset.data)
        legend({'Originaldata'},'Location','SouthEast');
        
    end
    
    figure(2);
    plot(dataset.axes.y.values,dataset.calculated);
    
    % Should not be necessary
    % TSim structure is added
    if  ~isfield(dataset,'TSim')
        dataset = trEPRTSim_dataset(dataset);
    end
    
    % Ask what to do
    option = {'f', 'fit';'s','simulate'};
    answer = cliMenu(option,'title','Do you wish to simulate or fit?','default','f');
    
    disp(' ');
    
    switch lower(answer)
        case 's'
            dataset = trEPRTSim_cli_sim(dataset);
            return;
        case 'f'
            dataset = trEPRTSim_cli_fit(dataset);
            return;
    end
end

if (~isfield(dataset,'calculated') || isempty(dataset.calculated)) && ~isempty(dataset.data)
    % only experimental
    
    disp('Welcome to BetterTSim, the simulation and fitting program for triplett spectra!');
    if size(dataset.data) > 1
        [~,idxMax] = max(max(dataset.data));
        
        figure(1);
        plot(dataset.axes.y.values,dataset.data(:,idxMax))
        legend({'Originaldata'},'Location','SouthEast');
    else
        figure(1);
        plot(expdataset.axes.y.values,expdataset.data)
        legend({'Originaldata'},'Location','SouthEast');
        
    end
    
    if  ~isfield(dataset,'TSim')
        % TSim structure is added
        dataset = trEPRTSim_dataset(dataset);
    end
    
    % Ask what to do
    option = {'f', 'fit';'s','simulate'};
    answer = cliMenu(option,'title','Do you wish to simulate or fit?','default','f');
    
    disp(' ');
    
    switch lower(answer)
        case 's'
            dataset = trEPRTSim_cli_sim(dataset);
            return;
        case 'f'
            dataset = trEPRTSim_cli_fit(dataset);
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