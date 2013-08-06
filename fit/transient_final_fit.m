% Copyright (C) 2005 Moritz Kirste
% 
% This file ist free software.
% 
% Author:			Moritz Kirste <kirstem@physik.fu-berlin.de>
% Maintainer:		Moritz Kirste <kirstem@physik.fu-berlin.de>
% Created:			2005/10/10
% Version:			$Revision: 1.3 $
% Last Modification:	$Date: 2005/11/30 09:54:43 $
% Keywords:			transient EPR, simulation, EasySpin,
% Keywords:         zero-field-splitting, final-fit
%
%
%
%   This file uses EasySpin written and maintained by the EPR group at the
%   ETH Zuerich. 
%   Contact : easyspin@esr.phys.chem.ethz.ch 
%   EasySpin is freely dowloadable at <http://www.easyspin.ethz.ch/>
%   <quotation source="http://www.easyspin.ethz.ch/">
%   "EasySpin is a Matlab toolbox for solving problems in Electron Paramagnetic 
%   Resonance (EPR) spectroscopy. 
%   Lisence:
%   You may download and work with EasySpin free of charge and without any
%   restrictions. You may copy and distribute verbatim copies of EasySpin.
%   You may not use or modify EasySpin or a part of it for other software
%   which is not freely available at no cost. You may not reverse engineer
%   or disassemble EasySpin. EasySpin comes without warranty of any kind. 
%   If you use results obtained with EasySpin in any scientific
%   publication, cite the appropriate articles. "
%   </quotation>

% Ducumentation:
% This function calculates the final-fit with the fit-parameters defined by
% inifactor 


function [finalfit,DeltaB] = transient_final_fit(fitout,Bfield)

% Sys and Exp are needed by EasySpin, spectrum is the measured signal and
% inifactor defines which parameters should be fittet. All these parameters
% are needed by some of the sub-functions and are therefore global
global Sys
global Exp
global spectrum
global inifactor


% Initialization of the parameter wich are undependent of the inifactor. The
% meaning of the parameters should be clear (just in case : they are
% commented in the function transient_fitini.m )
D = fitout(1);
E = fitout(2);
Pol1 = fitout(3);
Pol2 = fitout(4);
Pol3 = fitout(5);
scale = fitout(6);
DeltaB = 0; 


% Setting the polarisation-vector and the D-vector (see EasySpin documentation)
Exp.Temperature = [Pol1 Pol2 Pol3] ;
Sys.D = 1e3*[-D/3 + E, -D/3 - E, 2*D/3];  % GHZ is changed to MHz 


% Initialization of the parameters depending on the inifactor by
% concatination of the selected fitting-parameter to the default
% fitting-parameter
% inifactor == 1 --> [D E Pol1 Pol2 Pol3 scale lw]
% inifactor == 2 --> [D E Pol1 Pol2 Pol3 scale lw DeltaB]
% inifactor == 3 --> [D E Pol1 Pol2 Pol3 scale lw DeltaB gx gy gz]
% inifactor == 4 --> [D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB]
% inifactor == 5 --> [D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB gx gy gz]
if (inifactor == 1)||(inifactor == 2)||(inifactor == 3)
    lw = fitout(7);
    Sys.lw = lw;
end
if (inifactor == 2)||(inifactor == 3)
    DeltaB = fitout(8);
end
if (inifactor == 3)
    gx = fitout(9);
    gy = fitout(10);
    gz = fitout(11);
    Sys.gStrain = [gx gy gz];
end
if (inifactor == 4)||(inifactor == 5)
    lwD = fitout(7);
    lwE = fitout(8);
    DeltaB = fitout(9);
    Sys.DStrain = [lwD lwE];    
end
if (inifactor == 5)
    gx = fitout(10);
    gy = fitout(11);
    gz = fitout(12);
    Sys.gStrain = [gx gy gz];
end


% Adjusting the Bfield by the parameter DeltaB. Also the Range of the Exp
% structure is defined by the start and the end of the measured Bfield (see
% EasySpin documentation) Bstart and Bend must be converted from Gauss into
% mT 
Bfield = Bfield+DeltaB;   
Bstart = Bfield(1)/10;              % Gauss --> mTesla
Bend = Bfield(length(Bfield))/10;   % Gauss --> mTesla
Exp.Range = [Bstart Bend];


% Easyspin calculates the fit with the function pepper and scales it then
% with the given scaling-factor finalfit is the return variable
fitvector = pepper(Sys,Exp);
finalfit(:,1) = scale*fitvector(:);