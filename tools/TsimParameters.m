function parameters = TsimParameters(varargin)
% TSIMPARAMETERS Return definition of parameters for simulating and
% fitting triplet spectra with Tsim.
% 
% Usage
%   parameters  = TsimParameters();
%   parameters  = TsimParameters(<parameter>,<value>);
%
%   parameters  - nx13 cell array OR struct
%                 variable name, evaluation string, description, unit 
%                 for each parameter, whether it is a fitparameter, 
%                 wether it is a simulation parameter, 
%                 wether it is necessary for a simulation, if it is a 
%                 fitoption parameter, wether the 
%                 user can change its value, a standardvalue, a inforamtion
%                 about conversion, information about incompatibilities
%                 with other parameters and the program name for which you
%                 can use the parameter
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

% Copyright (c) 2013-16, Deborah Meyer, Till Biskup
% 2016-01-26

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addParamValue('struct',logical(false),@islogical);
parser.parse(varargin{:});

parameters = cell(31,13);
                                                    
%                                                 5      6     7        8         9            10              11               12                 13                    
%                     1    2          3      4 fitpar simpar minsim fitoptpar  useraccess   standardvalue   needsconversion   notBeUsedWith(cell)  programmname       
parameters(1,:)  = {'gx','Sys.g(1)','gx value','',true, true, true, false, true, 2.002, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(2,:)  = {'gy','Sys.g(2)','gy value','',true, true, true, false, true, 2.002, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(3,:)  = {'gz','Sys.g(3)','gz value','',true, true, true, false, true, 2.002, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(4,:)  = {'D','Sys.D(3)*3/2','Zero field splitting parameter D','MHz',true, true, true, false, true, 500, true, {}, {'pepper', 'tango', 'bachata'}};
parameters(5,:)  = {'E','(Sys.D(1) - Sys.D(2))/2','Zero field splitting parameter E','MHz',true, true, true, false, true, 40, true, {}, {'pepper', 'tango', 'bachata'}};
parameters(6,:)  = {'p1','Exp.Temperature(1)','Population of level 1','',true, true, true, false, true, 0.35, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(7,:)  = {'p2','Exp.Temperature(2)','Population of level 2','',true, true, true, false, true, 0.4, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(8,:)  = {'p3','Exp.Temperature(3)','Population of level 3','',true, true, true, false, true, 0.25, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(9,:)  = {'lwGauss','Sys.lw(1)','Overall inhomogeneous linewidth Gaussian (FWHM)','mT', true, true, true, false, true, 2, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(10,:) = {'lwLorentz','Sys.lw(2)','Overall homogeneous linewidth Lorentzian (FWHM)','mT', true, true, true, false, true, 2, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(11,:) = {'DStrainD','Sys.DStrain(1)','local inhomogeneous linewidth, D strain (don''t use with g strain!)','MHz', true, true, false, false, true, 40, false, {'gStrainx', 'gStrainy', 'gStrainz','Ordering'}, {'pepper'}};
parameters(12,:) = {'DStrainE','Sys.DStrain(2)','local inhomogeneous linewidth, E strain (don''t use with g strain!)','MHz', true, true, false, false, true, 10, false, {'gStrainx', 'gStrainy', 'gStrainz','Ordering'}, {'pepper'}};
parameters(13,:) = {'gStrainx','Sys.gStrain(1)','g strain in x direction (don''t use with D strain!)','MHz', true, true, false, false, true, 0.005, false, {'DStrainD','DStrainE','Ordering'}, {'pepper'}};
parameters(14,:) = {'gStrainy','Sys.gStrain(2)','g strain in y direction (don''t use with D strain!)','MHz', true, true, false, false, true, 0.005, false, {'DStrainD','DStrainE','Ordering'}, {'pepper'}};
parameters(15,:) = {'gStrainz','Sys.gStrain(3)','g strain in z direction (don''t use with D strain!)','MHz', true, true, false, false, true, 0.005, false, {'DStrainD','DStrainE','Ordering'}, {'pepper'}};
parameters(16,:) = {'DeltaB','','Field offset','mT', true, true, false, false, true, 0, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(17,:) = {'mwFreq','Exp.mwFreq','Microwave frequency','GHz',false, true, true, false, true, 9.7, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(18,:) = {'nPoints','Exp.nPoints','Number of points of field axis','',false, true, true, false, true, 326, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(19,:) = {'Range','Exp.Range','Lower and upper boundaries of field axis','mT', false, true, true, false, true, [280 410], false, {}, {'pepper', 'tango', 'bachata'}};
parameters(20,:) = {'nKnotsOrientation','Opt.nKnots(1)','Number of orientations in powder between 0 and 90 deg','', false, true, false, false, false, 40, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(21,:) = {'nKnotsInterpolation','Opt.nKnots(2)','Refinement factor for interpolation of orientational grid','',false, true, false, false, false, 3, false, {}, {'pepper'}};
parameters(22,:) = {'Ordering','Exp.Ordering','Order parameter for partially ordered systems (don''t use with D or g strains!)','',true, true, false, false, true, 0.1, false, {'gStrainx', 'gStrainy', 'gStrainz','DStrainD','DStrainE','Sigma','Theta'}, {'pepper'}};
parameters(23,:) = {'Harmonic','Exp.Harmonic','Harmonic of detection','',false, true, true, false, false, 0, false, {}, {'pepper','tango', 'bachata'}};
parameters(24,:) = {'Spinsystem','Sys.S','Spinsystem','',false, true, true, false, false, 1, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(25,:) = {'MaximumIteration','MaxIter','Maximum number of iteration','', false, false, false, true, true, 100, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(26,:) = {'MaximumFunctionEvaluation','MaxFunEval','Maximum number of function evaluation','', false, false, false, true, true, 1000, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(27,:) = {'TerminationTolerance','TolFun','Termination tolerance of algorithm','', false, false, false, true, true, 1e-10, false, {}, {'pepper', 'tango', 'bachata'}};
parameters(28,:) = {'Phi','Opt.phi','azimut angel phi for powder averaging','rad', true, true, false, false, true, 0, false, {}, {'tango'}};
parameters(29,:) = {'Theta','Opt.theta','polar angel theta for powder averaging','rad', true, true, false, false, true, 0, false, {}, {'tango', 'bachata'}};
parameters(30,:) = {'Sigma','Opt.sigma','Full Width at Half Maximum of gaussian in powder averaging','rad', true, true, false, false, true, 0, false, {}, {'tango', 'bachata'}};
parameters(31,:) = {'InterpolB0','Opt.InterpolB0','Interpolation of magnetic field (spline or none)','', false, true, true, false, true, 'none', false, {}, {'tango'}};
%parameters(32,:) = {'InterpolPowder','Opt.InterpolPowder','Interpolation in powder average','', false, true, true, false, true, 'none', false, {}, {'tango'}};
%parameters(32,:) = {'Phi','Opt.function.phi','azimut angel phi for powder averaging','degree', true, true, false, false, true, 0, false, {}, {'tango'}};
%parameters(32,:) = {'Theta','Opt.function.theta','polar angel theta for powder averaging','degree', true, true, false, false, true, 0, false, {'Ordering'}, {'pepper'}};
%parameters(33,:) = {'Sigma','Opt.function.sigma','Full Width at Half Maximum of gaussian in powder averaging','degree', true, true, false, false, true, 0, false, {'Ordering'}, {'pepper'}};
%parameters(34,:) = {'Symmetry','Opt.Symmetry','Symmetry of Hamiltonian','',false, true, false, false, true, 'Ci', false, {}, {'pepper'}};



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
        fitparStruct.(parameters{k,1}).programname = parameters{k,13};
    end
        
    parameters = fitparStruct;

end

end


