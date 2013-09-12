function dataset = trEPRTSim_fitini(dataset)
% TREPRTSIM_FITINI Initialize fit parameters for fitting triplet spectra
% with trEPRTSim using menus.
%
% Usage
%   dataset = trEPRTSim_fitini(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TREPRTSIM

% (c) 2005, Moritz Kirste
% (c) 2013, Deborah Meyer, Till Biskup
% 2013-09-12


% DOCUMENTATION : 
% This function initialises the fit parameters depending on ...
% It returns the starting parameters in the
% variable par and the boundary conditions in the variables lb and ub. 

% Define full set of available fit parameters
fitpar = trEPRTSim_SysExp2par(dataset.TSim.sim.Sys,dataset.TSim.sim.Exp);

% Corresponding lower and upper boundaries
lb = dataset.TSim.fit.fitini.lb;
ub = dataset.TSim.fit.fitini.ub;

% Which parameters to fit
tofit = dataset.TSim.fit.fitini.tofit;

% Initialisation of the fit-parameters using a menu.
% choice defines how many parameters should be fitted.
% choice == 1 --> lw
% choice == 2 --> lw,DeltaB
% choice == 3 --> lw,DeltaB,gx,gy,gz
% choice == 4 --> lwD,lwE,DeltaB
% choice == 5 --> lwD,lwE,DeltaB,gx,gy,gz
text = sprintf(...
    ['Choose wich parameters should be allowed to be fitted\n'...
    '(D, E and polarisations are default)']);
choice = menu(text,...
    'lw','lw,DeltaB','lw,DeltaB,gx,gy,gz','lwD,lwE,DeltaB',...
    'lwE,lwD,DeltaB,gx,gy,gz'); 


% The starting-parameters wich depend on the choice are initialised.
% inipar,lb and ub can be in the following order
% choice == 1 --> [D E Pol1 Pol2 Pol3 scale lw]
% choice == 2 --> [D E Pol1 Pol2 Pol3 scale lw DeltaB]
% choice == 3 --> [D E Pol1 Pol2 Pol3 scale lw DeltaB gx gy gz]
% choice == 4 --> [D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB]
% choice == 5 --> [D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB gx gy gz]

% concatenation of lw
if (choice == 1)||(choice == 2)||(choice == 3)
    tofit(7) = 1;
end

% concatenation of lwD and lwE
if (choice == 4)||(choice == 5)
    tofit(7) = 0;
    tofit(8:9) = ones(2,1);
end

% concatenation of DeltaB
if (choice == 2)||(choice == 3)||(choice == 4)||(choice == 5)
    tofit(10) = 1;
end

% concatenation of gx,gy,gz
if (choice == 3)||(choice == 5)
    tofit(11:13) = ones(3,1);
end

% Convert tofit into boolean values
tofit = logical(tofit);

% Reduce inipar and boundaries to set of parameters that shall be fitted.
inipar = fitpar(tofit);
lb = lb(tofit);
ub = ub(tofit);

% Displayment of the starting parameters in the order depending on
% choice
disp('The starting parameters are in the following order: ')
switch choice
    case 1
        disp('D E Pol1 Pol2 Pol3 scale lw');
    case 2
        disp('D E Pol1 Pol2 Pol3 scale lw DeltaB');
    case 3
        disp('D E Pol1 Pol2 Pol3 scale lw DeltaB gx gy gz');
    case 4
        disp('D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB');
    case 5
        disp('D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB gx gy gz');
end
disp(inipar);


% Menu for changing the starting parameters, displaying the boundaries, 
% changing the boundaries, and starting the fit.
user_input = 0;
while user_input ~= 4
    text = sprintf('You have the following options');
    user_input = menu(text,...
        'Change starting-parameters',...
        'Display boundary conditions',...
        'Change boundary conditions',...
        'Start fitting');
    
    switch user_input
        case 1
            inipar = input('New starting parameters (as a vector): ');
        case 2
            disp(['Lower boundaries: ',num2str(lb)])
            disp(['Upper boundaries: ',num2str(ub)])
        case 3
            lb = input('Lower boundary (as a vector): ');
            ub = input('upper boundary (as a vector): ');
    end
    
end

% Put parameters back to dataset
dataset.TSim.fit.inipar = inipar;
dataset.TSim.fit.fitini.fitpar = fitpar;
dataset.TSim.fit.fitini.tofit = tofit;
dataset.TSim.fit.fitini.lb = lb;
dataset.TSim.fit.fitini.ub = ub;
