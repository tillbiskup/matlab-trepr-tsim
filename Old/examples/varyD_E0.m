% Calculate spin-polarised triplet spectra as a function of the ZFS
% parameter D
%
% Set E to zero and vary D while keeping all other parameters constant.
%
% The script uses the underlying infrastructure provided by the Tsim
% module, but does not make use of the CLI.
%
% A series of spectra are calculated and the result plotted in various
% ways. This script may serve as a starting point for similar systematic
% investigations of the parameters.

% Copyright (c) 2013, Till Biskup, <till@till-biskup.de>
% 2013-10-18

% Prepare dataset for simulation
dataset = TsimDataset();
dataset = TsimSimini(dataset);

% Change a few parameters in Sys and Exp structure
% isotropic g tensor
dataset.TSim.sim.Sys.g = [2 2 2];
% Field range and stepping
dataset.TSim.sim.Exp.Range = [0 550]; % in mT
dataset.TSim.sim.Exp.nPoints = 551;
% Population
dataset.TSim.sim.Exp.Temperature = [0.5 0.5 0];
% isotropic line width
dataset.TSim.sim.Sys.lw = 0; % in mT

% Get range for D
D = 1000 : 100 : 1400; % in MHz

% Set E to zero
E = 0;

% Preallocate cell array for speed
simdataset = cell(length(D),1);
data = zeros(dataset.TSim.sim.Exp.nPoints,length(D));

% Be kind and tell the user what is going on
fprintf('Calculating %i spectra\n',length(D));

% Loop over D values
for k = 1:length(D)
   
    % Set D tensor respectively
    dataset.TSim.sim.Sys.D = [-D(k)/3+E -D(k)/3-E 2*D(k)/3];
    % Do actual simulation
    simdataset{k} = TsimSim(dataset);
    % Create 2D matrix with data, B0 vs. D
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

% Plot D as function of B0
figure();
imagesc(D,dataset.TSim.sim.Exp.Range,data);
set(gca,'YDir','normal');
set(gca,'XLim',[min(D) max(D)]);
xlabel('{\it D} / MHz');
ylabel('{\it magnetic field} / mT');
title('Triplet spectra as function of the ZFS parameter {\it D}');

% Plot first and last spectrum on top of each other
figure();
xaxis = linspace(...
    min(dataset.TSim.sim.Exp.Range),...
    max(dataset.TSim.sim.Exp.Range),...
    dataset.TSim.sim.Exp.nPoints ...
    );
plot(...
    xaxis,data(:,1),'k-',...
    xaxis,data(:,end),'r-'...
    );
legend(...
    sprintf('{\\it D} = %i MHz',D(1)),...
    sprintf('{\\it D} = %i MHz',D(end))...
    );
set(gca,'XLim',dataset.TSim.sim.Exp.Range);
xlabel('{\it magnetic field} / mT');
ylabel('{\it intensity} / a.u.');
title('Triplet spectra as function of the ZFS parameter {\it D}');

% Plot relative intensities of min and max of DeltaM_S = 1 transition
% Please note: For large D, the DeltaM_S = 2 transition has eventually a larger
%              intensity than the DeltaM_S = 1 transition.

% Cutoff between DeltaM_S = 1 and DeltaM_S = 2
% Has to be set manually depending on the spin system parameters
cutoffField = 200; % in mT
cutoffPosition = find(xaxis>cutoffField,1);

MS1min = zeros(length(D),1);
MS1max = zeros(length(D),1);
MS2 = zeros(length(D),1);

for k=1:length(D)
    MS1min(k) = min(data(cutoffPosition:end,k));
    MS1max(k) = max(data(cutoffPosition:end,k));
    MS2(k)    = min(data(1:cutoffPosition,k));
end

figure();
plot(...
    D,MS1min,'k-',...
    D,MS1max,'r-',...
    [min(D) max(D)],[0 0],'k:' ...
    );
legend('\DeltaM_S max','\DeltaM_s min');
xlabel('{\it D} / MHz');
ylabel('{\it intensity} / a.u.');
title('Minima and maxima of the \DeltaM_s=1 transition as function of {\it D}');

figure();
plot(...
    D,abs(MS1max./MS1min),'k-'...
    );
xlabel('{\it D} / MHz');
ylabel('{\it \Deltaintensity} / a.u.');
title('Ratio of the \DeltaM_s=1 extrema as function of {\it D}');

figure();
plot(...
    D,abs(MS2./MS1min),'k-'...
    );
xlabel('{\it D} / MHz');
ylabel('{\it \Deltaintensity} / a.u.');
title('Ratio of the \DeltaM_s=1 and \DeltaM_s=2 minima as function of {\it D}');

