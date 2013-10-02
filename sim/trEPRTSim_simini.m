function dataset = trEPRTSim_simini(dataset)
% TREPRTSIM_SIMINI Initialize sim parameters for simulating triplet spectra
% with trEPRTSim.
%
% Usage
%   dataset = trEPRTSim_simini(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TREPRTSIM

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-09-13

% Idea: why don't we create a tosim, analogous to tofit


% Create minimal Sys structure for simulation
% In particular, remove competing fields causing trouble with "pepper".
if isfield(dataset.TSim.sim.Sys,'lw')
    dataset.TSim.sim.Sys = rmfield(dataset.TSim.sim.Sys,'lw');
end
if isfield(dataset.TSim.sim.Sys,'DStrain')
    dataset.TSim.sim.Sys = rmfield(dataset.TSim.sim.Sys,'DStrain');
end
if isfield(dataset.TSim.sim.Sys,'gStrain')
    dataset.TSim.sim.Sys = rmfield(dataset.TSim.sim.Sys,'gStrain');
end

% Set scale to 1
dataset.TSim.sim.Exp.scale = 1;

% Write fields in trEPR datastructure using simulation parameters
% magnetic field
dataset.axes.y.values = linspace(...
    dataset.TSim.sim.Exp.Range(1),...
    dataset.TSim.sim.Exp.Range(2),...
    dataset.TSim.sim.Exp.nPoints ...
    );
dataset.axes.y.unit = 'mT';
% Microwave frequency
dataset.parameters.bridge.MWfrequency.value = dataset.TSim.sim.Exp.mwFreq;
dataset.parameters.bridge.MWfrequency.unit = 'GHz';

end