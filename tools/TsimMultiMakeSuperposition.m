function superdataset = TsimMultiMakeSuperposition(celldataset, weighting)
% TSIMMULTIMAKESUPERPOSITION Makes a superposition of calculateddata in celldataset
% with given weighting. It gives back a common dataset, with TSim as cell 
%
%
% Usage
%   superdataset = TsimMultiMakeSuperpostition(celldataset, weighting)
%
%   celldataset - cell
%                 cell of full trEPR toolbox dataset structs including TSim structure
%
%   weighting - vector
%               vector as long as length of celldataset with weighting factors for each dataset
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer
% 2015-09-14


superdataset = celldataset{end};
temppurpose = superdataset.TSim.remarks.purpose;
    superdataset = rmfield(superdataset,'TSim');
superdataset.calculated = cell(1);
superdataset.TSim = cell(1);
    
for supercounter = 1:length(celldataset);
    
    superdataset.TSim{supercounter} = celldataset{supercounter}.TSim;
    
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

superdataset.TSim{1}.remarks.purpose = temppurpose;

end




