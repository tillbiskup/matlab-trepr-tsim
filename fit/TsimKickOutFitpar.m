function dataset = TsimKickOutFitpar(dataset)
% TSIMKICKOUTFITPAR Chek if fitpar is subset or equal to simpar. If fitpar is
% bigger remove parameters from fitpar. 
%
% Usage
%   dataset = TsimKickOutFitpar(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including Tsim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-09-14


RemoveFromFitpar = setdiff(dataset.Tsim.fit.fitpar,fieldnames(dataset.Tsim.sim.simpar));
if isempty(RemoveFromFitpar)
    return
else
           
[dataset.Tsim.fit.fitpar, ifitpar, ~] = intersect(dataset.Tsim.fit.fitpar,fieldnames(dataset.Tsim.sim.simpar));

if ~isempty(dataset.Tsim.fit.lb)
    dataset.Tsim.fit.lb = dataset.Tsim.fit.lb(ifitpar);
end

if ~isempty(dataset.Tsim.fit.ub)
    dataset.Tsim.fit.ub = dataset.Tsim.fit.ub(ifitpar);
end


end