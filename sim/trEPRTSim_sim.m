function dataset = trEPRTSim_sim(dataset,varargin) %(Sys,Exp,varargin)
% TREPRTSIM_SIM Simulate spectrum using the EasySpin function pepper.
%
% This file uses EasySpin. See http://www.easyspin.org/ 
%
% Usage
%   dataset = trEPRTSim_sim(dataset)
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TREPRTSIM

% (c) 2005, Moritz Kirste
% (c) 2013, Deborah Meyer, Till Biskup
% 2013-09-12

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addRequired('dataset',@(x)isstruct(x));
parser.addParamValue('routine','pepper',@ischar);
parser.parse(dataset,varargin{:});

routine = str2func(parser.Results.routine);

% Convert D and E from GHz in MHz
% ATTENTION: Check whether this is necessary or wrong!
dataset.TSim.sim.Sys.D = dataset.TSim.sim.Sys.D * 1e3;

% Calculating the spectrum using Easyspin's pepper function. sim is the
% return variable.
dataset.calculated(:,1) = routine(dataset.TSim.sim.Sys,dataset.TSim.sim.Exp);

end