function dataset = TsimSimpar2EasySpin(dataset)
% TSIMSIMPAR2EASYSPIN Transfers parameters from the simpar structure to the easyspin structure.
%
% Usage
%   dataset = TsimSimpar2EasySpin(dataset)
%
%
%   dataset - struct
%             Full trEPR toolbox dataset including Tsim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-09-14

% Create Empty EasySpinStructure with all possible fields
EmptyDataset = TsimDataset;
dataset.Tsim.sim.EasySpin = EmptyDataset.Tsim.sim.EasySpin;

dataset = TsimApplyConventions(dataset);

parameters = TsimParameters;

% Initialize non useracces parameters that don't need conversion
nonuser = ~logical(cell2mat(parameters(:,9)));
nonconversion = ~logical(cell2mat(parameters(:,11)));

nonusernonconversion = nonuser & nonconversion;
nonuserpar = parameters(nonusernonconversion,2);
nonuservalues = parameters(nonusernonconversion,10);

% Put them in EasySpin
for cellindex = 1:length(nonuserpar)
dataset.Tsim.sim.EasySpin = ...
    commonSetCascadedField(dataset.Tsim.sim.EasySpin,nonuserpar{cellindex},...
    nonuservalues{cellindex});
end



% Find simulationparameters user wants that don't need conversion and put
% them in EasySpin

% Parameter that don't need conversion
parameternames = parameters(:,1);
nonconpars = parameternames(nonconversion);
evalpars = parameters(:,2);
evalnonconpars = evalpars(nonconversion);

% Parameter and values user wants
simparameters = fieldnames(dataset.Tsim.sim.simpar);
simparvalues = struct2cell(dataset.Tsim.sim.simpar);


[~, ipar, isimpar] = intersect(nonconpars,simparameters);
simnonconparameters = evalnonconpars(ipar);
simnonconparvalues = simparvalues(isimpar);


for cellindex = 1:length(simnonconparameters)
    if ~isempty(simnonconparameters{cellindex})
dataset.Tsim.sim.EasySpin = ...
    commonSetCascadedField(dataset.Tsim.sim.EasySpin,simnonconparameters{cellindex},...
    simnonconparvalues{cellindex});
    end
end

% D and E are in minsim
if isfield(dataset.Tsim.sim.simpar,'D') && isfield(dataset.Tsim.sim.simpar,'E')
    
    principalvalues = TsimDandEconverter([dataset.Tsim.sim.simpar.D dataset.Tsim.sim.simpar.E]);
    
% Put it in EasySpin
    dataset.Tsim.sim.EasySpin.Sys = ...
        commonSetCascadedField(dataset.Tsim.sim.EasySpin.Sys,'D',principalvalues);    
end

% Check if DeltaB is in simpar and change Range in EasySpin accordingly
if isfield(dataset.Tsim.sim.simpar,'DeltaB')
   dataset.Tsim.sim.EasySpin.Exp.Range = dataset.Tsim.sim.EasySpin.Exp.Range - dataset.Tsim.sim.simpar.DeltaB;
end


% Remove all empty fields in EasySpin structure
EasySpinFields = fieldnames(dataset.Tsim.sim.EasySpin);
for EasySpinField = 1:length(EasySpinFields)
    dataset.Tsim.sim.EasySpin.(EasySpinFields{EasySpinField}) = ...
        removeEmptyFields(dataset.Tsim.sim.EasySpin.(EasySpinFields{EasySpinField}));
end

end

function structure = removeEmptyFields(structure)
    fields = fieldnames(structure);
    for field = 1:length(fields)
        if isempty(structure.(fields{field}))
            structure = rmfield(structure,fields{field});
        end
    end  
end