function [sim] = trEPRTSim_sim(Sys,Exp)
% TREPRTSIM_SIM Simulate spectrum using the EasySpin function pepper.
%
% This file uses EasySpin. See http://www.easyspin.org/ 
%
% Usage
%   [sim,DeltaB] = trEPRTSim_sim(Sys,Exp)
%
%   Sys
%
%   Exp
%
%   sim     - vector
%             calculated spectrum
%
%   DeltaB  - scalar
%             field offset
%
% See also TREPRTSIM

% (c) 2005, Moritz Kirste
% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-12

% Convert D and E from GHz in MHz
Sys.D = Sys.D * 1e3;

% Calculating the spectrum using Easyspin's pepper function and scaling it 
% with the given scaling factor. sim is the return variable.
sim(:,1) = pepper(Sys,Exp);

end