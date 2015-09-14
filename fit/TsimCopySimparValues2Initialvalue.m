function dataset = TsimCopySimparValues2Initialvalue(dataset)
% TSIMCOPYSIMPARVALUES2INITIOALVALUE copies values from simpar according to 
% fitpar into initial values.
%
% Usage
%   dataset = TsimCopySimparValues2Initialvalue(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including Tsim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-09-14

dataset.Tsim.fit.initialvalue = [];

for k=1:length(dataset.Tsim.fit.fitpar)
dataset.Tsim.fit.initialvalue(k) = dataset.Tsim.sim.simpar.(dataset.Tsim.fit.fitpar{k});    
end
 