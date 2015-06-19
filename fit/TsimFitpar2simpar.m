function [dataset,fitparvalues] = TsimFitpar2simpar(fitparvalues,dataset)
% TSIMSIMFITPAR2SIMPAR Transfers fitparameter from lsqcurfit to simpar structure.
%
% Usage
%   dataset = TsimFitpar2simpar(dataset)
%   [dataset,fitparvalues] = TsimFitpar2simpar(dataset)
%
%   dataset      - struct
%                  Full trEPR toolbox dataset including TSim structure
%
%   fitparvalues - vector
%                  Values of fit parameters (normalised/according to
%                  conventions)
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-19

% Chek fitparameters for fitting only one ore two populations and imply 
% constrains. fitparvalues are changed!


populations = {'p1'; 'p2'; 'p3'};
howmany=ismember(dataset.TSim.fit.fitpar,populations);
switch sum(howmany)
    case 2
        % two population are free for fitting: sum of the two must be equal
        % to 1-the other pop
        values = fitparvalues(howmany);
        otherPopulationName = cell2mat(setdiff(populations,dataset.TSim.fit.fitpar));
        otherPopulation = dataset.TSim.sim.simpar.(otherPopulationName);
        newvalues = values.*((1-otherPopulation)/sum(values));
        fitparvalues(howmany) = newvalues;
        
    case 3
        values = fitparvalues(howmany);
        newvalues = TsimPnormalizer(values);
        fitparvalues(howmany) = newvalues;
end

% Read out parmeters that are fitted and
% change corresponding values in simpar

for k = 1:length(fitparvalues)
    dataset.TSim.sim.simpar.(dataset.TSim.fit.fitpar{k}) = fitparvalues(k);
end

end