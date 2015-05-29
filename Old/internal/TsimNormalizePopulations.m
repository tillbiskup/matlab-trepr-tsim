function dataset = TsimNormalizePopulations(dataset)
% TSIMNORMALIZEPOPULATIONS Normalize all populations in whole dataset.
%
% Usage
%   dataset = TsimNormalizePopulations(dataset)
%
%   
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM, TSIMSYSEXP2PAR

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-04-22

populationParameterNames = {'p1','p2','p3'};

dataset.TSim.sim.Exp.Temperature = ...
    normalize(dataset.TSim.sim.Exp.Temperature);

% Was something fitted already?
if isempty(dataset.TSim.fit.fittedpar)
    return;
end

% Find out whether populations (or parts of them) were fitted
Elephant=ismember(dataset.TSim.fit.fitini.fitparameters,populationParameterNames);

switch sum(Elephant)
    case 3
        dataset.TSim.fit.fittedpar(Elephant) = ...
            normalize(dataset.TSim.fit.fittedpar(Elephant));
    case 2
        
    case 1
        
    otherwise
    
end

end

function normalized=normalize(notNormalized)

normalized = notNormalized/sum(notNormalized);
    
end