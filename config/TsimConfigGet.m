function config = TsimConfigGet(fileName)
% TSIMCONFIGGET Return configuration read from given file.
%
% Usage
%   config = TsimConfigGet(filename)
%
%   filename - string
%              Name of config file to get contents from
%              Only filename without path and extension
%
%   config   - struct
%              Configuration loaded from given config file
%              Empty struct if no configuration could be loaded.

% Copyright (c) 2015, Till Biskup
% 2015-06-01

config = commonConfigGet(fileName);

end