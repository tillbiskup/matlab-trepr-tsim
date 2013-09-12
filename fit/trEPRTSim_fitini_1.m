 function [inipar,lb,ub,tofit] = trEPRTSim_fitini_1(answer)
% TREPRTSIM_FITINI_2 Initialize fit parameters for fitting triplet spectra
% with trEPRTSim using menus.
%
% Usage
%   [inipar,lb,ub,tofit] = trEPRTSim_fitini_1(answer);
%
%   answer - struct
%            Users choice what parameters to fit
%   
%   inipar - vector
%            initial values of parameters that shall be fitted
%
%   lb     - vector
%            lower boundaries of corresponding simulation parameters  
%
%   ub     - vector
%            upper boundaries of corresponding simulation parameters
%
%   tofit  - vector
%            boolean values
%
% See also TREPRTSIM

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-09-12


% This function initialises the fit parameters depending on the
% configuration and what parameters the user wants to fit


% Define full set of available fit parameters
conf = trEPRTSim_conf;
fitpar = [...
    conf.Sys.D(3)*3/2 ...
    conf.Sys.D(1)+conf.Sys.D(3)*3/6 ...
    conf.Exp.Temperature ...
    conf.Exp.scale ...
    conf.Sys.lw ...
    conf.Sys.DStrain ...
    conf.Exp.DeltaB ...
    conf.Sys.gStrain ...
    ];

% Corresponding lower and upper boundaries
lb = conf.fitini.lb;
ub = conf.fitini.ub;

% Which parameters to fit
tofit = zeros(length(fitpar));

% Initialisation of the fit-parameters
userchoice = str2double(answer);

for k=1:length(userchoice)
    tofit(userchoice(k))= ones(1);
end

% Convert tofit into boolean values
tofit = logical(tofit);

% Reduce inipar and boundaries to set of parameters that shall be fitted.
inipar = fitpar(tofit);
lb = lb(tofit);
ub = ub(tofit);

 end