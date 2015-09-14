function dataset = TsimChekFitpar(dataset)
% TSIMCHEKFITPAR Chek if fitpar is subset or equal to simpar. If fitpar is
% bigger add parameters to simpar. If simpar is incompatible with other
% simpar don't add it to simpar and kick it out of fitpar.
%
% Usage
%   dataset = TsimCheckFitpar(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including Tsim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-09-14


missingInSimpar = setdiff(dataset.Tsim.fit.fitpar,fieldnames(dataset.Tsim.sim.simpar));
if isempty(missingInSimpar)
    return
else
           
dataset = TsimChangeSimpar(dataset, missingInSimpar);


dataset = TsimKickOutFitpar(dataset);

end
 