function [par,lb,ub] = trEPRTSim_fitini()
% TREPRTSIM_FITINI Initialize fit parameters for fitting triplet spectra
% with trEPRTSim using menus.
%
% Usage
%   [par,lb,ub] = trEPRTSim_fitini();
%
%   par   - vector
%           simulation parameters
%
%   lb    - vector
%           lower boundaries of corresponding simulation parameters  
%
%   ub    - vector
%           upper boundaries of corresponding simulation parameters 
%
% See also TREPRTSIM

% (c) 2005, Moritz Kirste
% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-06


% DOCUMENTATION : 
% This function initialises the fit parameters depending on the variable
% inifactor wich can be chosen. It returns the starting parameters in the
% variable par and the boundary conditions in the variables lb and ub. 

% inifactor defines the parameters to be fitted. 
global inifactor

% Initialisation of the fit-parameters using a menu.
% inifactor defines how many parameters should be fitted.
% inifactor == 1 --> lw
% inifactor == 2 --> lw,DeltaB
% inifactor == 3 --> lw,DeltaB,gx,gy,gz
% inifactor == 4 --> lwD,lwE,DeltaB
% inifactor == 5 --> lwD,lwE,DeltaB,gx,gy,gz
text = sprintf(...
    ['Choose wich parameters should be allowed to be fitted\n'...
    '(D, E and polarisations are default)']);
inifactor = menu(text,...
    'lw','lw,DeltaB','lw,DeltaB,gx,gy,gz','lwD,lwE,DeltaB',...
    'lwE,lwD,DeltaB,gx,gy,gz'); 

% These parameters are always needed and don't depend on the chosen
% inifactor
D = 1.6   ;                     % in GHz
E = 0.5;                        % in GHz
Pol1 = 0.003  ;                 % polarisation1
Pol2 = 0.4 ;                    % polarisation2
Pol3 = 0.5 ;                    % polarisation3
scale = 0.003;                  % scaling


par = [D E Pol1 Pol2 Pol3 scale]; % initialisation
lb = [1.5 0.3 0 0 0 0];             % lower boundaries
ub = [2   1   1 1 1 1];             % upper boundaries


% The starting-parameters wich depend on the inifactor are initialised.
% Therefore the variables par,lb and ub are changed by
% concatenation.
% par,lb and ub can be in the following order
% inifactor == 1 --> [D E Pol1 Pol2 Pol3 scale lw]
% inifactor == 2 --> [D E Pol1 Pol2 Pol3 scale lw DeltaB]
% inifactor == 3 --> [D E Pol1 Pol2 Pol3 scale lw DeltaB gx gy gz]
% inifactor == 4 --> [D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB]
% inifactor == 5 --> [D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB gx gy gz]

% concatenation of lw
if (inifactor == 1)||(inifactor == 2)||(inifactor == 3)
    lw = 3.0;                       % linewith in mTesla 
    
    par = [par lw];             % initialisation
    lb = [lb 1];                    % lower boundaries
    ub = [ub 4];                    % upper boundaries
end

% concatenation of lwD and lwE
if (inifactor == 4)||(inifactor == 5)
    lwD = 80.0;                     % linewith of D    
    lwE = 70.0;                     % linewith of E 
       
    par = [par lwD lwE];        % initialization
    lb = [lb 1   1];                % lower boundaries
    ub = [ub 100 100];              % upper boundaries
end

% concatenation of DeltaB
if (inifactor == 2)||(inifactor == 3)||(inifactor == 4)||(inifactor == 5)
    DeltaB = 0;                     % DeltaB in Gauss
    
    par = [par DeltaB];         % initialisation
    lb = [lb -30];                  % lower boundaries
    ub = [ub 30];                   % upper boundaries
end

% concatenation of gx,gy,gz
if (inifactor == 3)||(inifactor == 5)
    gx = 0.00001;                   % gStain in x
    gy = 0.00001;                   % gStain in y
    gz = 0.00001;                   % gStain in z
           
    par = [par gx gy gz];                   % initialisation
    lb = [lb 0.00000001 0.00000001 0.00000001]; % lower boundaries
    ub = [ub 0.001 0.001 0.001];                % upper boundaries
end


% Displayment of the starting-parameters in the order depending on
% inifactor
disp('The starting parameters are in the following order :')
switch inifactor
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
disp(par);


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
            par = input('New starting parameters (as a vector): ');
        case 2
            disp(['Lower boundaries: ',num2str(lb)])
            disp(['Upper boundaries: ',num2str(ub)])
        case 3
            lb = input('Lower boundary (as a vector): ');
            ub = input('upper boundary (as a vector): ');
    end
    
end
