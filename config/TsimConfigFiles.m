function files = TsimConfigFiles
% TSIMCONFIGFILES Return configuration files existing for Tsim.
%
% Usage
%   files = TsimConfigFiles()
%
%   files - cell array (of strings)
%           Name of config files available for the toolbox and located in
%           the toolbox configuration directory (without extension)
%

% Copyright (c) 2015, Deborah Meyer
% 2015-09-15

files = commonConfigFiles();

end