function dataset = TsimIniSimpar(dataset)
% TSIMINISIMPAR Initialize simpar parameters for simulating triplet spectra
% with Tsim. Creates minimal parameters in the simpar structure and
% fills it with values. If there is already was in there nothing is changed
%
% Usage
%   dataset = TsimIniSimpar(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-01

% Check if there is already some information
if ~isempty(fieldnames(dataset.TSim.sim.simpar))
    return
end

config = TsimConfigGet('parameters');

if isempty(fieldnames(config))
    dataset = initializeFallBackParameters(dataset);
else
    % CleanUp Config for MinSim and EasySpinIncompatibilities
    
    try
        config = TsimCleanUpConfig(config);
        %  Write Cleaned Up config Back
        TsimConfigSet('parameters',config)
        % CreateSimpar from Config
        dataset.TSim.sim.simpar = config.StandardSimulationParameters;
    catch %#ok<CTCH>
        disp(' ')
        disp('(WW) Configuation file corrupted. Fall back to default parameters.')
        dataset = initializeFallBackParameters(dataset);
    end
    
    
end

% Do you have experimental data?
if ~isempty(dataset.data)
    % Write experimental things to simpar
    dataset = trEPRconvertUnits(dataset,'G2mT');
    
    dataset.TSim.sim.simpar.nPoints = length(dataset.axes.data(2).values);
    dataset.TSim.sim.simpar.Range(1) = min(dataset.axes.data(2).values);
    dataset.TSim.sim.simpar.Range(2) = max(dataset.axes.data(2).values);
    dataset.TSim.sim.simpar.mwFreq = dataset.parameters.bridge.MWfrequency.value;
end

dataset = TsimApplyConventions(dataset);


end


function dataset = initializeFallBackParameters(dataset)
% Load Parameters
parameters = TsimParameters;

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

end


