function sim = trEPRTSim_fit(par,Bfield)
% TREPRTSIM_FIT Calculate fit calling trEPRTSim_sim and display iterative
% results.
%
% Usage
%   sim = trEPRTSim_fit(par,Bfield)
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
% See also TREPRTSIM

% (c) 2005, Moritz Kirste
% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-06


% spectrum is the experimental signal
global spectrum

% Calling simulation function
[sim,~] = trEPRTSim_sim(par,Bfield);


% The momentarly parameters are displayed
disp(num2str(par))


% The momentarly figure is plotted to see the improvement
figure(1)
plot(Bfield,[spectrum(:,2),sim]);
pause(0.001);