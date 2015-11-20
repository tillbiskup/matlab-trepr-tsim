function MultiDataset=Tsim()
% TSIM for simulating spin-polarized EPR spectra
% of triplets.
%
% Usage
%   MultiDataset = Tsim()
%
%
%   MultiDataset - Cell of structs
%                  structs are full trEPR toolbox 
%                  dataset including Tsim structure
%

% Copyright (c) 2013-2015, Deborah Meyer, Till Biskup
% 2015-11-19



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

% Global Tsim Welcome
TsimWelcomeMessage
disp(' ')

% Load existing data
disp('Please load (multiple) experimental datasets:');

datasetloading = true;
MultiDataset = cell(0);
while datasetloading
        dataset = loaddata();
        if isempty(fieldnames(dataset))
            datasetloading = false;
        else
            MultiDataset{end+1} = dataset;
        end   
end

%Display some figures
for numberOfDatasets = 1:length(MultiDataset)
    figure(numberOfDatasets);
    b = TsimMakeShinyPicture(MultiDataset{numberOfDatasets});
    
    % Tsim structure is added
    if  ~isfield(MultiDataset{numberOfDatasets},'Tsim')
        MultiDataset{numberOfDatasets} = TsimDataset(MultiDataset{numberOfDatasets});
    end
end

% Start the global fit
MultiDataset = TsimCliFit(MultiDataset);
return;
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
            'you wish to load (Hit Enter to finish loading any more ): '),'s');
        if strcmpi(datasetname,'')
            % Quit
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