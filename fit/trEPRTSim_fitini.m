function dataset = trEPRTSim_fitini(dataset)
% TREPRTSIM_FITINI Initialize fit parameters for fitting triplet spectra
% with trEPRTSim.
%
% Usage
%   dataset = trEPRTSim_fitini(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TREPRTSIM

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-09-13

% Transfer fit parameters to Sys and Exp
% TODO: Check whether this is necessary/sensible to do here
dataset = trEPRTSim_SysExp2par(dataset);

% Convert tofit into boolean values
dataset.TSim.fit.fitini.tofit = logical(dataset.TSim.fit.fitini.tofit);

% Set fitparameters
parameters = trEPRTSim_fitpar();
dataset.TSim.fit.fitini.fitparameters = ...
    parameters(dataset.TSim.fit.fitini.tofit,1)';

% Get values from configuration
conf = trEPRTSim_conf();

% Reduce inipar and boundaries to set of parameters that shall be fitted.
dataset.TSim.fit.inipar = ...
    dataset.TSim.fit.fitini.fitpar(dataset.TSim.fit.fitini.tofit);
dataset.TSim.fit.fitini.lb = ...
    conf.fitini.lb(dataset.TSim.fit.fitini.tofit);
dataset.TSim.fit.fitini.ub = ...
    conf.fitini.ub(dataset.TSim.fit.fitini.tofit);
