function TsimSimparIntoConfig(dataset)
% TSIMSIMPARINTOCONFIG Put SimulationParameters in simpar into 
% appropriate place in config and write config to file. If your dataset has
% experimental data the Parameters nPoints, Range and mwFreq are not written Back.   
%
% Usage
%   TsimSimparIntoConfig(dataset)
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-03


% Get configuation 
config = TsimConfigGet('parameters');

% Clean Up configuarionfile
config = TsimCleanUpConfig(config);


% Put Simpar into config. All field in simpar are in StandardSimulation all
% other fields in StandardSimulaltion are shifted to Additional Simulation

if ~isempty(dataset.data)
% You have experimental data
ToBeRemoved = {'nPoints';'Range';'mwFreq'};
FlatFieldnames = fieldnames(rmfield(dataset.TSim.sim.simpar,ToBeRemoved));
else
FlatFieldnames = fieldnames(dataset.TSim.sim.simpar);
end

    
for k = 1:length(FlatFieldnames)
    config.StandardSimulationParameters.(FlatFieldnames{k}) = dataset.TSim.sim.simpar.(FlatFieldnames{k});
end

FlatFieldnames = fieldnames(dataset.TSim.sim.simpar);
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

% Write Config to file
TsimConfigSet('parameters',config);
end

function second = removeFieldsInSecondThatAreInFirst(first,second)
% Remove Fields in Additional Parameters that are also in StandardParameters
Names=fieldnames(second);
overlap =Names(ismember(Names,fieldnames(first)));
second = rmfield(second,overlap);
end