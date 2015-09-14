function dataset = TsimFit(dataset)
% TSIMFIT Fit triplet spectra with Tsim.
%
%
% Usage
%   dataset = TsimFit(dataset)
%
%   dataset - struct
%             Full trEPR toolbox dataset including Tsim structure
%
% See also TSIM

% Copyright (c) 2013-2015, Deborah Meyer, Till Biskup
% 2015-09-14


Magfieldaxis = linspace(...
    dataset.Tsim.sim.simpar.Range(1),...
    dataset.Tsim.sim.simpar.Range(2),...
    dataset.Tsim.sim.simpar.nPoints);

% x = lsqcurvefit(fun,x0,xdata,ydata,lb,ub)
% Fitting
% [x,resnorm,residual,exitflag,output,lambda,jacobian] = ...
% dataset.Tsim.fit.routine = output.algorithm
options = optimset(dataset.Tsim.fit.fitopt);
fitfun = @(x,Magfieldaxis)TsimFitFun(x,Magfieldaxis,dataset);
[dataset.Tsim.fit.finalvalue,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(fitfun, ...
    dataset.Tsim.fit.initialvalue, ...
    Magfieldaxis, ...
    dataset.Tsim.fit.spectrum.tempSpectrum, ...
    dataset.Tsim.fit.lb, ...
    dataset.Tsim.fit.ub, ...
    options);


% Calculate with final values for a full dataset
% Set simpar parameters according to parameters that have been fitted
dataset = TsimFitpar2simpar(dataset.Tsim.fit.finalvalue,dataset);
% Calling simulation function
dataset = TsimSim(dataset);

% Fill in some information
dataset.Tsim.fit.routine = 'lsqcurvefit';
dataset.Tsim.fit.algorithm = output.algorithm;
dataset.Tsim.fit.fitreport.residual = residual;
dataset.Tsim.fit.fitreport.jacobian = jacobian;
dataset.Tsim.fit.fitreport.exitmessage = output.message;


variance = var(dataset.Tsim.fit.fitreport.residual);
dataset.Tsim.fit.fitreport.stdDev = ...
    full(commonFitStdDev(dataset.Tsim.fit.fitreport.jacobian,variance));

end