function dataset = TsimSim(dataset,varargin)
% TSIMSIM Simulate spectrum using the EasySpin function pepper.
%
% This file uses EasySpin. See http://www.easyspin.org/ 
%
% Usage
%   dataset = TsimSim(dataset)
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2013-2015, Deborah Meyer, Till Biskup
% 2015-06-10

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addRequired('dataset',@(x)isstruct(x));
parser.addParamValue('routine','pepper',@ischar);
parser.parse(dataset,varargin{:});


% Define simulation routine
if isempty(dataset.TSim.sim.routine)
    dataset.TSim.sim.routine = parser.Results.routine;
end
routine = str2func(dataset.TSim.sim.routine);

% Calculating the spectrum using Easyspin's pepper function. The result is
% returned in the field "calculated" of the dataset.

% Call Simpar2EasySpin
dataset = TsimSimpar2EasySpin(dataset);

% Simulate
dataset.calculated(:,1) = routine(dataset.TSim.sim.EasySpin.Sys,...
    dataset.TSim.sim.EasySpin.Exp,dataset.TSim.sim.EasySpin.Opt);

% EasySpin does not normalize the spectra
dataset.calculated(:,1) = dataset.calculated(:,1)./sum(abs(dataset.calculated(:,1)));


% Put Axes information for calculated in main dataset
if min(size(dataset.data)) < 2
    % Only Simulated or 1-d Data
    dataset.axes.calculated(1).values = linspace(...
        dataset.TSim.sim.simpar.Range(1),...
        dataset.TSim.sim.simpar.Range(2),...
        dataset.TSim.sim.simpar.nPoints);
    
    dataset.axes.calculated(1).unit = 'mT';
    dataset.axes.calculated(1).measure = 'magnetic field';
    
else
    % 2-D datata
    dataset.axes.calculated(2).values = linspace(...
        dataset.TSim.sim.simpar.Range(1),...
        dataset.TSim.sim.simpar.Range(2),...
        dataset.TSim.sim.simpar.nPoints);
    
    dataset.axes.calculated(2).unit = 'mT';
    dataset.axes.calculated(2).measure = 'magnetic field';
end



end