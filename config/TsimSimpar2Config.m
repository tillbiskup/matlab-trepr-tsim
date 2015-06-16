function config = TsimSimpar2Config(dataset)
% TSIMSIMPAR2CONFIG Put SimulationParameters in simpar all in standardSimulation configstructure.   
%
% Usage
%   config = TsimSimpar2Config(dataset)
%
%   config  - struct
%             configuration structure
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-10

% Put Fields in Simpar in config
FlatFieldnames = fieldnames(dataset.TSim.sim.simpar);
    
for k = 1:length(FlatFieldnames)
    config.StandardSimulationParameters.(FlatFieldnames{k}) = dataset.TSim.sim.simpar.(FlatFieldnames{k});
end


% Add other Blocks to config
config.AdditionalSimulationParameters = struct();
config.FitparametersAndBoundaries = struct();
config.FitOptions = struct();
end
