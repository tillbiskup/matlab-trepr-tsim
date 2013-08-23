function fitpar = trEPRTSim_fitpar(varargin)
% TREPRTSIM_FITPAR Return definition of fit parameters for simulating
% triplet spectra with trEPRTSim.
%
% Usage
%   fitpar = trEPRTSim_fitpar();
%   fitpar = trEPRTSim_fitpar(<parameter>,<value>);
%
%   fitpar - nx3 cell array OR struct
%            variable name, evaluation string, and description for each
%            parameter 
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
% 2013-08-22

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addParamValue('struct',logical(false),@islogical);
parser.parse(varargin{:});

fitpar = cell(13,4);

fitpar(1,:)  = {'D','Sys.D(3)*3/2','Zero field splitting parameter','MHz'};
fitpar(2,:)  = {'E','Sys.D(1)+Sys.D(2)*3/6','Zero field splitting parameter','MHz'};
fitpar(3,:)  = {'p1','Exp.Temperature(1)','Population of level 1',''};
fitpar(4,:)  = {'p2','Exp.Temperature(2)','Population of level 2',''};
fitpar(5,:)  = {'p3','Exp.Temperature(3)','Population of level 3',''};
fitpar(6,:)  = {'scale','','Scaling factor between experiment and fit',''};
fitpar(7,:)  = {'lw','','Overall inhomogeneous linewidth','mT'};
fitpar(8,:)  = {'DStrainD','','D strain','MHz'};
fitpar(9,:)  = {'DStrainE','','E strain','MHz'};
fitpar(10,:) = {'DeltaB','','Frequency correction via field offset','mT'};
fitpar(11,:) = {'gStrainx','','g strain in x direction','MHz'};
fitpar(12,:) = {'gStrainy','','g strain in y direction','MHz'};
fitpar(13,:) = {'gStrainz','','g strain in z direction','MHz'};

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
