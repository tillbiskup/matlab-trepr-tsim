function str = strJoin(C,varargin)
% STRJOIN Join strings in cell array into single string.
%
% Usage:
%    str = strjoin(C)
%    str = strjoin(C,delimiter)
%
% Please note: Starting with Matlab(r) version 2013a, there exists a
% function with the similar name "strjoin".

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-23

% Check whether builtin function "strjoin" exists, and if so, use it.
if exist('strjoin','builtin')
    str = strjoin(C,varargin);
    return;
end

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addRequired('C',@(x)iscell(x));
parser.addOptional('delimiter',' ',@(x)ischar(x) || (iscell(x)));
parser.parse(C,varargin{:});

if iscell(parser.Results.delimiter)
    if length(parser.Results.delimiter) ~= length(parser.Results.C)-1
        disp('Error: Delimiter has wrong size');
        return;
    end
    tmpC = cell(length(parser.Results.delimiter));
    for k=1:length(parser.Results.delimiter)
        tmpC{k} = [parser.Results.C{k} parser.Results.delimiter{k}];
    end
    str = [tmpC{:} C{end}];
else
    tmpC = cellfun(@(x)[x parser.Results.delimiter],C(1:end-1),...
        'UniformOutput',false);
    str = [tmpC{:} C{end}];
end

end