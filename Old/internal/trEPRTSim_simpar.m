function simpar = trEPRTSim_simpar(varargin)
% TREPRTSIM_SIMPAR Return definition of fit parameters for simulating
% triplet spectra with trEPRTSim.
%
% Usage
%   simpar = trEPRTSim_simpar();
%   simpar = trEPRTSim_simpar(<parameter>,<value>);
%
%   simpar - nx5 cell array OR struct
%            variable name, evaluation string, description, unit for each
%            parameter, and whether it is necessary for a simulation.
%
%            If you prefer to get a struct rather than a cell array, use
%            the optional parameter described below. The struct consists of
%            substructs for each parameter with the fields "evalString",
%            "description", and "unit".
%
% Optional parameters
%   struct - true/false
%            return struct rather than cell array.
%            Default: FALSE
%
% See also TREPRTSIM, TREPRTSIM_FITPAR

% (c) 2013-14, Deborah Meyer, Till Biskup
% 2014-11-14

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addParamValue('struct',logical(false),@islogical);
parser.parse(varargin{:});

simpar = cell(21,5);

simpar(1,:)  = {'gx','Sys.g(1)','gx value','',true};
simpar(2,:)  = {'gy','Sys.g(2)','gy value','',true};
simpar(3,:)  = {'gz','Sys.g(3)','gz value','',true};
simpar(4,:)  = {'D','Sys.D(3)*3/2','Zero field splitting parameter D','MHz',true};
simpar(5,:)  = {'E','(Sys.D(1)-Sys.D(2))/2','Zero field splitting parameter E','MHz',true};
simpar(6,:)  = {'mwFreq','Exp.mwFreq','Microwave frequency','GHz',true};
simpar(7,:)  = {'nPoints','Exp.nPoints','Number of points of field axis','',true};
simpar(8,:)  = {'Range','Exp.Range','Lower and upper boundaries of field axis','mT',true};
simpar(9,:)  = {'p1','Exp.Temperature(1)','Population of level 1','',true};
simpar(10,:) = {'p2','Exp.Temperature(2)','Population of level 2','',true};
simpar(11,:) = {'p3','Exp.Temperature(3)','Population of level 3','',true};
simpar(12,:) = {'lwGauss','Sys.lw(1)','Overall inhomogeneous linewidth Gaussian (careful when using strains!)','mT',false};
simpar(13,:) = {'lwLorentz','Sys.lw(2)','Overall homogeneous linewidth Lorentzian (careful when using strains!)','mT',false};
simpar(14,:) = {'DStrainD','Sys.DStrain(1)','local inhomogenous linewidth, D strain (don''t use with g strain!)','MHz',false};
simpar(15,:) = {'DStrainE','Sys.DStrain(2)','local inhomogenous linewidth, E strain (don''t use with g strain!)','MHz',false};
simpar(16,:) = {'gStrainx','Sys.gStrain(1)','g strain in x direction (don''t use with D strain!)','MHz',false};
simpar(17,:) = {'gStrainy','Sys.gStrain(2)','g strain in y direction (don''t use with D strain!)','MHz',false};
simpar(18,:) = {'gStrainz','Sys.gStrain(3)','g strain in z direction (don''t use with D strain!)','MHz',false};
simpar(19,:) = {'nKnotsOrientation','Opt.nKnots(1)','Number of orientations in powder between 0 and 90 deg','',false};
simpar(20,:) = {'nKnotsInterpolation','Opt.nKnots(2)','Refinement factor for interpolation of orientational grid','',false};
simpar(21,:) = {'Ordering','Exp.Ordering','Ordering parameter for partially ordered systems','',false};

% If user prefers structs over cell arrays, convert into struct
if parser.Results.struct
    simparStruct = struct();
    for k=1:length(simpar)
        simparStruct.(simpar{k,1}).evalString = simpar{k,2};
        simparStruct.(simpar{k,1}).description = simpar{k,3};
        simparStruct.(simpar{k,1}).unit = simpar{k,4};
    end
    simpar = simparStruct;
end

end
