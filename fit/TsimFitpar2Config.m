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
%             Full trEPR toolbox dataset including Tsim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-09-15

if isempty(dataset.Tsim(1).fit.fitpar)
    config = [];
    return
else
    
    for k = 1:length(dataset.Tsim(1).fit.fitpar)
        config.FitparametersAndBoundaries.(dataset.Tsim(1).fit.fitpar{k}) = [dataset.Tsim(1).fit.lb(k) dataset.Tsim(1).fit.ub(k)] ;
    end
    
    % Add other Blocks to config
    config.AdditionalSimulationParameters = struct();
    config.StandardSimulationParameters = struct();
    config.FitOptions = struct();
end
end
