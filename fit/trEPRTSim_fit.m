function sim = trEPRTSim_fit(par,Bfield,Sys,Exp,spectrum,fitpar,tofit)
% TREPRTSIM_FIT Calculate fit calling trEPRTSim_sim and display iterative
% results.
%
% Usage
%   sim = trEPRTSim_fit(par,Bfield)
%
%   par      - vector
%              simulation parameters
%
%   Bfield   - vector
%              magnetic field axis the simulation is calculated for
%
%   Sys      - struct
%              EasySpin structure for defining spin system
%
%   Exp      - struct
%              EasySpin structure for defining experimental parameters
%
%   spectrum - vector
%              y values of the experimental spectrum (for plotting)
%
%   fitpar   - vector
%              full set of possible simulation parameters
%
%   tofit    - vector 
%              boolean values determining which parameters to fit
%
%   sim      - vector
%              calculated spectrum
%
% See also TREPRTSIM

% (c) 2005, Moritz Kirste
% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-15

% Set B0 range for simulation
%Exp.Range = [Bfield(1) Bfield(end)];

% Set Sys and Exp according to parameters that shall be fitted
[Sys,Exp] = trEPRTSim_parTransfer(par,fitpar,tofit,Sys,Exp);

% Calling simulation function
[sim] = trEPRTSim_sim(Sys,Exp);

% Scaling of spectrum
sim = Exp.scale*sim;

% The momentarly parameters are displayed
disp(num2str(par))

% The momentarly figure is plotted to see the improvement
figure(1)
plot(Bfield,[spectrum,sim]);
pause(0.001);