function dataset = TsimSimpar2EasySpin(dataset)
% TSIMSIMPAR2EASYSPIN Transfers parameters from the simpar structure to the easyspin structure.
%
% Usage
%   dataset = TsimPar2SysExp(dataset)
%
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-05-29

parameters = TsimParameters;

% Initialize non useracces parameters that don't need conversion
nonuser = ~logical(cell2mat(parameters(:,9)));
nonconversion = ~logical(cell2mat(parameters(:,11)));

nonusernonconversion = nonuser & nonconversion;
nonuserpar = parameters(nonusernonconversion,2);
nonuservalues = parameters(nonusernonconversion,10);

% Put them in EasySpin
for cellindex = 1:length(nonuserpar)
dataset.TSim.sim.EasySpin = ...
    commonSetCascadedField(dataset.TSim.sim.EasySpin,nonuserpar{cellindex},...
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
simparameters = fieldnames(dataset.TSim.sim.simpar);
simparvalues = struct2cell(dataset.TSim.sim.simpar);


[~, ipar, isimpar] = intersect(nonconpars,simparameters);
simnonconparameters = evalnonconpars(ipar);
simnonconparvalues = simparvalues(isimpar);


for cellindex = 1:length(simnonconparameters)
dataset.TSim.sim.EasySpin = ...
    commonSetCascadedField(dataset.TSim.sim.EasySpin,simnonconparameters{cellindex},...
    simnonconparvalues{cellindex});
end


% Convert other parameters
% D and E are in minsim
if isfield(dataset.TSim.sim.simpar,'D') && isfield(dataset.TSim.sim.simpar,'E')
    
    principalvalues = TsimDandEconverter([dataset.TSim.sim.simpar.D dataset.TSim.sim.simpar.E]);
    
    % Put it in EasySpin
    dataset.TSim.sim.EasySpin.Sys = ...
        commonSetCascadedField(dataset.TSim.sim.EasySpin.Sys,'D',principalvalues);
    
end

% Remove all empty fields in EasySpin structure
EasySpinFields = fieldnames(dataset.TSim.sim.EasySpin);
for EasySpinField = 1:length(EasySpinFields)
    dataset.TSim.sim.EasySpin.(EasySpinFields{EasySpinField}) = ...
        removeEmptyFields(dataset.TSim.sim.EasySpin.(EasySpinFields{EasySpinField}));
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