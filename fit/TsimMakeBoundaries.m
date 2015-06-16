function dataset = TsimMakeBoundaries(dataset)
% TSIMMAKEBOUNDARIES Change boundary vector according to fitpar vector.
% Values are taken from config. If there is no value in config, the
% boundary is plus minus 5 % of the value.
%
% Usage
%   dataset = TsimMakeBoundaries(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-11



% Check if there is already some information

fitpar = dataset.TSim.fit.fitpar;
config = TsimConfigGet('parameters');

if isempty(fieldnames(config))
    dataset = MakeStandardBoundary(dataset);
else
    % CleanUp Config for MinSim and EasySpinIncompatibilities
    
    try
        config = TsimCleanUpConfig(config);
        %  Write Cleaned Up config Back
        TsimConfigSet('parameters',config)
        % CreateFitpar from Config
        
        FoundInConfig = intersect(fieldnames(config.FitparametersAndBoundaries),fitpar);
        NotFoundInConfig = setdiff(fitpar,fieldnames(config.FitparametersAndBoundaries));
        
        dataset = MakeStandardBoundary(dataset,NotFoundInConfig);
        
        for k = (length(NotFoundInConfig)+1):1:(length(FoundInConfig)+length(NotFoundInConfig))
            dataset.TSim.fit.lb(k) = config.FitparametersAndBoundaries.(FoundInConfig{k})(1);
            dataset.TSim.fit.ub(k) = config.FitparametersAndBoundaries.(FoundInConfig{k})(2);
        end
    catch %#ok<CTCH>
        dataset = MakeStandardBoundary(dataset);
    end
end
end

function dataset = MakeStandardBoundary(dataset,varargin)
fraction = 1/20;
if ~isempty(varargin)
    fitpar = varargin;
else
    fitpar = dataset.TSim.fit.fitpar;
end

dataset.TSim.fit.lb = [];
dataset.TSim.fit.ub = [];

for u = 1:length(fitpar)
    dataset.TSim.fit.lb(u) = dataset.TSim.fit.initialvalue(u)-dataset.TSim.fit.initialvalue(u)*fraction;
    dataset.TSim.fit.ub(u) = dataset.TSim.fit.initialvalue(u)+dataset.TSim.fit.initialvalue(u)*fraction;
end

end
