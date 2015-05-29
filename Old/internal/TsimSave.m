function [status] = TsimSave(saveFilename,dataset)

% TSIMSAVE Rescale calculated spectrum and save it calling 
% trEPRTsave.
%
% Usage
%   [status] = TsimSave(saveFilename,dataset)
%
%   status        - integer
%                   0 - everthing is fine
%                   1 - something is wrong
%
%   saveFilename  - string
%                   suggested filename for saving   
%
%   dataset       - struct
%                   Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2013, Deborah Meyer, Till Biskup
% 2013-11-29

% Save dataset
[status] = trEPRsave(saveFilename,dataset);

end
