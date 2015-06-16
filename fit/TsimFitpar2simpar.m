function dataset = TsimFitpar2simpar(fitparvalues,dataset)
% TSIMSIMFITPAR2SIMPAR Transfers fitparameter from lsqcurfit to simpar structure.
%
% Usage
%   dataset = TsimFitpar2simpar(dataset)
%
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-12

% Read out parmeters that are fitted and
% change corresponding values in simpar
for k = 1:length(fitparvalues)
   dataset.TSim.sim.simpar.(dataset.TSim.fit.fitpar{k}) = fitparvalues(k); 
end


end