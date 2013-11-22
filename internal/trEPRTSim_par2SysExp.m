function dataset = trEPRTSim_par2SysExp(par,dataset)
% TREPRTSIM_PAR2SYSEXP Transfer fitted parameters back to Sys,Exp structs.
%
% Usage
%   dataset = trEPRTSim_par2SysExp(par,dataset)
%
%   par     - vector
%             simulation parameters that shall be fitted
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TREPRTSIM, TREPRTSIM_SYSEXP2PAR

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-11-22

% Merge parameters to be fitted into vector of all possible fit parameters
dataset.TSim.fit.fitini.fitpar(dataset.TSim.fit.fitini.tofit) = ...
    par(1:length(find(dataset.TSim.fit.fitini.tofit)));

% [D   E   Exp.Temperature scale lw lwD lwE DeltaB gx   gy   gz  ]
dataset.TSim.sim.Sys.D = [...
    -dataset.TSim.fit.fitini.fitpar(1)/3 + dataset.TSim.fit.fitini.fitpar(2),...
    -dataset.TSim.fit.fitini.fitpar(1)/3 - dataset.TSim.fit.fitini.fitpar(2),...
    2*dataset.TSim.fit.fitini.fitpar(1)/3 ...
    ];
dataset.TSim.sim.Exp.Temperature = dataset.TSim.fit.fitini.fitpar(3:5);
dataset.TSim.sim.Exp.scale = dataset.TSim.fit.fitini.fitpar(6);
dataset.TSim.sim.Sys.lw = dataset.TSim.fit.fitini.fitpar(7:8);

if any(dataset.TSim.fit.fitini.tofit(9:10))
    dataset.TSim.sim.Sys.DStrain = dataset.TSim.fit.fitini.fitpar(9:10);
elseif isfield(dataset.TSim.sim.Sys,'DStrain')
    dataset.TSim.sim.Sys = rmfield(dataset.TSim.sim.Sys,'DStrain');
end

% Adjusting field offset
dataset.TSim.sim.Exp.Range = ...
    dataset.TSim.sim.Exp.Range+dataset.TSim.fit.fitini.fitpar(11);

if any(dataset.TSim.fit.fitini.tofit(12:14))
    dataset.TSim.sim.Sys.gStrain = dataset.TSim.fit.fitini.fitpar(12:14);
elseif isfield(dataset.TSim.sim.Sys,'gStrain')
    dataset.TSim.sim.Sys = rmfield(dataset.TSim.sim.Sys,'gStrain');
end

end
