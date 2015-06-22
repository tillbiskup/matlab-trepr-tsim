function [dataset,varargout] = TsimWeightSpectrum(dataset,keyword)
% TSIMWEIGHTSPECTRUM Weights spectrum or calculated according to keyword
% for weighted fitting. Can give back the weighted spectrum if needed. If
% either weightingArea and weightingFactor are empty the same data is
% returned.
%
% Usage
%   dataset = TsimCheckBoundary(dataset,'keyword');
%
%   [dataset,varargout] = TsimCheckBoundary(dataset,'keyword');
%
%
%   dataset   - struct
%               Full trEPR toolbox dataset including TSim structure
%
%   keyword   - string
%               can be one of the following: spectrum or calculated
%
%   varargout - vector
%               according to keyword either the weighted spectrum or the
%               weigthed simulated data. The weighted spectrum is in case
%               of the keyword spectrum anyway in the dataset.
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-16

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addRequired('dataset',@isstruct);
parser.addRequired('keyword',@ischar);
parser.parse(dataset,keyword);




switch lower(keyword)
    
    case 'spectrum'
        if isempty(dataset.TSim.fit.weighting.weightingArea) || isempty(dataset.TSim.fit.weighting.weightingFactor)
        spectrum = dataset.TSim.fit.spectrum.tempSpectrum;
        else
        dataset.TSim.fit.spectrum.tempSpectrum = weighting(dataset.TSim.fit.spectrum.tempSpectrum,dataset);
        spectrum = dataset.TSim.fit.spectrum.tempSpectrum;
        end
        varargout{1} = spectrum;
        
    case 'calculated'
        if isempty(dataset.TSim.fit.weighting.weightingArea) || isempty(dataset.TSim.fit.weighting.weightingFactor)
            varargout{1} = dataset.calculated;
        else
            varargout{1} = weighting(dataset.calculated,dataset);
        end
        
end

end


function spectrum = weighting(spectrum, dataset)

% Check if 2d or 1d data
if size(dataset.data) > 1
    inx = interp1(dataset.axes.data(2).values,1:length(dataset.axes.data(2).values),dataset.TSim.fit.weighting.weightingArea,'nearest');
    weightingArea = inx;
    
else
    % 1D data
    inx = interp1(dataset.axes.data(1).values,1:length(dataset.axes.data(1).values),dataset.TSim.fit.weighting.weightingArea,'nearest');
    weightingArea = inx;
end
weightingFactor = dataset.TSim.fit.weighting.weightingFactor;

for k = 1:length(weightingFactor)
    spectrum(weightingArea(k):weightingArea(k+1)) = spectrum(weightingArea(k):weightingArea(k+1)).*weightingFactor(k);
end
end
