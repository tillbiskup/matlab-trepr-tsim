function dataset = trEPRTSim_fitcut(dataset)
% TREPRTSIM_FITCUT Cuts out some part of the spectrum 
% 
%
% Usage
%   dataset = trEPRTSim_fitcut(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
%
% See also TREPRTSIM

% (c) 2014, Deborah Meyer, Till Biskup
% 2014-05-05



% Interpolation to find actual points in mT
dataset.TSim.fit.fitcut.cutpoints = interp1(dataset.axes.y.values,...
    dataset.axes.y.values,dataset.TSim.fit.fitcut.cutpoints,'nearest');

% Define spectrum
% Check whether data are 2D or 1D, and in case of 2D, take maximum
if min(size(dataset.data)) > 1
    % Take maximum
    [~,idxMax] = max(max(dataset.data));
    spectrum = dataset.data(:,idxMax);
else
    spectrum = dataset.data;
end

% Create mutilated field
% Find indices of proper field position
indices = arrayfun(@(x)find(dataset.axes.y.values ==x),...
    reshape(dataset.TSim.fit.fitcut.cutpoints',1,[]));

indpairs = reshape(indices,2,[])';

vec = [];
for k = 1:size(indpairs,1)
    vec = [ vec indpairs(k,1):1:indpairs(k,2)]; %#ok<AGROW>
end
dataset.TSim.fit.fitcut.cuttedIndices = unique(sort(vec));
dataset.TSim.fit.fitcut.mutilatedField = dataset.axes.y.values;
dataset.TSim.fit.fitcut.mutilatedField(unique(sort(vec))) = [];
% Create mutilated spectrum
dataset.TSim.fit.fitcut.mutilatedData = spectrum;
dataset.TSim.fit.fitcut.mutilatedData(unique(sort(vec))) = [];

end