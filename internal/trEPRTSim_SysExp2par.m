function [fitpar] = trEPRTSim_SysExp2par(Sys,Exp)
% TREPRTSIM_SYSEXP2PAR Transfer fitted parameters back to Sys,Exp structs.
%
% Usage
%   [fitpar] = trEPRTSim_SysExp2par(Sys,Exp)
%
%   fitpar  - vector
%             full set of all possible simulation parameters
%
%   Sys     - struct
%             EasySpin structure for defining spin system
%
%   Exp     - struct
%             EasySpin structure for defining experimental parameters
%
% See also TREPRTSIM, TREPRTSIM_PAR2SYSEXP

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-09-10

fitpar(1)   = Sys.D(3)*3/2;
fitpar(2)   = Sys.D(1)+fitpar(1)/3;
fitpar(3:5) = Exp.Temperature;
fitpar(6)   = Exp.scale;
fitpar(7)   = Sys.lw;

if isfield(Sys,'DStrain')
    fitpar(8:9) = Sys.DStrain;
else
    fitpar(8:9) = 0;
end
if isfield(Sys,'gStrain')
    fitpar(11:13) = Sys.gStrain;
else
    fitpar(11:13) = 0;
end
% Cannot get field offset, therefore, set it to zero
fitpar(10) = 0;

end
