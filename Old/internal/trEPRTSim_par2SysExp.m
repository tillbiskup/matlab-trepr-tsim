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

% Copyright (c) 2013-15, Deborah Meyer, Till Biskup
% 2015-04-22

% Merge parameters to be fitted into vector of all possible fit parameters
dataset.TSim.fit.fitini.fitpar(dataset.TSim.fit.fitini.tofit) = ...
    par(1:length(find(dataset.TSim.fit.fitini.tofit)));

% [gx gy gz D  E   Exp.Temperature scale lw lwD lwE DeltaB gxStrain   gyStrain   gzStrain Ordering  ]

dataset.TSim.sim.Sys.g = dataset.TSim.fit.fitini.fitpar(1:3);

dataset.TSim.sim.Sys.D = [...
    -dataset.TSim.fit.fitini.fitpar(4)/3 + dataset.TSim.fit.fitini.fitpar(5),...
    -dataset.TSim.fit.fitini.fitpar(4)/3 - dataset.TSim.fit.fitini.fitpar(5),...
    2*dataset.TSim.fit.fitini.fitpar(4)/3 ...
    ];

% Normalize Populations
dataset = trEPRTSim_normalizePopulations(dataset);

dataset.TSim.sim.Exp.Temperature = dataset.TSim.fit.fitini.fitpar(6:8);
dataset.TSim.sim.Exp.scale = dataset.TSim.fit.fitini.fitpar(9);
dataset.TSim.sim.Sys.lw = dataset.TSim.fit.fitini.fitpar(10:11);

if any(dataset.TSim.fit.fitini.tofit(12:13))
    dataset.TSim.sim.Sys.DStrain = dataset.TSim.fit.fitini.fitpar(12:13);
elseif isfield(dataset.TSim.sim.Sys,'DStrain')
    dataset.TSim.sim.Sys = rmfield(dataset.TSim.sim.Sys,'DStrain');
end

% Adjusting field offset
dataset.TSim.sim.Exp.Range = ...
    dataset.TSim.sim.Exp.Range+dataset.TSim.fit.fitini.fitpar(14);

if any(dataset.TSim.fit.fitini.tofit(15:17))
    dataset.TSim.sim.Sys.gStrain = dataset.TSim.fit.fitini.fitpar(15:17);
elseif isfield(dataset.TSim.sim.Sys,'gStrain')
    dataset.TSim.sim.Sys = rmfield(dataset.TSim.sim.Sys,'gStrain');
end

% Ordering 
if any(dataset.TSim.fit.fitini.tofit(18))
    dataset.TSim.sim.Exp.Ordering = dataset.TSim.fit.fitini.fitpar(18);
elseif isfield(dataset.TSim.sim.Exp,'Ordering')
    dataset.TSim.sim.Exp = rmfield(dataset.TSim.sim.Exp,'Ordering');
end


end
