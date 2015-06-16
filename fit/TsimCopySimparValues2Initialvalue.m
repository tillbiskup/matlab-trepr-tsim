function dataset = TsimCopySimparValues2Initialvalue(dataset)
% TSIMCOPYSIMPARVALUES2INITIOALVALUE copies values from simpar according to 
% fitpar into initial values.
%
% Usage
%   dataset = TsimCopySimparValues2Initialvalue(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-10

dataset.TSim.fit.initialvalue = [];

for k=1:length(dataset.TSim.fit.fitpar)
dataset.TSim.fit.initialvalue(k) = dataset.TSim.sim.simpar.(dataset.TSim.fit.fitpar{k});    
end
 