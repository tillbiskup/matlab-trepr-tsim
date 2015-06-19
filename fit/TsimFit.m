function dataset = TsimFit(dataset)
% TSIMFIT Fit triplet spectra with Tsim.
%
%
% Usage
%   dataset = TsimFit(dataset)
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2013-2015, Deborah Meyer, Till Biskup
% 2015-06-19


Magfieldaxis = linspace(...
    dataset.TSim.sim.simpar.Range(1),...
    dataset.TSim.sim.simpar.Range(2),...
    dataset.TSim.sim.simpar.nPoints);

% x = lsqcurvefit(fun,x0,xdata,ydata,lb,ub)
% Fitting
% [x,resnorm,residual,exitflag,output,lambda,jacobian] = ...
% dataset.TSim.fit.routine = output.algorithm
options = optimset(dataset.TSim.fit.fitopt);
fitfun = @(x,Magfieldaxis)TsimFitFun(x,Magfieldaxis,dataset);
[dataset.TSim.fit.finalvalue,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(fitfun, ...
    dataset.TSim.fit.initialvalue, ...
    Magfieldaxis, ...
    dataset.TSim.fit.spectrum.tempSpectrum, ...
    dataset.TSim.fit.lb, ...
    dataset.TSim.fit.ub, ...
    options);


% Calculate with final values for a full dataset
% Set simpar parameters according to parameters that have been fitted
dataset = TsimFitpar2simpar(dataset.TSim.fit.finalvalue,dataset);
% Calling simulation function
dataset = TsimSim(dataset);

% Fill in some information
dataset.TSim.fit.routine = 'lsqcurvefit';
dataset.TSim.fit.algorithm = output.algorithm;
dataset.TSim.fit.report.residual = residual;
dataset.TSim.fit.report.jacobian = jacobian;
dataset.TSim.fit.report.exitmessage = output.message;

variance = var(dataset.TSim.fit.report.residual);
dataset.TSim.fit.report.stdDev = commonFitStdDev(dataset.TSim.fit.report.jacobian,variance);

end