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

% Copyright (c) 2013-2015, Deborah Meyer, Till Biskup
% 2015-05-26

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

% Create data structures
dataset = trEPRdataStructure('structure');
TSim = trEPRTSim_dataStructure();

% Merge TSim into dataset
TSimFieldNames = fieldnames(TSim);
for k=1:length(TSimFieldNames)
    dataset.(TSimFieldNames{k}) = TSim.(TSimFieldNames{k});
end
clear TSim TSimFieldNames k;


if nargin
    data = varargin{1};
    
    % Merge data into dataset
    dataFieldNames = fieldnames(data);
    for k=1:length(dataFieldNames)
        dataset.(dataFieldNames{k}) = data.(dataFieldNames{k});
    end
    clear dataFieldNames k;
  
end

end