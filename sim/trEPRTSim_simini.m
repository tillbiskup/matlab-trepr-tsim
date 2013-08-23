function [Sys,Exp] = trEPRTSim_simini()
% TREPRTSIM_SIMINI Initialize standard set of parameters for simulating
% triplet spectra with trEPRTSim.
%
% Usage
%   [Sys,Exp] = trEPRTSim_simini();
%
%   Sys   - struct
%           EasySpin structure for defining spin system
%
%   Exp   - struct
%           EasySpin structure for defining experimental parameters
%
% See also TREPRTSIM

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-23

% Initialization of those parts of Sys and Exp that are always
% the same.
g = 2.0034;
Sys = struct(...
    'S', 1,...
    'g', [g g g] ...
    );
Exp = struct(...
    'mwFreq',9.70,...
    'nPoints',361,...
    'Range',[260 440],...
    'Harmonic',0 ...
    );

% These parameters are always needed and don't depend on the chosen
% value of the variable 'choice'
D = 1.6;                        % in GHz
E = 0.5;                        % in GHz


% Setting the polarisation vector and the D vector
% (see EasySpin documentation)
Exp.Temperature = [0.00 0.45 0.55] ;
% Normalize populations
Exp.Temperature = Exp.Temperature/sum(Exp.Temperature);
Sys.D = [-D/3 + E, -D/3 - E, 2*D/3];

end
