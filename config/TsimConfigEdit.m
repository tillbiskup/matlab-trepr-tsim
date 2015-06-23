function TsimConfigEdit(fileName)
% TSIMCONFIGEDIT Open configuration file in Matlab(r) editor.
%
% Usage
%   TsimConfigEdit(filename)
%   TsimConfigEdit(filename,<param>,<value>)
%
%   filename - string
%              Name of config file to get contents from
%              Only filename without path and extension
%
%
% NOTE: If the config directory doesn't exist, it will get created. If the
% file doesn't exist, the Matlab(r) editor will show a dialogue asking the
% user whether she/he wants to create the file.
%
% SEE ALSO: commonConfigGet, commonConfigSet, commonConfigCreate,
% commonConfigMerge

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-23

commonConfigEdit(fileName)

end