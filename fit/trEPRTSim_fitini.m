function [fitin,lb,ub] = trEPRTSim_fitini()
% TREPRTSIM_FITINI Initialize fit parameters for fitting triplet spectra
% with trEPRTSim.
%
% Usage
%   [fitin,lb,ub] = trEPRTSim_fitini();
%
%   fitin   - ?
%
%   lb      - ?
%
%   ub      - ?
%
% See also TREPRTSIM

% (c) 2005, Moritz Kirste
% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-06

%   This file uses EasySpin written and maintained by the EPR group at the
%   ETH Zuerich. 
%   Contact : easyspin@esr.phys.chem.ethz.ch 
%   EasySpin is freely dowloadable at <http://www.easyspin.ethz.ch/>
%   <quotation source="http://www.easyspin.ethz.ch/">
%   "EasySpin is a Matlab toolbox for solving problems in Electron Paramagnetic 
%   Resonance (EPR) spectroscopy. 
%   License:
%   You may download and work with EasySpin free of charge and without any
%   restrictions. You may copy and distribute verbatim copies of EasySpin.
%   You may not use or modify EasySpin or a part of it for other software
%   which is not freely available at no cost. You may not reverse engineer
%   or disassemble EasySpin. EasySpin comes without warranty of any kind. 
%   If you use results obtained with EasySpin in any scientific
%   publication, cite the appropriate articles. "
%   </quotation>



% DOCUMENTATION : 
% This function is initializing the fit-parameter depending on the variable
% inifactor wich can be chosen. It also allows to change the starting
% parameter or the boundaries. First it provides a menu in wich the user is
% asked to deside which parameters should be fitted. The user can fit the
% linewith lw or lw and the correction of the false measurement of the
% magnetic-field DeltaB or lw and DeltaB and the unisotropy of the gvector
% gx gy gz, or the linewith of the zerofield-splitting lwD and lwE and
% DeltaB or lwE and lwD and DeltaB and gx,gy,gz. It returns the
% starting-paramters  in the variable fitin, the boundary-conditions in the
% variables lb and ub 



% Sys and Exp are needed by EasySpin, spectrum is the measured signal and
% inifactor defines which parameters should be fittet. All these parameters
% are needed by some of the sub-functions and are therefore global
global Sys
global Exp
global spectrum
global inifactor

% Initialization of the fit-parameters using a menu the variable inifactor
% defines how many parameters should be fitted
% inifactor == 1 --> lw
% inifactor == 2 --> lw,DeltaB
% inifactor == 3 --> lw,DeltaB,gx,gy,gz
% inifactor == 4 --> lwD,lwE,DeltaB
% inifactor == 5 --> lwD,lwE,DeltaB,gx,gy,gz
text = sprintf('Choose wich parameters should be allowed to be fitted \n(D, E and polarisations are default)');
inifactor = menu(text,'lw','lw,DeltaB','lw,DeltaB,gx,gy,gz','lwD,lwE,DeltaB','lwE,lwD,DeltaB,gx,gy,gz'); 

% These parameters are always needed and don't depend on the chosen
% inifactor
D = 1.6   ;                     % in GHz
E = 0.5;                        % in GHz
Pol1 = 0.003  ;                 % polarisation1
Pol2 = 0.4 ;                    % polarisation2
Pol3 = 0.5 ;                    % polarisation3
scale = 0.003;                  % scaling


fitin = [D E Pol1 Pol2 Pol3 scale]; % initialisation
lb = [1.5 0.3 0 0 0 0];             % lower boundaries (see lsqcurvefit documentation)
ub = [2   1   1 1 1 1];             % upper boundaries (see lsqcurvefit documentation)


% The starting-parameters wich depend on the inifactor are initialised in
% the following subfunction <transient_para_initial>(see bottom of the
% file). Thereto the variables fitin,lb and ub are changed by
% concatination.
% fitin,lb and ub can be in the following order
% inifactor == 1 --> [D E Pol1 Pol2 Pol3 scale lw]
% inifactor == 2 --> [D E Pol1 Pol2 Pol3 scale lw DeltaB]
% inifactor == 3 --> [D E Pol1 Pol2 Pol3 scale lw DeltaB gx gy gz]
% inifactor == 4 --> [D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB]
% inifactor == 5 --> [D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB gx gy gz]
[fitin,lb,ub] = transient_para_initial(fitin,lb,ub);


