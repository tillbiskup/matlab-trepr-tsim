function Bigsim = TsimFitFun(fitparvalues,~,Multidataset)
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
%              Full trEPR toolbox dataset including Tsim structure
%
% See also TSIM

% Copyright (c) 2013-15, Deborah Meyer, Till Biskup
% 2015-09-14

Bigsim = [];

% Set simpar parameters according to parameters that shall be fitted
for numberOfDatasets= 1:length(Multidataset)
    [Multidataset{numberOfDatasets},fitparvalues] = TsimFitpar2simpar(fitparvalues,Multidataset{numberOfDatasets});
    
    % Calling simulation function
    Multidataset{numberOfDatasets} = TsimSim(Multidataset{numberOfDatasets});
    
    % simulated and probably weighted spectrum
    [~,sim] = TsimWeightSpectrum(Multidataset{numberOfDatasets},'calculated');
    
    Bigsim = [Bigsim; sim];

    % The current fit parameters are displayed on the command line
    disp(num2str(fitparvalues));
    
end

end