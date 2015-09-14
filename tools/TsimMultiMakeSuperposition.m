function superdataset = TsimMultiMakeSuperposition(celldataset, weighting)
% TSIMMULTIMAKESUPERPOSITION Makes a superposition of calculateddata in celldataset
% with given weighting. It gives back a common dataset, with Tsim as cell 
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
% 2015-09-14


superdataset = celldataset{end};
temppurpose = superdataset.Tsim.remarks.purpose;
    superdataset = rmfield(superdataset,'Tsim');
superdataset.calculated = cell(1);
superdataset.Tsim = cell(1);
    
for supercounter = 1:length(celldataset);
    
    superdataset.Tsim{supercounter} = celldataset{supercounter}.Tsim;
    
    superdataset.TSimWeighting = weighting./weighting(1);
    superdataset.calculated{supercounter} =...
        weighting(supercounter).* celldataset{supercounter}.calculated;
end


superdataset.tempcalculated = [];
for datasetNumber = 1:length(celldataset)
    superdataset.tempcalculated(datasetNumber,:) = ...
        celldataset{datasetNumber}.calculated*...
        superdataset.TSimWeighting(datasetNumber);
end
superdataset.calculated = sum(superdataset.tempcalculated,1);
superdataset.calculated = ...
    superdataset.calculated/sum(abs(superdataset.calculated));

superdataset.Tsim{1}.remarks.purpose = temppurpose;

end




