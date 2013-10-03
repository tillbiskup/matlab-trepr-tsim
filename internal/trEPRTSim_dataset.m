function dataset = trEPRTSim_dataset(varargin)
% TREPRTSIM_DATASET Return dataset (structure) complying with the trEPR
% toolbox data structure and containing in addition the TSim fields.
%
% If called with an input argument (experimental dataset), the values of
% the experimental dataset are merged into the output structure.
%
% Usage
%   dataset = trEPRTSim_dataset();
%   dataset = trEPRTSim_dataset(data);
%
%   dataset   - struct
%               Full trEPR toolbox dataset including TSim structure
%
%   data      - struct (optional)
%               Experimental dataset (full trEPR toolbox dataset)
%
% See also TREPRTSIM_DATASTRUCTURE, TREPRDATASTRUCTURE

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-10-03

dataset = struct();

% Manual parsing of input argument(s)
if nargin
    if ~isstruct(varargin{1})
        disp('Wrong format of input argument');
        return;
    end
    [m,~] = trEPRdataStructure('check',varargin{1},'quiet');
    if ~isempty(m)
        disp('Input argument misses (necessary) fields.');
        return;
    end
end

% Create data structure
dataset = trEPRdataStructure('structure');

TSim = trEPRTSim_dataStructure();
% Merge TSim into dataset
TSimFieldNames = fieldnames(TSim);
for k=1:length(TSimFieldNames)
    dataset.(TSimFieldNames{k}) = TSim.(TSimFieldNames{k});
end
clear TSim TSimFieldNames k;

% Initialize Sys and Exp from the configuration
conf = trEPRTSim_conf;
dataset.TSim.sim.Sys = conf.Sys;
dataset.TSim.sim.Exp = conf.Exp;

% Merge fitini into TSim structure
fitiniFieldNames = fieldnames(conf.fitini);
for k=1:length(fitiniFieldNames)
    dataset.TSim.fit.fitini.(fitiniFieldNames{k}) = ...
        conf.fitini.(fitiniFieldNames{k});
end
clear fitiniFieldNames k;

% Merge fitopt into TSim structure
fitoptFieldNames = fieldnames(conf.fitopt);
for k=1:length(fitoptFieldNames)
    dataset.TSim.fit.fitopt.(fitoptFieldNames{k}) = ...
        conf.fitopt.(fitoptFieldNames{k});
end
clear fitoptFieldNames k;

dataset.TSim.fit.routine = conf.routines.fit;
dataset.TSim.sim.routine = conf.routines.sim;

if nargin
    data = varargin{1};
    
    % Merge data into dataset
    dataFieldNames = fieldnames(data);
    for k=1:length(dataFieldNames)
        dataset.(dataFieldNames{k}) = data.(dataFieldNames{k});
    end
    clear dataFieldNames k;
    
    % Replace parameters taken from experimental data
    dataset.TSim.sim.Exp.mwFreq = ...
        dataset.parameters.bridge.MWfrequency.value;
    dataset.TSim.sim.Exp.nPoints = size(data.data,1);
    dataset.TSim.sim.Exp.Range = ...
        [dataset.axes.y.values(1) dataset.axes.y.values(end)];
    
end

end