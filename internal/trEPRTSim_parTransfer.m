function [Sys,Exp] = trEPRTSim_parTransfer(par,fitpar,tofit,Sys,Exp)
% TREPRTSIM_PARTRANSFER Transfer fitted parameters back to Sys,Exp structs.
%
% Usage
%   [Sys,Exp] = trEPRTSim_parTransfer(par,fitpar,tofit,Sys,Exp)
%
%   par     - vector
%             simulation parameters that shall be fitted
%
%   fitpar  - vector
%             full set of all possible simulation parameters
%
%   tofit   - vector
%             boolean values
%
%   Sys     - struct
%             EasySpin structure for defining spin system
%
%   Exp     - struct
%             EasySpin structure for defining experimental parameters
%
% See also TREPRTSIM

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-12

% Merge parameters to be fitted into vector of all possible fit parameters
fitpar(tofit) = par(1:length(find(tofit)));

% Initialization of the parameters
% [D   E   Exp.Temperature scale lw lwD lwE DeltaB gx   gy   gz  ]
Exp.Temperature = fitpar(3:5);
Sys.D = [...
    -fitpar(1)/3 + fitpar(2),...
    -fitpar(1)/3 - fitpar(2),...
    2*fitpar(1)/3 ...
    ];
Exp.scale = fitpar(6);
Sys.lw = fitpar(7);
if any(tofit(8:9))
    Sys.DStrain = fitpar(8:9);
end
if any(tofit(11:13))
    Sys.gStrain = fitpar(11:13);
end

% Adjusting field offset
Exp.Range = Exp.Range+fitpar(10);

end
