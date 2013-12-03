function [status] = trEPRTSim_save(saveFilename,dataset)

% TREPRTSIM_SAVE Rescale calculated spectrum and save it calling 
% trEPRTsave.
%
% Usage
%   [status] = trEPRTSim_save(saveFilename,dataset)
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
% See also TREPRTSIM

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-11-29


% Rescale calculated spectrum
dataset.calculated = dataset.TSim.sim.Exp.scale*dataset.calculated;

% Save dataset
[status] = trEPRsave(saveFilename,dataset);

end
