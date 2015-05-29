function sim = TsimFit(par,Bfield,spectrum,dataset)
% TSIMFIT Calculate fit calling TsimSim and display iterative
% results.
%
% Usage
%   sim = TsimFit(par,Bfield,spectrum,dataset)
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
% See also TSIM

% Copyright (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-15

% Set Sys and Exp according to parameters that shall be fitted
dataset = TsimPar2SysExp(par,dataset);

% Calling simulation function
dataset = TsimSim(dataset);

% Scaling of spectrum
sim = dataset.TSim.sim.Exp.scale*dataset.calculated;

% Check if someone has mutilated spectrum
if ~isempty(dataset.TSim.fit.fitcut.mutilatedData)
    sim(dataset.TSim.fit.fitcut.cuttedIndices) = [];
    Bfield = dataset.TSim.fit.fitcut.mutilatedField;
end
   

% The current fit parameters are displayed on the command line
disp(num2str(par))

% The current fit is plotted together with the experimental data to see the
% improvement of the fitting process.
figure(1)
plot(Bfield,[spectrum,sim]);
set(gca,'XLim',[min(dataset.axes.y.values),max(dataset.axes.y.values)]);
pause(0.001);

end