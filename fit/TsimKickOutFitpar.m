function dataset = TsimKickOutFitpar(dataset)
% TSIMKICKOUTFITPAR Chek if fitpar is subset or equal to simpar. If fitpar is
% bigger remove parameters from fitpar. 
%
% Usage
%   dataset = TsimKickOutFitpar(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-10


RemoveFromFitpar = setdiff(dataset.TSim.fit.fitpar,fieldnames(dataset.TSim.sim.simpar));
if isempty(RemoveFromFitpar)
    return
else
           
dataset.TSim.fit.fitpar = intersect(dataset.TSim.fit.fitpar,fieldnames(dataset.TSim.sim.simpar));

end