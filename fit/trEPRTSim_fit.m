function sim = trEPRTSim_fit(par,Bfield,spectrum,dataset)
% TREPRTSIM_FIT Calculate fit calling trEPRTSim_sim and display iterative
% results.
%
% Usage
%   sim = trEPRTSim_fit(par,Bfield,spectrum,dataset)
%
%   par      - vector
%              simulation parameters
%
%   Bfield   - vector
%              magnetic field axis the simulation is calculated for
%
%   spectrum - vector
%              y values of the experimental spectrum (for plotting)
%
%   dataset  - struct
%              Full trEPR toolbox dataset including TSim structure
%
% See also TREPRTSIM

% (c) 2005, Moritz Kirste
% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-15

% Set B0 range for simulation
%Exp.Range = [Bfield(1) Bfield(end)];

% Set Sys and Exp according to parameters that shall be fitted
dataset = trEPRTSim_par2SysExp(par,dataset);

% Calling simulation function
dataset = trEPRTSim_sim(dataset);

% Scaling of spectrum
sim = dataset.TSim.sim.Exp.scale*dataset.calculated;

% The momentarly parameters are displayed
disp(num2str(par))

% The momentarly figure is plotted to see the improvement
figure(1)
plot(Bfield,[spectrum,sim]);
pause(0.001);