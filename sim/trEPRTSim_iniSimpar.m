function dataset = trEPRTSim_iniSimpar(dataset)
% TREPRTSIM_INISimpar Initialize simpar parameters for simulating triplet spectra
% with trEPRTSim. Creates minimal parameters in the simpar structure and
% fills it with values. If there is already was in there nothing is changed
%
% Usage
%   dataset = trEPRTSim_simini(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TREPRTSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-05-29

% Check if there is already some information
if ~isempty(fieldnames(dataset.TSim.sim.simpar))
    return
end

% TODO: read Configuration and add parameternames to simparstructure and put
% appropriate values in simpar structure too.
parameters = trEPRTSim_parameters;

% Load minimal set of Simulation parameters
minsim = logical(cell2mat(parameters(:,7)));
userpar = logical(cell2mat(parameters(:,9)));
minsimuser = userpar & minsim;

minsimparameters = parameters(minsimuser,1);
minsimparametervalues = parameters(minsimuser,10);

% Create Structure
simpar = cell2struct(minsimparametervalues, minsimparameters,1);

% Put it in dataset
dataset.TSim.sim.simpar = simpar;

% Do you have experimental data?
if ~isempty(dataset.data)
    % Write experimental things to simpar
    dataset.TSim.sim.simpar.mwFreq = dataset.parameters.bridge.MWfrequency.value;
    dataset.TSim.sim.simpar.nPoints = length(dataset.axes.y.values);
    dataset.TSim.sim.simpar.Range(1) = min(dataset.axes.y.values);
    dataset.TSim.sim.simpar.Range(2) = max(dataset.axes.y.values);
    
end


% normalize populations
if isfield(dataset.TSim.sim.simpar,'p1') && isfield(dataset.TSim.sim.simpar,'p2') && isfield(dataset.TSim.sim.simpar,'p3')
    [normalized] = trEPRTSim_Pnormalizer([(dataset.TSim.sim.simpar.p1) (dataset.TSim.sim.simpar.p2) (dataset.TSim.sim.simpar.p3)]);
    
    dataset.TSim.sim.simpar.p1 = normalized(1);
    dataset.TSim.sim.simpar.p2 = normalized(2);
    dataset.TSim.sim.simpar.p3 = normalized(3);
    
end

% D and E should follow the convention E <= 1/3 D
if isfield(dataset.TSim.sim.simpar,'D') && isfield(dataset.TSim.sim.simpar,'E')
    
    converted = trEPRTSim_DandEconverter(trEPRTSim_DandEconverter([dataset.TSim.sim.simpar.D dataset.TSim.sim.simpar.E]));
    
    dataset.TSim.sim.simpar.D = converted(1);
    dataset.TSim.sim.simpar.E = converted(2);
    
end


end