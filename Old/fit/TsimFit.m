function sim = TsimFit(fitparvalues,~,dataset)
% TSIMFIT Calculate fit calling TsimSim and display iterative
% results.
%
% Usage
%   sim = TsimFit(fitparvalues,dataset)
%
%   fitpar   - vector
%              simulation parametervalues
%
%   dataset  - struct
%              Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2013-15, Deborah Meyer, Till Biskup
% 2015-06-12


% Set simpar parameters according to parameters that shall be fitted
dataset = TsimFitpar2simpar(fitparvalues,dataset);

% Calling simulation function
dataset = TsimSim(dataset);

% simulated spectrum
sim = dataset.calculated;

% The current fit parameters are displayed on the command line
disp(num2str(fitparvalues));

end