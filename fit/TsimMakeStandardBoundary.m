function dataset = TsimMakeStandardBoundary(dataset,varargin)
% TSIMMAKESTANDARDBOUNDARIES Create standardboundaries for the parameters in varargin.
% If the function is called without additional parameters it creates
% standardboundaries for the whole fitparameter vector.
% The boundary is plus minus 5 % of the value.
%
% Usage
%   dataset = TsimMakeStandardBoundary(dataset);
%   dataset = TsimMakeStandardBoundary(dataset,parameter)
%
%   dataset   - struct
%               Full trEPR toolbox dataset including TSim structure
%
%   parameter - cell
%               names of fitparameters to create boundaries for
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-22


% Set default values
fraction = 1/20;

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addRequired('dataset',@(x)isstruct(x));
parser.addOptional('parameter',{},@iscell);
parser.parse(dataset,varargin{:});

parameter=parser.Results.parameter;


if isempty(parameter) && ~isempty(varargin)
    return
end

if isempty(varargin)
    parameter = dataset.TSim.fit.fitpar;
end

[~,indexNotFound,~] = intersect(dataset.TSim.fit.fitpar,parameter,'stable');

for k=indexNotFound
    dataset.TSim.fit.lb(k) = dataset.TSim.fit.initialvalue(k)-dataset.TSim.fit.initialvalue(k)*fraction;
    dataset.TSim.fit.ub(k) = dataset.TSim.fit.initialvalue(k)+dataset.TSim.fit.initialvalue(k)*fraction;
end

end