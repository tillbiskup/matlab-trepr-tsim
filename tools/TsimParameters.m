function parameters = TsimParameters(varargin)
% TSIMPARAMETERS Return definition of parameters for simulating and
% fitting triplet spectra with Tsim.
% 
% Usage
%   parameters  = TsimParameters();
%   parameters  = TsimParameters(<parameter>,<value>);
%
%   parameters  - nx8 cell array OR struct
%                 variable name, evaluation string, description, unit 
%                 for each parameter, whether it is a fitparameter, 
%                 wether it is a simulation parameter, 
%                 wether it is necessary for a simulation and wether the 
%                 user can change its value.
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
% See also TSIM

% Copyright (c) 2013-15, Deborah Meyer, Till Biskup
% 2015-06-01

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addParamValue('struct',logical(false),@islogical);
parser.parse(varargin{:});

parameters = cell(27,12);
                                                    
%                                                 5      6     7        8         9            10              11               12                                     
%                     1    2          3      4 fitpar simpar minsim fitoptpar  useraccess   standardvalue   needsconversion   notBeUsedWith(cell)         
parameters(1,:)  = {'gx','Sys.g(1)','gx value','',true, true, true, false, true, 2.002, false, {}};
parameters(2,:)  = {'gy','Sys.g(2)','gy value','',true, true, true, false, true, 2.002, false, {}};
parameters(3,:)  = {'gz','Sys.g(3)','gz value','',true, true, true, false, true, 2.002, false, {}};
parameters(4,:)  = {'D','Sys.D(3)*3/2','Zero field splitting parameter D','MHz',true, true, true, false, true, 500, true, {}};
parameters(5,:)  = {'E','(Sys.D(1) - Sys.D(2))/2','Zero field splitting parameter E','MHz',true, true, true, false, true, 40, true, {}};
parameters(6,:)  = {'p1','Exp.Temperature(1)','Population of level 1','',true, true, true, false, true, 0.35, false, {}};
parameters(7,:)  = {'p2','Exp.Temperature(2)','Population of level 2','',true, true, true, false, true, 0.4, false, {}};
parameters(8,:)  = {'p3','Exp.Temperature(3)','Population of level 3','',true, true, true, false, true, 0.25, false, {}};
parameters(9,:)  = {'lwGauss','Sys.lw(1)','Overall inhomogeneous linewidth Gaussian (careful when using strains!)','mT', true, true, false, false, true, 2, false, {}};
parameters(10,:) = {'lwLorentz','Sys.lw(2)','Overall homogeneous linewidth Lorentzian (careful when using strains!)','mT', true, true, false, false, true, 2, false, {}};
parameters(11,:) = {'DStrainD','Sys.DStrain(1)','local inhomogeneous linewidth, D strain (don''t use with g strain!)','MHz', true, true, false, false, true, 40, false, {'gStrainx', 'gStrainy', 'gStrainz','Ordering'}};
parameters(12,:) = {'DStrainE','Sys.DStrain(2)','local inhomogeneous linewidth, E strain (don''t use with g strain!)','MHz', true, true, false, false, true, 10, false, {'gStrainx', 'gStrainy', 'gStrainz','Ordering'}};
parameters(13,:) = {'gStrainx','Sys.gStrain(1)','g strain in x direction (don''t use with D strain!)','MHz', true, true, false, false, true, 0.005, false, {'DStrainD','DStrainE','Ordering'}};
parameters(14,:) = {'gStrainy','Sys.gStrain(2)','g strain in y direction (don''t use with D strain!)','MHz', true, true, false, false, true, 0.005, false, {'DStrainD','DStrainE','Ordering'}};
parameters(15,:) = {'gStrainz','Sys.gStrain(3)','g strain in z direction (don''t use with D strain!)','MHz', true, true, false, false, true, 0.005, false, {'DStrainD','DStrainE','Ordering'}};
parameters(16,:) = {'DeltaB','','Frequency correction via field offset','mT', true, false, false, false, true, 0, false, {}};
parameters(17,:) = {'mwFreq','Exp.mwFreq','Microwave frequency','GHz',false, true, true, false, true, 9.7, false, {}};
parameters(18,:) = {'nPoints','Exp.nPoints','Number of points of field axis','',false, true, true, false, true, 326, false, {}};
parameters(19,:) = {'Range','Exp.Range','Lower and upper boundaries of field axis','mT', false, true, true, false, true, [280 410], false, {}};
parameters(20,:) = {'nKnotsOrientation','Opt.nKnots(1)','Number of orientations in powder between 0 and 90 deg','', false, true, false, false, true, 31, false, {}};
parameters(21,:) = {'nKnotsInterpolation','Opt.nKnots(2)','Refinement factor for interpolation of orientational grid','',false, true, false, false, true, 0, false, {}};
parameters(22,:) = {'Ordering','Exp.Ordering','Order parameter for partially ordered systems (don''t use with D or g strains!)','',false, true, false, false, true, 0.1, false, {'gStrainx', 'gStrainy', 'gStrainz','DStrainD','DStrainE'}};
parameters(23,:) = {'Harmonic','Exp.Harmonic','Harmonic of detection','',false, true, true, false, false, 0, false, {}};
parameters(24,:) = {'Spinsystem','Sys.S','Spinsystem','',false, true, true, false, false, 1, false, {}};
parameters(25,:) = {'MaximumIteration','MaxIter','Maximum number of iteration','', false, false, false, true, true, 100, false, {}};
parameters(26,:) = {'MaximumFunctionEvaluation','MaxFunEval','Maximum number of function evaluation','', false, false, false, true, true, 1000, false, {}};
parameters(27,:) = {'TerminationTolerance','TolFun','Termination tolerance of algorithm','', false, false, false, true, true, 1e-10, false, {}};

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
        fitparStruct.(parameters{k,1}).fitoptpar = parameters{k,8};
        fitparStruct.(parameters{k,1}).useraccess = parameters{k,9};
        fitparStruct.(parameters{k,1}).standardvalue = parameters{k,10};
        fitparStruct.(parameters{k,1}).conversion = parameters{k,11};
        fitparStruct.(parameters{k,1}).notUseWith = parameters{k,12};
    end
        
    parameters = fitparStruct;

end

end


