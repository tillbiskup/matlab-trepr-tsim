function results = trEPRTSim_fitreport(par,g,inifactor)
% TREPRTSIM_FITREPORT Report fit results and final parameter set.
%
% Usage
%   results = trEPRTSim_fitreport(par,g)
%
%   par     - vector
%             simulation parameters
%
%   g       - scalar / vector
%             g factor used for conversion MHz -> mT
%             In case of g being a vector, g_iso is calculated first
%
%   inifactor -scalar/Bullshit
%
%   results - string
%
% See also TREPRTSIM

% (c) 2005, Moritz Kirste
% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-12

% This function concats all parameter that will be displayed in the return 
% variable results and then displays the variable 

% In case g is not a scalar, but a vector, calculate g_iso
if ~isscalar(g)
    g = mean(g);
end

% Standardisation of the polarisations 
polnorm = par(3)+par(4)+par(5);
pol1 = par(3)/polnorm;
pol2 = par(4)/polnorm;
pol3 = par(5)/polnorm;


% Defining the displayment variable results by concatination  of the
% final-parameters wich are indepedend of the inifactor. convert1 and
% convert2 are used to convert beween different units 
mhz2rcm = 10e6/clight*10e-2; % MHz --> 1/cm
results = sprintf(['Final Parameter (D and E in GHz)\n',num2str(par),'\n']);
results = [results sprintf(['D = ', num2str(par(1)*1e3*mhz2rcm),' 1/cm = ',num2str(mhz2mt(par(1)*1e3,g)*10),' Gauss\n'])];
results = [results sprintf(['E = ',num2str(par(2)*1e3*mhz2rcm),' 1/cm = ',num2str(mhz2mt(par(2)*1e3,g)*10),' Gauss\n'])];
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
    results = [results sprintf(['lw = ',num2str(par(7)*10),' Gauss\n'])];
end
if (inifactor == 4)||(inifactor == 5)
    results = [results sprintf(['lwD = ',num2str(par(7)),' MHz = ',num2str(mhz2mt(par(6)*1e3,g)*10),' Gauss\n'])];
    results = [results sprintf(['lwE = ',num2str(par(8)),' MHz = ',num2str(mhz2mt(par(7)*1e3,g)*10),' Gauss\n'])];
    results = [results sprintf(['DeltaB = ',num2str(par(9)*10),' Gauss\n'])]; 
end
if (inifactor == 2)||(inifactor == 3)
    results = [results sprintf(['DeltaB = ',num2str(par(8)),' Gauss\n'])]; 
end
if (inifactor == 3)
    results = [results sprintf(['gx = ',num2str(par(9)),'\n'])];
    results = [results sprintf(['gy = ',num2str(par(10)),'\n'])];
    results = [results sprintf(['gz = ',num2str(par(11)),'\n'])];
end
if (inifactor == 5)
    results = [results sprintf(['gx = ',num2str(par(10)),'\n'])];
    results = [results sprintf(['gy = ',num2str(par(11)),'\n'])];
    results = [results sprintf(['gz = ',num2str(par(12)),'\n'])];
end


% Final displayment of the variable
disp(results)