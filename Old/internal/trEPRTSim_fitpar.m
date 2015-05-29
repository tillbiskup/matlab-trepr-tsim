function fitpar = trEPRTSim_fitpar(varargin)
% TREPRTSIM_FITPAR Return definition of fit parameters for simulating
% triplet spectra with trEPRTSim.
%
% Usage
%   fitpar = trEPRTSim_fitpar();
%   fitpar = trEPRTSim_fitpar(<parameter>,<value>);
%
%   fitpar - nx4 cell array OR struct
%            variable name, evaluation string, description, unit for each
%            parameter.
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
% See also TREPRTSIM

% (c) 2013-14, Deborah Meyer, Till Biskup
% 2014-11-14

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addParamValue('struct',logical(false),@islogical);
parser.parse(varargin{:});

fitpar = cell(17,4);

fitpar(1,:)  = {'gx','Sys.g(1)','gx value',''};
fitpar(2,:)  = {'gy','Sys.g(2)','gy value',''};
fitpar(3,:)  = {'gz','Sys.g(3)','gz value',''};
fitpar(4,:)  = {'D','Sys.D(3)*3/2','Zero field splitting parameter D','MHz'};
fitpar(5,:)  = {'E','(Sys.D(1) - Sys.D(2))/2','Zero field splitting parameter E','MHz'};
fitpar(6,:)  = {'p1','Exp.Temperature(1)','Population of level 1',''};
fitpar(7,:)  = {'p2','Exp.Temperature(2)','Population of level 2',''};
fitpar(8,:)  = {'p3','Exp.Temperature(3)','Population of level 3',''};
fitpar(9,:)  = {'scale','','Scaling factor between experiment and fit',''};
fitpar(10,:)  = {'lwGauss','','Overall inhomogeneous linewidth Gaussian','mT'};
fitpar(11,:)  = {'lwLorentz','','Overall homogeneous linewidth Lorentzian','mT'};
fitpar(12,:)  = {'DStrainD','Sys.DStrain(1)','local inhomogenes linewith, D strain','MHz'};
fitpar(13,:)  = {'DStrainE','Sys.DStrain(2)','local inhomogenes linewith, E strain','MHz'};
fitpar(14,:) = {'DeltaB','','Frequency correction via field offset','mT'};
fitpar(15,:) = {'gStrainx','Sys.gStrain(1)','g strain in x direction','MHz'};
fitpar(16,:) = {'gStrainy','Sys.gStrain(2)','g strain in y direction','MHz'};
fitpar(17,:) = {'gStrainz','Sys.gStrain(3)','g strain in z direction','MHz'};
fitpar(18,:) = {'Ordering','Exp.Ordering','Order parameter for partially ordered systems',''};

% If user prefers structs over cell arrays, convert into struct
if parser.Results.struct
    fitparStruct = struct();
    for k=1:length(fitpar)
        fitparStruct.(fitpar{k,1}).evalString = fitpar{k,2};
        fitparStruct.(fitpar{k,1}).description = fitpar{k,3};
        fitparStruct.(fitpar{k,1}).unit = fitpar{k,4};
    end
    fitpar = fitparStruct;
end

end
