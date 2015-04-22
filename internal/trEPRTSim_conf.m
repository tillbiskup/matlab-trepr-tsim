function conf = trEPRTSim_conf(varargin)
% TREPRTSIM_CONF Return configuration settings for simulating and fitting
% triplet spectra with trEPRTSim.
%
% Usage
%   conf = trEPRTSim_conf();
%
%   conf - struct
%          Structure containing the configuration settings for the
%          trEPRTSim module
%
% See also TREPRTSIM

% (c) 2013-14, Deborah Meyer, Till Biskup
% 2015-01-13

% TODO: Read configuration from file

% For now, just create configuration structure and fill it manually
% IMPORTANT: Configuration settings are set (manually) only here!
gx = 2.002;
gy = 2.002;
gz = 2.002;
D = 760;    % in MHz (!)
E = 250;    % in MHz (!)


conf = struct(...
    'Sys',struct(...
        'S', 1,...
        'g', [gx gy gz],...
        'D',[-D/3+E, -D/3-E, 2*D/3],...
        'lw',[2 2],...
        'DStrain',[200.0 0],...
        'gStrain',[1e-5 1e-5 1e-5]...
        ),...
    'Exp',struct(...
        'mwFreq',9.70,...
        'nPoints',326,...
        'Range',[280 410],...
        'Harmonic',0,...
        'Temperature',[0.3 0.33 0.37], ...
        'scale',0.015,...
        'DeltaB',0, ...
        'Ordering',0 ...
        ),...
     'Opt',struct(...
            'nKnots',[31 0],...
            'Method','matrix'...
            ),...
    'fitini',struct(...
        'lb',   [1.5  1.5  1.5  300    50   0 0 0 0 0  0  0    1   -3 1e-8 1e-8 1e-8 -10],...
        'ub',   [2.5  2.5  2.5  1500   800  1 1 1 1 10 10 1000 100  3 1e-3 1e-3 1e-3 10],...
        'tofit',[0    0    0    1      1    1 1 1 1 1  1  0    0    1 0    0    0    0] ...
        ),...
    'fitopt',struct(...
        'MaxIter',1,...
        'TolFun',1.0e-10 ...
        ),...
    'routines',struct(...
        'sim','pepper',...
        'fit','lsqcurvefit' ...
        )...
    );
conf.fitini.fitparameters = {'D','E','p1','p2','p3','scale','lw', 'DeltaB'};


% Normalize populations
conf.Exp.Temperature = conf.Exp.Temperature/sum(conf.Exp.Temperature);

end
