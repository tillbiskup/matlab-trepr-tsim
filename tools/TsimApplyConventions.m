function dataset = TsimApplyConventions(dataset)
% TSIMAPPLYCONVENTIONS Apply conventions such as normalization of
% populations and convention E <= 1/3 D for zerofield splitting parameters
%
% Usage
%   dataset = TsimApplyConventions(dataset)
%
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-02


% Normalize populations
if isfield(dataset.TSim.sim.simpar,'p1') && isfield(dataset.TSim.sim.simpar,'p2') && isfield(dataset.TSim.sim.simpar,'p3')
    [normalized] = TsimPnormalizer([(dataset.TSim.sim.simpar.p1) (dataset.TSim.sim.simpar.p2) (dataset.TSim.sim.simpar.p3)]);
    
    dataset.TSim.sim.simpar.p1 = normalized(1);
    dataset.TSim.sim.simpar.p2 = normalized(2);
    dataset.TSim.sim.simpar.p3 = normalized(3);
    
end

% D and E should follow the convention E <= 1/3 D
if isfield(dataset.TSim.sim.simpar,'D') && isfield(dataset.TSim.sim.simpar,'E')
    
    converted = TsimDandEconverter(TsimDandEconverter([dataset.TSim.sim.simpar.D dataset.TSim.sim.simpar.E]));
    
    dataset.TSim.sim.simpar.D = converted(1);
    dataset.TSim.sim.simpar.E = converted(2);
    
end