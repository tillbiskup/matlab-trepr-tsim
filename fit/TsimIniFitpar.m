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
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-01

% Check if there is already some information
if ~isempty(dataset.TSim.fit.fitpar)
    return
end

routine = dataset.TSim.sim.routine;
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
        dataset.TSim.fit.fitpar = fieldnames(config.FitparametersAndBoundaries);
        for k = 1:length(dataset.TSim.fit.fitpar)
            dataset.TSim.fit.lb(k) = config.FitparametersAndBoundaries.(dataset.TSim.fit.fitpar{k})(1);
            dataset.TSim.fit.ub(k) = config.FitparametersAndBoundaries.(dataset.TSim.fit.fitpar{k})(2);
        end
        
        if isfield(config.FitOptions, 'MaximumIteration')
            dataset.TSim.fit.fitopt.MaxIter = config.FitOptions.MaximumIteration;
        end
        
        if isfield(config.FitOptions,'MaximumFunctionEvaluation')
            dataset.TSim.fit.fitopt.MaxFunEval = config.FitOptions.MaximumFunctionEvaluation;
        end
        
        if isfield(config.FitOptions, 'TerminationTolerance')
            dataset.TSim.fit.fitopt.TolFun = config.FitOptions.TerminationTolerance;
        end
                
    catch %#ok<CTCH>
        disp(' ')
        disp('(WW) Configuation file corrupted. Fall back to default parameters.')
        dataset = initializeDefaultFitParameters(dataset);
    end
    
    
end

% Chek if fitpar is subset of (or equal to) simpar and add parameters if necessary  
dataset = TsimChekFitpar(dataset);

% Copy Values from Simpar to fitpar inivalue
dataset = TsimCopySimparValues2Initialvalue(dataset);

% Check if boundaries are compatible with inivalue and possibly change them
dataset = TsimCheckBoundaries(dataset);

end


function dataset = initializeDefaultFitParameters(dataset)
dataset.TSim.fit.fitpar = {'D';'E';'p1';'p2';'p3';'DeltaB';'lwGauss'};
dataset.TSim.fit.lb = [300, 20, 0, 0, 0, -2, 0];
dataset.TSim.fit.ub = [700, 200, 1, 1, 1, 2, 10];

end