% Displayment of the starting-parameters in the order dependding on
% inifactor
disp('The starting-parameters are in the following order :')
if (inifactor == 1) 
    disp('D E Pol1 Pol2 Pol3 scale lw')
end
if (inifactor == 2) 
    disp('D E Pol1 Pol2 Pol3 scale lw DeltaB') 
end
if (inifactor == 3)
    disp('D E Pol1 Pol2 Pol3 scale lw DeltaB gx gy gz')      
end
if (inifactor == 4)
    disp('D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB')          
end
if (inifactor == 5) 
    disp('D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB gx gy gz') 
end
disp(fitin)


% This menu inclosed in a while-loop allows to change the
% starting-parameter, to display the boundaries, to change the boundaries
% or to start the fit. The decision is saved in the variable user_input. If
% user_input==4 the while-loop around the menu is stopped
user_input = 0;
while user_input ~= 4
    text = sprintf('You have the following options');
    user_input = menu(text,'Change starting-parameters','Display boundary conditions','Change boundary conditions','Start fitting'); % using a menu
    
    
    % CHANGE PARAMETERS == 1
    if user_input == 1
        fitin = input('New starting-parameters (as a vector): ');
    end
    
    
    % DISPLAY BOUNDARIES == 2
    if user_input == 2
        disp(['Lower boundaries: ',num2str(lb)])
        disp(['Upper boundaries: ',num2str(ub)])
    end
    
    
    % CHANGE BOUNDARIES == 3
    if user_input == 3
        lb = input('Lower boundary (as a vector): ');
        ub = input('upper boundary (as a vector): '); 
    end
    
    
    % START FITTING == 4
    % the while-loop is stoppen
    
end



% SUB-FUNCTION
function [fitin,lb,ub] = transient_para_initial(fitin,lb,ub)
% This sub-function defines the other starting-parameters depending on the
% chosen inifactor. Therefor it takes the variable fitin,lb and ub and
% concats those parameters resp. those boundaries wich are selected by the
% inifactor. fitin,lb and ub can therefore be in the following order
% inifactor == 1 --> [D E Pol1 Pol2 Pol3 scale lw]
% inifactor == 2 --> [D E Pol1 Pol2 Pol3 scale lw DeltaB]
% inifactor == 3 --> [D E Pol1 Pol2 Pol3 scale lw DeltaB gx gy gz]
% inifactor == 4 --> [D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB]
% inifactor == 5 --> [D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB gx gy gz]


global inifactor


% CONCATINATION OF lw
if (inifactor == 1)||(inifactor == 2)||(inifactor == 3)
    lw = 3.0;                       % linewith in mTesla 
    
    fitin = [fitin lw];             % initialisation
    lb = [lb 1];                    % lower boundaries
    ub = [ub 4];                    % upper boundaries
end


% CONCATINATION OF lwD and lwE
if (inifactor == 4)||(inifactor == 5)
    lwD = 80.0;                     % linewith of D    
    lwE = 70.0;                     % linewith of E 
       
    fitin = [fitin lwD lwE];        % initialization
    lb = [lb 1   1];                % lower boundaries
    ub = [ub 100 100];              % upper boundaries
end


% CONCATINATION OF DeltaB
if (inifactor == 2)||(inifactor == 3)||(inifactor == 4)||(inifactor == 5)
    DeltaB = 0;                     % DeltaB in Gauss
    
    fitin = [fitin DeltaB];         % initialisation
    lb = [lb -30];                  % lower boundaries
    ub = [ub 30];                   % upper boundaries
end


% CONCATINATION OF gx,gy,gz
if (inifactor == 3)||(inifactor == 5)
    gx = 0.00001;                   % gStain in x
    gy = 0.00001;                   % gStain in y
    gz = 0.00001;                   % gStain in z
           
    fitin = [fitin gx gy gz];                   % initialisation
    lb = [lb 0.00000001 0.00000001 0.00000001]; % lower boundaries
    ub = [ub 0.001 0.001 0.001];                % upper boundaries
end
