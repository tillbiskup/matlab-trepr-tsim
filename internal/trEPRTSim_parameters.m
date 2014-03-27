function parameters = trEPRTSim_parameters(varargin)
% TREPRTSIM_PARAMETERS Return definition of parameters for simulating and
% fitting triplet spectra with trEPRTSim.
% 
% IS SUPPOSED TO REPALCE TREPRTSIM_SIMPAR AND TREPRTSIM_FITPAR
%
% Usage
%   parameters  = trEPRTSim_parameters();
%   parameters  = trEPRTSim_parameters(<parameter>,<value>);
%
%   parameters  - nx7 cell array OR struct
%                 variable name, evaluation string, description, unit 
%                 for each parameter, whether it is a fitparameter, 
%                 wether it is a simulation parameter and 
%                 wether it is necessary for a simulation.
%
%
%                 If you prefer to get a struct rather than a cell array,
%                 use the optional parameter described below. The struct 
%                 consists of substructs for each parameter with the 
%                 fields "evalString", "description", "unit", "fitpar", 
%                 "simpar", and "minimalsim".
%
% Optional parameters
%   struct - true/false
%            return struct rather than cell array.
%            Default: FALSE
%
% See also TREPRTSIM

% (c) 2013, Deborah Meyer, Till Biskup
% 2014-03-27

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addParamValue('struct',logical(false),@islogical);
parser.parse(varargin{:});

parameters = cell(22,7);

parameters(1,:)  = {'gx','Sys.g(1)','gx value','',true, true, true};
parameters(2,:)  = {'gy','Sys.g(2)','gy value','',true, true, true};
parameters(3,:)  = {'gz','Sys.g(3)','gz value','',true, true, true};
parameters(4,:)  = {'D','Sys.D(3)*3/2','Zero field splitting parameter D','MHz',true, true, true};
parameters(5,:)  = {'E','(Sys.D(1) - Sys.D(2))/2','Zero field splitting parameter E','MHz',true, true, true};
parameters(6,:)  = {'p1','Exp.Temperature(1)','Population of level 1','',true, true, true};
parameters(7,:)  = {'p2','Exp.Temperature(2)','Population of level 2','',true, true, true};
parameters(8,:)  = {'p3','Exp.Temperature(3)','Population of level 3','',true, true, true};
parameters(9,:)  = {'lwGauss','Sys.lw(1)','Overall inhomogeneous linewidth Gaussian (careful when using strains!)','mT', true, true, false};
parameters(10,:) = {'lwLorentz','Sys.lw(2)','Overall homogeneous linewidth Lorentzian (careful when using strains!)','mT', true, true, false};
parameters(11,:) = {'DStrainD','Sys.DStrain(1)','local inhomogeneous linewidth, D strain (don''t use with g strain!)','MHz', true, true, false};
parameters(12,:) = {'DStrainE','Sys.DStrain(2)','local inhomogeneous linewidth, E strain (don''t use with g strain!)','MHz', true, true, false};
parameters(13,:) = {'gStrainx','Sys.gStrain(1)','g strain in x direction (don''t use with D strain!)','MHz', true, true, false};
parameters(14,:) = {'gStrainy','Sys.gStrain(2)','g strain in y direction (don''t use with D strain!)','MHz', true, true, false};
parameters(15,:) = {'gStrainz','Sys.gStrain(3)','g strain in z direction (don''t use with D strain!)','MHz', true, true, false};
parameters(16,:) = {'scale','','Scaling factor between experiment and fit','', true, false, false};
parameters(17,:) = {'DeltaB','','Frequency correction via field offset','mT', true, false, false};
parameters(18,:) = {'mwFreq','Exp.mwFreq','Microwave frequency','GHz',false, true, true};
parameters(19,:) = {'nPoints','Exp.nPoints','Number of points of field axis','',false, true, true};
parameters(20,:) = {'Range','Exp.Range','Lower and upper boundaries of field axis','mT', false, true, true};
parameters(21,:) = {'nKnotsOrientation','Opt.nKnots(1)','Number of orientations in powder between 0 and 90 deg','', false, true, false};
parameters(22,:) = {'nKnotsInterpolation','Opt.nKnots(2)','Refinement factor for interpolation of orientational grid','',false, true, false};

% If user prefers structs over cell arrays, convert into struct
if parser.Results.struct
    fitparStruct = struct();
    for k=1:length(parameters)
        fitparStruct.(parameters{k,1}).evalString = parameters{k,2};
        fitparStruct.(parameters{k,1}).description = parameters{k,3};
        fitparStruct.(parameters{k,1}).unit = parameters{k,4};
        fitparStruct.(parameters{k,1}).fitpar = parameters{k,5};
        fitparStruct.(parameters{k,1}).simpar = parameters{k,6};
        fitparStruct.(parameters{k,1}).minimalsim = parameters{k,7};
    end
    parameters = fitparStruct;
end

end


