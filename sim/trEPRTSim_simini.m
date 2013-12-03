function dataset = trEPRTSim_simini(dataset)
% TREPRTSIM_SIMINI Initialize sim parameters for simulating triplet spectra
% with trEPRTSim.
%
% Usage
%   dataset = trEPRTSim_simini(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% If none of the additional simulation parameters (that are not necessary
% to perform a simulation) are selected, the Sys and Exp structures are
% cleaned from that parameters.
%
% If combinations of parameters are selected that would lead to errors from
% the simulation function (EasySpin's pepper function for the time being),
% the competing fields are silently removed in the following order: DStrain
% overrides gStrain.
%
% If additional simulation parameters are selected, the default values are
% loaded from the configuration. If only one element of a vector in the
% spin system structure is selected as additional parameter, the values for
% the remaining elements are set to zero (e.g., for 'Dstrain' and
% 'gStrain').
%
% Scaling is set to 1.
%
% Experimental parameters (MW frequency, field range) are written to the
% main parameters section of the dataset in case the dataset contains no
% experimental data.
%
% See also TREPRTSIM

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-10-07
 
% Get values from configuration
conf = trEPRTSim_conf();

if isempty(dataset.TSim.sim.addsimpar)
    % Create minimal Sys structure for simulation
    % In particular, remove competing fields causing trouble with "pepper".
    if isfield(dataset.TSim.sim.Sys,'lw')
        dataset.TSim.sim.Sys = rmfield(dataset.TSim.sim.Sys,'lw');
    end
    if isfield(dataset.TSim.sim.Sys,'DStrain')
        dataset.TSim.sim.Sys = rmfield(dataset.TSim.sim.Sys,'DStrain');
    end
    if isfield(dataset.TSim.sim.Sys,'gStrain')
        dataset.TSim.sim.Sys = rmfield(dataset.TSim.sim.Sys,'gStrain');
    end
end

if any(ismember(dataset.TSim.sim.addsimpar,{'DStrainD','DStrainE'}))
    % Remove competing fields causing trouble with "pepper"
    if isfield(dataset.TSim.sim.Sys,'gStrain')
        dataset.TSim.sim.Sys = rmfield(dataset.TSim.sim.Sys,'gStrain');
    end
    % Remove all unwanted fields from addsimpar
    dataset.TSim.sim.addsimpar(ismember(dataset.TSim.sim.addsimpar,...
        {'gStrainx','gStrainy','gStrainz'})) = [];
end

if any(ismember(dataset.TSim.sim.addsimpar,{'gStrainx','gStrainy','gStrainz'}))
    % Remove competing fields causing trouble with "pepper"
    if isfield(dataset.TSim.sim.Sys,'DStrain')
        dataset.TSim.sim.Sys = rmfield(dataset.TSim.sim.Sys,'DStrain');
    end
    % Remove all unwanted fields from addsimpar
    dataset.TSim.sim.addsimpar(ismember(dataset.TSim.sim.addsimpar,...
        {'DStrainD','DStrainE'})) = [];
end

if any(ismember(dataset.TSim.sim.addsimpar,{'lw'}))
    % Add field to Sys, if not there, and fill with values from config
    dataset.TSim.sim.Sys.lw = conf.Sys.lw;
end

if any(ismember(dataset.TSim.sim.addsimpar,{'DStrainD','DStrainE'}))
    % Add field to Sys, if not there, and fill with values from config
    if ~isfield(dataset.TSim.sim.Sys,'DStrain')
        dataset.TSim.sim.Sys.DStrain = conf.Sys.DStrain;
    end
    % Set not selected parameters to zero
    if ~ismember(dataset.TSim.sim.addsimpar,{'DStrainD'})
        dataset.TSim.sim.Sys.DStrain(1) = 0;
    end
    if ~ismember(dataset.TSim.sim.addsimpar,{'DStrainE'})
        dataset.TSim.sim.Sys.DStrain(2) = 0;
    end
end

if any(ismember(dataset.TSim.sim.addsimpar,{'gStrainx','gStrainy','gStrainz'}))
    if ~isfield(dataset.TSim.sim.Sys,'gStrain')
        dataset.TSim.sim.Sys.gStrain = conf.Sys.gStrain;
    end
    % Set not selected parameters to zero
    if ~ismember(dataset.TSim.sim.addsimpar,{'gStrainx'})
        dataset.TSim.sim.Sys.gStrain(1) = 0;
    end
    if ~ismember(dataset.TSim.sim.addsimpar,{'gStrainy'})
        dataset.TSim.sim.Sys.gStrain(2) = 0;
    end
    if ~ismember(dataset.TSim.sim.addsimpar,{'gStrainz'})
        dataset.TSim.sim.Sys.gStrain(3) = 0;
    end
end

% Set scale to 1
% dataset.TSim.sim.Exp.scale = 1;

% Write fields in trEPR datastructure using simulation parameters - but
% only if dataset contains no experimental data.
if isempty(dataset.data)
    % magnetic field
    dataset.axes.y.values = linspace(...
        dataset.TSim.sim.Exp.Range(1),...
        dataset.TSim.sim.Exp.Range(2),...
        dataset.TSim.sim.Exp.nPoints ...
        );
    dataset.axes.y.unit = 'mT';
    % Microwave frequency
    dataset.parameters.bridge.MWfrequency.value = dataset.TSim.sim.Exp.mwFreq;
    dataset.parameters.bridge.MWfrequency.unit = 'GHz';
end

end