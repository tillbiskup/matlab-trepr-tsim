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
%             Full trEPR toolbox dataset including Tsim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-09-14

% Put Fields in Simpar in config
FlatFieldnames = fieldnames(dataset.Tsim.sim.simpar);
    
for k = 1:length(FlatFieldnames)
    config.StandardSimulationParameters.(FlatFieldnames{k}) = dataset.Tsim.sim.simpar.(FlatFieldnames{k});
end


% Add other Blocks to config
config.AdditionalSimulationParameters = struct();
config.FitparametersAndBoundaries = struct();
config.FitOptions = struct();
end
