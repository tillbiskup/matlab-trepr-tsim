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
% 2015-06-22



% Check if there is already some information

fitpar = dataset.TSim.fit.fitpar;
routine = dataset.TSim.sim.routine;
config = TsimConfigGet([routine 'parameters']);

if isempty(fieldnames(config))
    dataset = TsimMakeStandardBoundary(dataset);
else
    
    % CleanUp Config for MinSim and EasySpinIncompatibilities
    
    try
        configCleanupRoutine = str2func(commonCamelCase({'TsimCleanUpConfig',routine}));
        config = configCleanupRoutine(config);
        %  Write Cleaned Up config Back
        TsimConfigSet([routine 'parameters'],config)
        
        % CreateFitpar from Config
        FoundInConfig = intersect(fieldnames(config.FitparametersAndBoundaries),fitpar,'stable');
        NotFoundInConfig = setdiff(fitpar,fieldnames(config.FitparametersAndBoundaries));
        
        dataset.TSim.fit.lb = zeros(1,length(fitpar));
        dataset.TSim.fit.ub = zeros(1,length(fitpar));
        
        dataset = TsimMakeStandardBoundary(dataset,NotFoundInConfig);
       
        [~,index,~] = intersect(dataset.TSim.fit.fitpar,FoundInConfig,'stable');

        
        for k = 1:length(index)
            dataset.TSim.fit.lb(index(k)) = config.FitparametersAndBoundaries.(FoundInConfig{k})(1);
            dataset.TSim.fit.ub(index(k)) = config.FitparametersAndBoundaries.(FoundInConfig{k})(2);
        end
        
    catch  ME
        rethrow(ME)
        disp(['(EE) ' ME.message])
        
        dataset = TsimMakeStandardBoundary(dataset);
    end
end
end

