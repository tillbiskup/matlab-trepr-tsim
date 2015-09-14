function dataset = TsimIniFitpar(dataset)
% TSIMINIFITPAR Initialize fitparameters for fitting/simulating triplet spectra
% with Tsim. Create fitpar and boundaries according to config. If there is 
% a parameter that should be fitted according to config but is not in simpar 
% put it there.  If there is already something in fitpar do nothing.
%
% Usage
%   dataset = TsimIniFitpar(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including Tsim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-09-14

% Check if there is already some information
if ~isempty(dataset.Tsim.fit.fitpar)
    return
end

routine = dataset.Tsim.sim.routine;
config = TsimConfigGet([routine 'parameters']);


if isempty(fieldnames(config))
    dataset = initializeDefaultFitParameters(dataset);
else
    % CleanUp Config for MinSim and EasySpinIncompatibilities
    
    try
        configCleanupRoutine = str2func(commonCamelCase({'TsimCleanUpConfig',routine}));
        config = configCleanupRoutine(config);
        
        TsimConfigSet([routine 'parameters'],config)
        % CreateFitpar from Config
        dataset.Tsim.fit.fitpar = fieldnames(config.FitparametersAndBoundaries);
        for k = 1:length(dataset.Tsim.fit.fitpar)
            dataset.Tsim.fit.lb(k) = config.FitparametersAndBoundaries.(dataset.Tsim.fit.fitpar{k})(1);
            dataset.Tsim.fit.ub(k) = config.FitparametersAndBoundaries.(dataset.Tsim.fit.fitpar{k})(2);
        end
        
        if isfield(config.FitOptions, 'MaximumIteration')
            dataset.Tsim.fit.fitopt.MaxIter = config.FitOptions.MaximumIteration;
        end
        
        if isfield(config.FitOptions,'MaximumFunctionEvaluation')
            dataset.Tsim.fit.fitopt.MaxFunEval = config.FitOptions.MaximumFunctionEvaluation;
        end
        
        if isfield(config.FitOptions, 'TerminationTolerance')
            dataset.Tsim.fit.fitopt.TolFun = config.FitOptions.TerminationTolerance;
        end
                
    catch %#ok<CTCH>
        disp(' ')
        disp('(WW) Configuation file corrupted. Fall back to default parameters.')
        dataset = initializeDefaultFitParameters(dataset);
    end
    
    
end

% Chek if fitpar is subset of (or equal to) simpar and add parameters in simpar if necessary  
dataset = TsimChekFitpar(dataset);

% Copy Values from Simpar to fitpar inivalue
dataset = TsimCopySimparValues2Initialvalue(dataset);

% Check if boundaries are compatible with inivalue and possibly change them
dataset = TsimCheckBoundaries(dataset);

end


function dataset = initializeDefaultFitParameters(dataset)
dataset.Tsim.fit.fitpar = {'D';'E';'p1';'p2';'p3';'DeltaB';'lwGauss'};
dataset.Tsim.fit.lb = [300, 20, 0, 0, 0, -2, 0];
dataset.Tsim.fit.ub = [700, 200, 1, 1, 1, 2, 10];

end
