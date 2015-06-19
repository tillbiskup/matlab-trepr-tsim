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


routine = dataset.TSim.sim.routine;

config = TsimConfigGet([routine 'parameters']);

if isempty(fieldnames(config))
    dataset = TsimInitializeFallBackParameters(dataset);
     disp(' ')
    disp('Missing configuration... Loaded default values.');
     disp(' ')
else
    % CleanUp Config for MinSim and EasySpinIncompatibilities
    try
        configCleanupRoutine = str2func(commonCamelCase({'TsimCleanUpConfig',routine}));
        config = configCleanupRoutine(config);
        
        TsimConfigSet([routine 'parameters'],config)
        % CreateSimpar from Config
        dataset.TSim.sim.simpar = config.StandardSimulationParameters;
        
    catch %#ok<CTCH>
        disp(' ')
        disp('(WW) Configuation file corrupted. Fall back to default parameters.')
         disp(' ')
        dataset = TsimInitializeFallBackParameters(dataset);
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




