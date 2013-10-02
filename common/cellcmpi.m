function TF = cellcmpi(C1,C2)
% CELLCMPI Compare strings in cell array C1 with those in cell array C2
% ignoring case. Cell arrays C1 and C2 must consist of strings only.
%
% Usage
%   TF = cellcmpi(C1,C2);
%
%   C1,C2 - cell array
%           Cell arrays to compare
%
%   TF    - boolean vector
%           Vector of the same length as max(length(C1),length(C2))
%           containing boolean (logical) values of the element-wise
%           comparison
%
% The longer cell array is checked for occurrences of elements of the
% shorter cell array.
%
% To get the indices of the longer cell array that are identical with those
% in the shorter cell array, use find(cellcmpi(C1,C2)).
%
% CELLCMPI uses STRCMPI internally.
%
% See also CELLCMP, STRCMPI

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-10-02

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addRequired('C1',@(x)iscell(x));
parser.addRequired('C2',@(x)iscell(x));

% Test whether all elements of both cells are strings
if ~all(cellfun(@(x)ischar(x),C1)) || ~all(cellfun(@(x)ischar(x),C2))
    error('Cells need to contain only strings.');
end

if length(C2) > length(C1)
    TF = cellfun(@(x)any(strcmpi(x,C1)),C2);
else
    TF = cellfun(@(x)any(strcmpi(x,C2)),C1);
end

end