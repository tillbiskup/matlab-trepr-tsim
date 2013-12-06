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

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-12-06

% TODO: Read configuration from file

% For now, just create configuration structure and fill it manually
% IMPORTANT: Configuration settings are set (manually) only here!
gx = 2.02;
gy = 2.02;
gz = 2.02;
D = 3.9e3;    % in MHz (!)
E = 0.13e3;    % in MHz (!)


conf = struct(...
    'Sys',struct(...
        'S', 1,...
        'g', [gx gy gz],...
        'D',[-D/3+E, -D/3-E, 2*D/3],...
        'lw',[9 0],...
        'DStrain',[80.0 70.0],...
        'gStrain',[1e-5 1e-5 1e-5]...
        ),...
    'Exp',struct(...
        'mwFreq',9.70,...
        'nPoints',361,...
        'Range',[260 440],...
        'Harmonic',0,...
        'Temperature',[0.00 0.45 0.55], ...
        'scale',0.015,...
        'DeltaB',0 ...        
        ),...
     'Opt',struct(...
            'nKnots',[31 0],...
            'Method','matrix'...
            ),...
    'fitini',struct(...
        'lb',   [1.5  1.5  1.5  3.7e3  0.1e3  0 0 0 0 0 0  1   1   -3 1e-8 1e-8 1e-8],...
        'ub',   [2.5  2.5  2.5  4.1e3  1e3    1 1 1 1 1 4  100 100  3 1e-3 1e-3 1e-3],...
        'tofit',[1    1    1    1      1      1 1 1 1 1 1  0   0    0 0    0    0] ...
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
conf.fitini.fitparameters = {'gx','gy','gz','D','E','p1','p2','p3','scale','lw'};


% Normalize populations
conf.Exp.Temperature = conf.Exp.Temperature/sum(conf.Exp.Temperature);

end
