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
% Keywords:         zero-field-splitting, displayment
%
% This function concats all parameter that will be displayed in the return 
% variable results and then displays the variable 


function results = transient_displayment(fitout,g)


% inifactor defines which parameters should be fittet
global inifactor


% Standartization of the polarisations 
polnorm = fitout(3)+fitout(4)+fitout(5);
pol1 = fitout(3)/polnorm;
pol2 = fitout(4)/polnorm;
pol3 = fitout(5)/polnorm;


% Defining the displayment varibale results by concatination  of the
% final-parameters wich are undepedend of the inifactor. convert1 and
% convert2 are used to convert beween different units 
convert1 = 0.33356410e-4; % factor to convert MHz--> 1/cm
convert2 = 1/(1.39962*g); % factor to convert MHz--> Gauss
results = sprintf(['Final Parameter (D and E in GHz)\n',num2str(fitout),'\n']);
results = [results sprintf(['D = ', num2str(fitout(1)*1e3*convert1),' 1/cm = ',num2str(fitout(1)*1e3*convert2),' Gauss\n'])];
results = [results sprintf(['E = ',num2str(fitout(2)*1e3*convert1),' 1/cm = ',num2str(fitout(2)*1e3*convert2),' Gauss\n'])];
results = [results sprintf(['PolX = ',num2str(pol2),'\n'])];
results = [results sprintf(['PolY = ',num2str(pol3),'\n'])];
results = [results sprintf(['PolZ = ',num2str(pol1),'\n'])];


% Defining the displayment varibale results by concatination  of the
% final-parameters wich are depedend of the inifactor
% inifactor == 1 --> [D E Pol1 Pol2 Pol3 scale lw]
% inifactor == 2 --> [D E Pol1 Pol2 Pol3 scale lw DeltaB]
% inifactor == 3 --> [D E Pol1 Pol2 Pol3 scale lw DeltaB gx gy gz]
% inifactor == 4 --> [D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB]
% inifactor == 5 --> [D E Pol1 Pol2 Pol3 scale lwD lwE DeltaB gx gy gz]
if (inifactor == 1)||(inifactor == 2)||(inifactor == 3)
    results = [results sprintf(['lw = ',num2str(fitout(7)*10),' Gauss\n'])];
end
if (inifactor == 4)||(inifactor == 5)
    results = [results sprintf(['lwD = ',num2str(fitout(7)),' MHz = ',num2str(fitout(6)*convert2),' Gauss\n'])];
    results = [results sprintf(['lwE = ',num2str(fitout(8)),' MHz = ',num2str(fitout(7)*convert2),' Gauss\n'])];
    results = [results sprintf(['DeltaB = ',num2str(fitout(9)*10),' Gauss\n'])]; 
end
if (inifactor == 2)||(inifactor == 3)
    results = [results sprintf(['DeltaB = ',num2str(fitout(8)),' Gauss\n'])]; 
end
if (inifactor == 3)
    results = [results sprintf(['gx = ',num2str(fitout(9)),'\n'])];
    results = [results sprintf(['gy = ',num2str(fitout(10)),'\n'])];
    results = [results sprintf(['gz = ',num2str(fitout(11)),'\n'])];
end
if (inifactor == 5)
    results = [results sprintf(['gx = ',num2str(fitout(10)),'\n'])];
    results = [results sprintf(['gy = ',num2str(fitout(11)),'\n'])];
    results = [results sprintf(['gz = ',num2str(fitout(12)),'\n'])];
end


% Final displayment of the variable
disp(results)