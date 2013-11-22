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

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-11-22

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addParamValue('struct',logical(false),@islogical);
parser.parse(varargin{:});

fitpar = cell(13,4);

fitpar(1,:)  = {'D','Sys.D(3)*3/2','Zero field splitting parameter D','MHz'};
fitpar(2,:)  = {'E','Sys.D(1)+Sys.D(2)*3/6','Zero field splitting parameter E','MHz'};
fitpar(3,:)  = {'p1','Exp.Temperature(1)','Population of level 1',''};
fitpar(4,:)  = {'p2','Exp.Temperature(2)','Population of level 2',''};
fitpar(5,:)  = {'p3','Exp.Temperature(3)','Population of level 3',''};
fitpar(6,:)  = {'scale','','Scaling factor between experiment and fit',''};
fitpar(7,:)  = {'lwGauss','','Overall inhomogeneous linewidth Gaussian','mT'};
fitpar(8,:)  = {'lwLorentz','','Overall inhomogeneous linewidth Lorentzian','mT'};
fitpar(9,:)  = {'DStrainD','Sys.DStrain(1)','D strain','MHz'};
fitpar(10,:)  = {'DStrainE','Sys.DStrain(2)','E strain','MHz'};
fitpar(11,:) = {'DeltaB','','Frequency correction via field offset','mT'};
fitpar(12,:) = {'gStrainx','Sys.gStrain(1)','g strain in x direction','MHz'};
fitpar(13,:) = {'gStrainy','Sys.gStrain(2)','g strain in y direction','MHz'};
fitpar(14,:) = {'gStrainz','Sys.gStrain(3)','g strain in z direction','MHz'};

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
