function [sim,DeltaB] = trEPRTSim_sim(par,Bfield)
% TREPRTSIM_SIM Simulate spectrum using the EasySpin function pepper.
%
% This file uses EasySpin. See http://www.easyspin.org/ 
%
% Usage
%   [sim,DeltaB] = trEPRTSim_sim(par,Bfield)
%
%   par     - vector
%             simulation parameters
%
%   Bfield  - vector
%             magnetic field axis the simulation is calculated for
%
%   sim     - vector
%             calculated spectrum
%
%   DeltaB  - scalar
%             field offset
%
% See also TREPRTSIM

% (c) 2005, Moritz Kirste
% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-06

% Sys and Exp are needed by EasySpin, spectrum is the measured signal and
% inifactor defines which parameters should be fittet. All these parameters
% are needed by some of the sub-functions and are therefore global
global Sys
global Exp
global inifactor

% Initialization of the parameters independent of the inifactor.
% The parameters are described in the function trEPRTSim_fitini
D = par(1);
E = par(2);
Pol1 = par(3);
Pol2 = par(4);
Pol3 = par(5);
scale = par(6);
DeltaB = 0; 


% Setting the polarisation vector and the D vector
% (see EasySpin documentation)
Exp.Temperature = [Pol1 Pol2 Pol3] ;
Sys.D = 1e3*[-D/3 + E, -D/3 - E, 2*D/3];  % GHZ is changed to MHz 


% Initialization of the parameters depending on the inifactor
% inifactor == 1 --> [D E Pol1 Pol2 Pol3 scale lw]
% inifactor == 2 --> [D E Pol1 Pol2 Pol3 scale lw DeltaB]
% inifactor == 3 --> [D E Pol1 Pol2 Pol3 scale lw DeltaB gx gy gz]
% inifactor == 4 --> [D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB]
% inifactor == 5 --> [D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB gx gy gz]
if (inifactor == 1)||(inifactor == 2)||(inifactor == 3)
    lw = par(7);
    Sys.lw = lw;
end
if (inifactor == 2)||(inifactor == 3)
    DeltaB = par(8);
end
if (inifactor == 3)
    gx = par(9);
    gy = par(10);
    gz = par(11);
    Sys.gStrain = [gx gy gz];
end
if (inifactor == 4)||(inifactor == 5)
    lwD = par(7);
    lwE = par(8);
    DeltaB = par(9);
    Sys.DStrain = [lwD lwE];    
end
if (inifactor == 5)
    gx = par(10);
    gy = par(11);
    gz = par(12);
    Sys.gStrain = [gx gy gz];
end


% Adjusting field offset and converting G -> mT.
Exp.Range = ([Bfield(1) Bfield(end)]+DeltaB)/10;

% Calculating the spectrum using Easyspin's pepper function and scaling it 
% with the given scaling factor. sim is the return variable.
sim(:,1) = scale*pepper(Sys,Exp);

end