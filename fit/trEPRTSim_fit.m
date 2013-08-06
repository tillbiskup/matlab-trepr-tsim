function fit = trEPRTSim_fit(fitin,Bfield)
% TREPRTSIM_FIT Calculate fit calling trEPRTSim_sim and display iterative
% results.
%
% Usage
%   fit = trEPRTSim_fit(fitin,Bfield)
%
%   fitin    - ?
%
%   Bfield   - ?
%
%   fit      - ?
%
% See also TREPRTSIM

% (c) 2005, Moritz Kirste
% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-06


% spectrum is the experimental signal
global spectrum

% Calling simulation function
[fit,~] = trEPRTSim_sim(fitin,Bfield);


% The momentarly parameters are displayed
disp(num2str(fitin))


% The momentarly figure is plotted to see the improvement
figure(1)
plot(Bfield,[spectrum(:,2),fit]);
pause(0.001);