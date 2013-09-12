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

% (c) 2005, Moritz Kirste
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

k = 1;
while k <= length(userchoice)
tofit(userchoice(k))= ones(1);
k = k+1;
end

% Convert tofit into boolean values
tofit = logical(tofit);

% Reduce inipar and boundaries to set of parameters that shall be fitted.
inipar = fitpar(tofit);
lb = lb(tofit);
ub = ub(tofit);

% % Displayment of the starting parameters in the order depending on
% % choice
% disp('The starting parameters are in the following order: ')
% switch choice
%     case 1
%         disp('D E Pol1 Pol2 Pol3 scale lw');
%     case 2
%         disp('D E Pol1 Pol2 Pol3 scale lw DeltaB');
%     case 3
%         disp('D E Pol1 Pol2 Pol3 scale lw DeltaB gx gy gz');
%     case 4
%         disp('D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB');
%     case 5
%         disp('D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB gx gy gz');
% end
% disp(inipar);
% 
% 
% % Menu for changing the starting parameters, displaying the boundaries, 
% % changing the boundaries, and starting the fit.
% user_input = 0;
% while user_input ~= 4
%     text = sprintf('You have the following options');
%     user_input = menu(text,...
%         'Change starting-parameters',...
%         'Display boundary conditions',...
%         'Change boundary conditions',...
%         'Start fitting');
%     
%     switch user_input
%         case 1
%             inipar = input('New starting parameters (as a vector): ');
%         case 2
%             disp(['Lower boundaries: ',num2str(lb)])
%             disp(['Upper boundaries: ',num2str(ub)])
%         case 3
%             lb = input('Lower boundary (as a vector): ');
%             ub = input('upper boundary (as a vector): ');
%     end
%     
% end
 end