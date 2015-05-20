% Calculate spin-polarised triplet spectra as a function of the populations
% of level one and three. Level two is alwasy zero.
% 
%
% Set p2 to zero and vary p1 and p3 while keeping all other parameters  
% constant. D and E are chosen to be 1000 MHz for D and 50 MHz for E.
%
% The script uses the underlying infrastructure provided by the trEPRTSim
% module, but does not make use of the CLI.
%
% A series of spectra are calculated and the result plotted in various
% ways. This script may serve as a starting point for similar systematic
% investigations of the parameters.

% (c) 2013, Till Biskup, <till@till-biskup.de>
% (c) 2014, Deborah Meyer
% 2014-10-14

% Prepare dataset for simulation
dataset = trEPRTSim_dataset();
dataset = trEPRTSim_simini(dataset);

% Change a few parameters in Sys and Exp structure
% isotropic g tensor
dataset.TSim.sim.Sys.g = [2 2 2];
% Field range and stepping
dataset.TSim.sim.Exp.Range = [300 394]; % in mT
dataset.TSim.sim.Exp.nPoints = 95;
% D and E values (1000 MHz and 50 MHz) in D Tensor form [-D/3+E -D/3-E 2*D/3]
dataset.TSim.sim.Sys.D = [-238-1/3 -383-1/3 666+2/3];
% % Population
% dataset.TSim.sim.Exp.Temperature = [0 0.45 0.55];
% isotropic and anisotropic line width
dataset.TSim.sim.Sys.lw = [0 0]; % in mT

% Get range for p1 and p3

p1 = 2 : 2 : 98; % in MHz
p3 = 100-p1;

% Set p2 to zero
p2 = 0;

% Preallocate cell array for speed
simdataset = cell(length(p1),1);
data = zeros(dataset.TSim.sim.Exp.nPoints,length(p1));

% Be kind and tell the user what is going on
fprintf('Calculating %i spectra\n',length(p1));

% Loop over p1 values
for k = 1:length(p1)
   
    % Set populations respectively
    dataset.TSim.sim.Exp.Temperature = [p1(k) p2 p3(k)];
    % Do actual simulation
    simdataset{k} = trEPRTSim_sim(dataset);
    % Create 2D matrix with data, B0 vs. p1
    data(:,k) = simdataset{k}.calculated;
    
    % Print dot on Matlab command line for each successful simulation
    % as kind of a progress bar
    fprintf('.');
    
    % Insert line breaks for many spectra
    if ~mod(k,50)
        fprintf('\n');
    end
end

% Line feed (just for better display)
fprintf('\n');

% 2D Plot Spectral Intesities as function of p1
figure();
imagesc(p1,dataset.TSim.sim.Exp.Range,data);
set(gca,'YDir','normal');
set(gca,'XLim',[min(p1) max(p1)]);
xlabel('{\it p_1} / MHz');
ylabel('{\it magnetic field} / mT');
title('Triplet spectra as function of the population parameter {\it p_1}');

% Plot some spectra on top of each other
figure();
xaxis = linspace(...
    min(dataset.TSim.sim.Exp.Range),...
    max(dataset.TSim.sim.Exp.Range),...
    dataset.TSim.sim.Exp.nPoints ...
    );
plot(...
    xaxis,data(:,1),'k-',...
    xaxis,data(:,10),'c-',...
    xaxis,data(:,20),'m-',...
    xaxis,data(:,30),'y-',...
    xaxis,data(:,40),'g-',...
    xaxis,data(:,end),'r-'...
    );
legend(...
    sprintf('{\\it p_1} = %i ',p1(1)),...
    sprintf('{\\it p_1} = %i ',p1(10)),...
    sprintf('{\\it p_1} = %i ',p1(20)),...
    sprintf('{\\it p_1} = %i ',p1(30)),...
    sprintf('{\\it p_1} = %i ',p1(40)),...
    sprintf('{\\it p_1} = %i ',p1(end))...
    );
set(gca,'XLim',dataset.TSim.sim.Exp.Range);
xlabel('{\it magnetic field} / mT');
ylabel('{\it intensity} / a.u.');
title('Triplet spectra as function of the populations');

