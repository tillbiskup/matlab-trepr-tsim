function TsimConfigSet(fileName,config)
% TSIMCONFIGSET Write configuration to given file.
%
% Usage
%   TsimConfigSet(filename,config)
%
%   filename - string
%              Name of config file to save configuration to
%              Only filename without path and extension
%
%   config   - struct
%              Configuration to be saved to given config file
%
% SEE ALSO: commonConfigGet, commonConfigCreate, commonConfigMerge

% Copyright (c) 2015, Till Biskup
% 2015-06-01

commonConfigSet(fileName,config)

end