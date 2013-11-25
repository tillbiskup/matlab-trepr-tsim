function dataset = trEPRTSim_SysExp2par(dataset)
% TREPRTSIM_SYSEXP2PAR Transfer Sys,Exp structs to fit parameters.
%
% Usage
%   dataset = trEPRTSim_SysExp2par(dataset)
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TREPRTSIM, TREPRTSIM_PAR2SYSEXP

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-11-25

dataset.TSim.fit.fitini.fitpar(1:3) = dataset.TSim.sim.Sys.g;
dataset.TSim.fit.fitini.fitpar(4)   = dataset.TSim.sim.Sys.D(3)*3/2;
%% Definition of E was wrong! 25.11.13
dataset.TSim.fit.fitini.fitpar(5)   = ...
    (dataset.TSim.sim.Sys.D(1) - dataset.TSim.sim.Sys.D(2))*1/2;
dataset.TSim.fit.fitini.fitpar(6:8) = dataset.TSim.sim.Exp.Temperature;

if isfield(dataset.TSim.sim.Exp,'scale')
    dataset.TSim.fit.fitini.fitpar(9)   = dataset.TSim.sim.Exp.scale;
end

if isfield(dataset.TSim.sim.Sys,'lw')
    dataset.TSim.fit.fitini.fitpar(10:11)   = dataset.TSim.sim.Sys.lw;
end

if isfield(dataset.TSim.sim.Sys,'DStrain')
    dataset.TSim.fit.fitini.fitpar(12:13) = dataset.TSim.sim.Sys.DStrain;
else
    dataset.TSim.fit.fitini.fitpar(12:13) = 0;
end
if isfield(dataset.TSim.sim.Sys,'gStrain')
    dataset.TSim.fit.fitini.fitpar(15:17) = dataset.TSim.sim.Sys.gStrain;
else
    dataset.TSim.fit.fitini.fitpar(15:17) = 0;
end
% Cannot get field offset, therefore, set it to zero
dataset.TSim.fit.fitini.fitpar(14) = 0;

end
