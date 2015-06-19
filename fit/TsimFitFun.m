function sim = TsimFitFun(fitparvalues,~,dataset)
% TSIMFITFUN Calculate fit calling TsimSim and display iterative
% results.
%
% Usage
%   sim = TsimFit(fitparvalues,magneticfield,dataset)
%
%   fitpar   - vector
%              simulation parametervalues
%
%   dataset  - struct
%              Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2013-15, Deborah Meyer, Till Biskup
% 2015-06-19


% Set simpar parameters according to parameters that shall be fitted
[dataset,fitparvalues] = TsimFitpar2simpar(fitparvalues,dataset);

% Calling simulation function
dataset = TsimSim(dataset);

% simulated and probably weighted spectrum
[~,sim] = TsimWeightSpectrum(dataset,'calculated');

% The current fit parameters are displayed on the command line
disp(num2str(fitparvalues));


end