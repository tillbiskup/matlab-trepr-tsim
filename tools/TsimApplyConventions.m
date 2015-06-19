function dataset = TsimApplyConventions(dataset,varargin)
% TSIMAPPLYCONVENTIONS Apply conventions such as normalization of
% populations and convention E <= 1/3 D for zerofield splitting parameters
%
% Usage
%   dataset = TsimApplyConventions(dataset)
%   dataset = TsimApplyConventions(dataset,<parameter>,<value>)
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% You can specify optional parameters as key-value pairs. Valid parameters
% and their values are:
%
%   populations - boolean
%                 Normalise populations
%                 Default: true
%
%   zfs         - boolean
%                 Normalise zero field splitting parameters
%                 Default: true
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-19

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('dataset', @(x)isstruct(x));
    p.addParamValue('populations',true,@(x)islogical(x));
    p.addParamValue('zfs',true,@(x)islogical(x));
    p.parse(dataset,varargin{:});
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

% Normalize populations
if p.Results.populations
    if isfield(dataset.TSim.sim.simpar,'p1') ...
            && isfield(dataset.TSim.sim.simpar,'p2') ...
            && isfield(dataset.TSim.sim.simpar,'p3')
        [normalized] = TsimPnormalizer([(dataset.TSim.sim.simpar.p1) ...
            (dataset.TSim.sim.simpar.p2) (dataset.TSim.sim.simpar.p3)]);
        
        dataset.TSim.sim.simpar.p1 = normalized(1);
        dataset.TSim.sim.simpar.p2 = normalized(2);
        dataset.TSim.sim.simpar.p3 = normalized(3);
        
    end
end

% D and E should follow the convention E <= 1/3 D
if p.Results.zfs
    if isfield(dataset.TSim.sim.simpar,'D') ...
            && isfield(dataset.TSim.sim.simpar,'E')
        
        converted = TsimDandEconverter(TsimDandEconverter([...
            dataset.TSim.sim.simpar.D dataset.TSim.sim.simpar.E]));
        
        dataset.TSim.sim.simpar.D = converted(1);
        dataset.TSim.sim.simpar.E = converted(2);
    end
    
end