function idx = cellcmpi(array1,array2)
% cellcmpi Return indices of strings in cell array 1 that are
% contained in cell array 2. Case insensitive
%
% Usage
%   idx = cellcmpi();
%
% See also cellcmp

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-10-02

% Loop over those:
find(strcmpi(array1,array2{1}))
% ...

end