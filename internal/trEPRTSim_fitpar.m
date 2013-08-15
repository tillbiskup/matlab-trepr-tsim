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
%            substructs for each parameter with the fields "evalString" and
%            "description".
%
% Optional parameters
%   struct - true/false
%            return struct rather than cell array.
%            Default: FALSE
%
% See also TREPRTSIM

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-15

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addParamValue('struct',logical(false),@islogical);
parser.parse(varargin{:});

fitpar = cell(13,3);

fitpar(1,:)  = {'D','Sys.D(3)*3/2','Zero field splitting parameter'};
fitpar(2,:)  = {'E','Sys.D(1)+Sys.D(2)*3/6','Zero field splitting parameter'};
fitpar(3,:)  = {'pol1','Exp.Temperature(1)','Polarisation (?)'};
fitpar(4,:)  = {'pol2','Exp.Temperature(2)','Polarisation (?)'};
fitpar(5,:)  = {'pol3','Exp.Temperature(3)','Polarisation (?)'};
fitpar(6,:)  = {'scale','','Scaling factor between experiment and fit'};
fitpar(7,:)  = {'lw','','Overall inhomogeneous linewidth'};
fitpar(8,:)  = {'lwD','','D strain'};
fitpar(9,:)  = {'lwE','','E strain'};
fitpar(10,:) = {'DeltaB','','Frequency correction via field offset'};
fitpar(11,:) = {'gStrainx','','g strain in x direction'};
fitpar(12,:) = {'gStrainy','','g strain in y direction'};
fitpar(13,:) = {'gStrainz','','g strain in z direction'};

% If user prefers structs over cell arrays, convert into struct
if parser.Results.struct
    fitparStruct = struct();
    for k=1:length(fitpar)
        fitparStruct.(fitpar{k,1}).evalString = fitpar{k,2};
        fitparStruct.(fitpar{k,1}).description = fitpar{k,3};
    end
    fitpar = fitparStruct;
end

end