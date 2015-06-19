function dataset = TsimInitializeFallBackParameters(dataset)
% TSIMINITIALIZEFALLBACKPARAMETERS initialize fall back parameters (minsim) with
% values in simpar
%
% Usage
%   dataset = TsimInitializeFallBackParameters(dataset)
%
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-18


% Load Parameters
parameters = TsimParameters;

% Load minimal set of Simulation parameters
minsim = logical(cell2mat(parameters(:,7)));
userpar = logical(cell2mat(parameters(:,9)));
minsimuser = userpar & minsim;

minsimparameters = parameters(minsimuser,1);
minsimparametervalues = parameters(minsimuser,10);

% Create Structure
simpar = cell2struct(minsimparametervalues, minsimparameters,1);

% Put it in dataset
dataset.TSim.sim.simpar = simpar;

end

