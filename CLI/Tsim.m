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
% 2015-05-29



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


% Check what kind of dataset and what size of data you have
% only simulation, only experimental or simulation and experimental
% and display some figures

if isfield(dataset,'calculated') && ~isempty(dataset.calculated) && isempty(dataset.data)
    % only simulation 
    disp('Welcome to BetterTSim, the simulation program for triplett spectra!');
    
    figure(1);
    plot(dataset.axes.calculated(1).values,dataset.calculated)
    % commonplot(dataset,'kind','calculated');
    
    % Should not be necessary
    % TSim structure is added
    if  ~isfield(dataset,'TSim')
        dataset = TsimDataset(dataset);
    end
    
    dataset = TsimCliSim(dataset);
    return;
    
end

if isfield(dataset,'calculated') && ~isempty(dataset.calculated) && ~isempty(dataset.data)
    % simulation and experimental
    disp('Welcome to BetterTSim, the simulation and fitting program for triplett spectra!');
    if size(dataset.data) > 1
        [~,idxMax] = max(max(dataset.data));
        
        figure(1);
        plot(dataset.axes.data(2).values,dataset.data(:,idxMax))
        legend({'Originaldata'},'Location','SouthEast');
        % commonplot(dataset,'kind','data','type','1d','direction','magnetic field','position','max');
        
        figure(2);
        plot(dataset.axes.calculated(2).values,dataset.calculated)
        % commonplot(dataset,'kind','calculated');
        
    else
        figure(1);
        plot(expdataset.axes.data(1).values,dataset.data)
        legend({'Originaldata'},'Location','SouthEast');
        % commonplot(dataset,'kind','data');
        
        figure(2);
        plot(datset.axes.calculated(1).values,dataset.calculated)
        % commonplot(dataset,'kind','calculated');
        
    end
    
   
    
    % Should not be necessary
    % TSim structure is added
    if  ~isfield(dataset,'TSim')
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
    
    disp('Welcome to BetterTSim, the simulation and fitting program for triplett spectra!');
    if size(dataset.data) > 1
        [~,idxMax] = max(max(dataset.data));
        
        figure(1);
        plot(dataset.axes.data(2).values,dataset.data(:,idxMax))
        legend({'Originaldata'},'Location','SouthEast');
        % commonplot(dataset,'kind','data','type','1d','direction','magnetic field','position','max');
        
    else
        figure(1);
        plot(expdataset.axes.data(1).values,dataset.data)
        legend({'Originaldata'},'Location','SouthEast');
        % commonplot(dataset,'kind','data');
    end
    
    if  ~isfield(dataset,'TSim')
        % TSim structure is added
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