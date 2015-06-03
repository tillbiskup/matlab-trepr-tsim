function dataset = TsimDataset(varargin)
% TSIMDATASET Return dataset (structure) complying with the trEPR
% toolbox data structure and containing in addition the Tsim fields.
%
% If called with an input argument (experimental dataset), the values of
% the experimental dataset are merged into the output structure.
%
% Usage
%   dataset = TsimDataset();
%   dataset = TsimDataset(data);
%
%   dataset   - struct
%               Full trEPR toolbox dataset including Tsim structure
%
%   data      - struct (optional)
%               Experimental dataset (full trEPR toolbox dataset)
%
% See also TSIMDATASTRUCTURE, TREPRDATASTRUCTURE

% Copyright (c) 2013-2015, Deborah Meyer, Till Biskup
% 2015-06-02

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
TSim = TsimDataStructure();

% Merge TSim into dataset
% Ersetzen durch
% dataset = commonStructCopy(dataset,TSim)
TSimFieldNames = fieldnames(TSim);
for k=1:length(TSimFieldNames)
    dataset.(TSimFieldNames{k}) = TSim.(TSimFieldNames{k});
end
clear TSim TSimFieldNames k;


if nargin
    data = varargin{1};
    
    % Merge data into dataset
    % Ersetzen durch
    % dataset = commonStructCopy(dataset,data)
    dataFieldNames = fieldnames(data);
    for k=1:length(dataFieldNames)
        dataset.(dataFieldNames{k}) = data.(dataFieldNames{k});
    end
    clear dataFieldNames k;
  
end

end