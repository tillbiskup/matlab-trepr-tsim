function config = TsimFitpar2Config(dataset)
% TSIMFITPAR2CONFIG Put FitParameters, if any, in fitstructure to configstructure.   
%
% Usage
%   config = TsimFitpar2Config(dataset)
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

if isempty(dataset.TSim.fit.fitpar)
    return
else
    
    for k = 1:length(dataset.TSim.fit.fitpar)
        config.FitparametersAndBoundaries.(dataset.TSim.fit.fitpar{k}) = [dataset.TSim.fit.lb(k) dataset.TSim.fit.ub(k)] ;
    end
    
    % Add other Blocks to config
    config.AdditionalSimulationParameters = struct();
    config.StandardSimulationParameters = struct();
    config.FitOptions = struct();
end
end
