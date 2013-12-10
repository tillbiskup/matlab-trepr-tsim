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
% Initial values and boundaries are taken from the configuration initially
% (i.e. if not provided by the user) or if new parameters have been chosen.
%
% Boundaries are checked and if a new initial value is outside the
% predefined boundaries, they will be rearranged centered around the new
% initial value (and a warning displayed on the command line).
%
% See also TREPRTSIM

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-12-10

% Convert tofit into boolean values
dataset.TSim.fit.fitini.tofit = logical(dataset.TSim.fit.fitini.tofit);

% Set fit parameters
parameters = trEPRTSim_fitpar();
% Get old fit parameters (for handling boundaries), set fit parameters
oldTofit = ismember(parameters(:,1)',dataset.TSim.fit.fitini.fitparameters);
dataset.TSim.fit.fitini.fitparameters = ...
    parameters(dataset.TSim.fit.fitini.tofit,1)';

% Get values from configuration
conf = trEPRTSim_conf();

% Generate fit parameters from Sys and Exp if necessary
if isempty(dataset.TSim.fit.inipar)
    % Try to get configured start values
    % NOTE: This is currently a rather ugly way and needs refactoring!
    confdataset = dataset;
    confdataset.TSim.sim.Sys = conf.Sys;
    confdataset.TSim.sim.Exp = conf.Exp;
    dataset = trEPRTSim_SysExp2par(confdataset);
    % Actual setting of parameters from real dataset
    % Needs to be done after setting the values from the configuration and
    % overwrites those values where necessary.
    dataset = trEPRTSim_SysExp2par(dataset);
end

% Transfer changed boundaries if necessary
if length(dataset.TSim.fit.fitini.lb) ...
        ~= length(dataset.TSim.fit.fitini.tofit)
    conf.fitini.lb(oldTofit) = dataset.TSim.fit.fitini.lb;
    conf.fitini.ub(oldTofit) = dataset.TSim.fit.fitini.ub;
end

% Reduce inipar and boundaries to set of parameters that shall be
% fitted.
dataset.TSim.fit.inipar = ...
    dataset.TSim.fit.fitini.fitpar(dataset.TSim.fit.fitini.tofit);
dataset.TSim.fit.fitini.lb = ...
    conf.fitini.lb(dataset.TSim.fit.fitini.tofit);
dataset.TSim.fit.fitini.ub = ...
    conf.fitini.ub(dataset.TSim.fit.fitini.tofit);

% Check boundaries for consistency with initial values
for k=1:length(dataset.TSim.fit.inipar)
    if dataset.TSim.fit.inipar(k) < dataset.TSim.fit.fitini.lb(k) ...
            || dataset.TSim.fit.inipar(k) > dataset.TSim.fit.fitini.ub(k)
        % Get span of boundaries
        lbub = dataset.TSim.fit.fitini.ub(k)-dataset.TSim.fit.fitini.lb(k);
        % Center boundaries around initial value
        dataset.TSim.fit.fitini.lb(k) = dataset.TSim.fit.inipar(k)-lbub/2;
        dataset.TSim.fit.fitini.ub(k) = dataset.TSim.fit.inipar(k)+lbub/2;
        disp(' ');
        disp('Warning: Some boundaries have been adjusted.');
    end
end

% Check field values against experimental values
if dataset.TSim.sim.Exp.Range(1) ~= min(dataset.axes.y.values) || ...
        dataset.TSim.sim.Exp.Range(2) ~= max(dataset.axes.y.values)
    dataset.TSim.sim.Exp.Range = [min(dataset.axes.y.values) ...
        max(dataset.axes.y.values)];
    dataset.TSim.sim.Exp.nPoints = length(dataset.axes.y.values);
end

end