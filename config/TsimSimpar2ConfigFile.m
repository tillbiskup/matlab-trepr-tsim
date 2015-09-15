function TsimSimpar2ConfigFile(dataset)
% TSIMSIMPAR2CONFIGFILE Put Simulation Parameters in simpar (and fitparameters if existing) into 
% appropriate place in config and write config to file. If your dataset has
% experimental data and your configuration is not corrupted the Parameters
% nPoints, Range and mwFreq are not written Back.   
%
% Usage
%   TsimSimpar2ConfigFile(dataset)
%
%   dataset - struct
%             Full trEPR toolbox dataset including Tsim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-09-15


% Get configuation

routine = dataset.Tsim(1).sim.routine;

config = TsimConfigGet([routine 'parameters']);

if isempty(fieldnames(config))
    Simconfig = TsimSimpar2Config(dataset);
    Fitconfig = TsimFitpar2Config(dataset);
    % Put it together
    config = commonStructCopy(Simconfig,Fitconfig);

    % Write Config to file
     TsimConfigSet([routine 'parameters'],config)
    return
end


try
    
    configCleanupRoutine = str2func(commonCamelCase({'TsimCleanUpConfig',routine}));
    config = configCleanupRoutine(config);
    
catch %#ok<CTCH>
    Simconfig = TsimSimpar2Config(dataset);
    Fitconfig = TsimFitpar2Config(dataset);
    % Put it together
    config = commonStructCopy(Simconfig,Fitconfig);

    % Write Config to file
    TsimConfigSet([routine 'parameters'],config)
    return
end


% Put Simpar into config. All field in simpar are in StandardSimulation all
% other fields in StandardSimulaltion are shifted to Additional Simulation

if ~isempty(dataset.data)
% You have experimental data
ToBeRemoved = {'nPoints';'Range';'mwFreq'};
FlatFieldnames = fieldnames(rmfield(dataset.Tsim(1).sim.simpar,ToBeRemoved));
else
FlatFieldnames = fieldnames(dataset.Tsim(1).sim.simpar);
end

    
for k = 1:length(FlatFieldnames)
    config.StandardSimulationParameters.(FlatFieldnames{k}) = dataset.Tsim(1).sim.simpar.(FlatFieldnames{k});
end

FlatFieldnames = fieldnames(dataset.Tsim(1).sim.simpar);
FieldsToBeShifted = setdiff(fieldnames(config.StandardSimulationParameters),FlatFieldnames);

for k=1:length(FieldsToBeShifted)
    if isfield(config.StandardSimulationParameters,FieldsToBeShifted{k})
        Value = commonGetCascadedField(config.StandardSimulationParameters,FieldsToBeShifted{k});
        config.StandardSimulationParameters = rmfield(config.StandardSimulationParameters,FieldsToBeShifted{k});
        config.AdditionalSimulationParameters.(FieldsToBeShifted{k}) = Value;
    end
end
 
% Remove Overlaps
config.AdditionalSimulationParameters = removeFieldsInSecondThatAreInFirst(...
    config.StandardSimulationParameters,config.AdditionalSimulationParameters);

% Fitparameters
Fitconfig = TsimFitpar2Config(dataset);
if ~isempty(Fitconfig)
config = commonStructCopy(config,Fitconfig);    
end


% Write Config to file
 TsimConfigSet([routine 'parameters'],config)
end

function second = removeFieldsInSecondThatAreInFirst(first,second)
% Remove Fields in Additional Parameters that are also in StandardParameters
Names=fieldnames(second);
overlap =Names(ismember(Names,fieldnames(first)));
second = rmfield(second,overlap);
end