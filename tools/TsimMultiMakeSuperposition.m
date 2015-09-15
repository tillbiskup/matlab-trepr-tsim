function superdataset = TsimMultiMakeSuperposition(celldataset, weighting)
% TSIMMULTIMAKESUPERPOSITION Makes a superposition of calculated data in celldataset
% with given weighting. It gives back a common dataset, with Tsim as array of structs 
%
%
% Usage
%   superdataset = TsimMultiMakeSuperpostition(celldataset, weighting)
%
%   celldataset - cell
%                 cell of full trEPR toolbox dataset structs including Tsim structure
%
%   weighting - vector
%               vector as long as length of celldataset with weighting factors for each dataset
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer
% 2015-09-15


superdataset = celldataset{1};
temppurpose = superdataset.Tsim(1).remarks.purpose;
superdataset.calculated = cell(1);

    
for supercounter = 1:length(celldataset);
    
    superdataset.Tsim(supercounter) = celldataset{supercounter}.Tsim(1);
    superdataset.calculated{supercounter} =...
        weighting(supercounter).* celldataset{supercounter}.calculated;
    superdataset.Tsim(supercounter).remarks.purpose = temppurpose;
    superdataset.Tsim(supercounter).weighting = weighting(supercounter)/weighting(1);
end


superdataset.tempcalculated = [];
for datasetNumber = 1:length(celldataset)
    superdataset.tempcalculated(datasetNumber,:) = ...
        celldataset{datasetNumber}.calculated*...
        superdataset.Tsim(datasetNumber).weighting;
end
superdataset.calculated = sum(superdataset.tempcalculated,1);
superdataset.calculated = ...
    superdataset.calculated/sum(abs(superdataset.calculated));

superdataset=rmfield(superdataset,'tempcalculated') ;
superdataset.calculated = superdataset.calculated';
end




