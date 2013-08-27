function sim = trEPRTSim_sim(Sys,Exp,varargin)
% TREPRTSIM_SIM Simulate spectrum using the EasySpin function pepper.
%
% This file uses EasySpin. See http://www.easyspin.org/ 
%
% Usage
%   sim = trEPRTSim_sim(Sys,Exp)
%
%   Sys
%
%   Exp
%
%   sim     - vector
%             calculated spectrum
%
% See also TREPRTSIM

% (c) 2005, Moritz Kirste
% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-27

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addRequired('Sys',@(x)isstruct(x));
parser.addRequired('Exp',@(x)isstruct(x));
parser.addParamValue('routine','pepper',@ischar);
parser.parse(Sys,Exp,varargin{:});

routine = str2func(parser.Results.routine);

% Convert D and E from GHz in MHz
% ATTENTION: Check whether this is necessary or wrong!
Sys.D = Sys.D * 1e3;

% Calculating the spectrum using Easyspin's pepper function and scaling it 
% with the given scaling factor. sim is the return variable.
sim(:,1) = routine(Sys,Exp);

end