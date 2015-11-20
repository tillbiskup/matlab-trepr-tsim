function Multidataset = TsimFit(Multidataset)
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

BigSpectrum = [];
BigMagfieldaxis = [];
for numberOfDatasets = 1:length(Multidataset)
   Magfieldaxis = linspace(...
    Multidataset{numberOfDatasets}.Tsim.sim.simpar.Range(1),...
    Multidataset{numberOfDatasets}.Tsim.sim.simpar.Range(2),...
    Multidataset{numberOfDatasets}.Tsim.sim.simpar.nPoints);
BigMagfieldaxis = [BigMagfieldaxis, Magfieldaxis] ;
BigSpectrum = [BigSpectrum, Multidataset{numberOfDatasets}.Tsim.fit.spectrum.tempSpectrum];
end

assignin('base', 'Multidataset', Multidataset)

% x = lsqcurvefit(fun,x0,xdata,ydata,lb,ub)
% Fitting
% [x,resnorm,residual,exitflag,output,lambda,jacobian] = ...
% dataset.Tsim.fit.routine = output.algorithm
options = optimset(Multidataset{1}.Tsim.fit.fitopt);
fitfun = @(x,BigMagfieldaxis)TsimFitFun(x,BigMagfieldaxis,Multidataset);
[Multidataset{1}.Tsim.fit.finalvalue,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(fitfun, ...
    Multidataset{1}.Tsim.fit.initialvalue, ...
    BigMagfieldaxis, ...
    BigSpectrum, ...
    Multidataset{1}.Tsim.fit.lb, ...
    Multidataset{1}.Tsim.fit.ub, ...
    options);


% Calculate with final values for a full dataset
% Set simpar parameters according to parameters that have been fitted

Multidataset{1} = TsimFitpar2simpar(Multidataset{1}.Tsim.fit.finalvalue,Multidataset{1});
% Calling simulation function
Multidataset{1} = TsimSim(Multidataset{1});


% Fill in some information
Multidataset{1}.Tsim.fit.routine = 'lsqcurvefit';
Multidataset{1}.Tsim.fit.algorithm = output.algorithm;
Multidataset{1}.Tsim.fit.fitreport.residual = residual;
Multidataset{1}.Tsim.fit.fitreport.jacobian = jacobian;
Multidataset{1}.Tsim.fit.fitreport.exitmessage = output.message;


variance = var(Multidataset{1}.Tsim.fit.fitreport.residual);
Multidataset{1}.Tsim.fit.fitreport.stdDev = ...
    full(commonFitStdDev(Multidataset{1}.Tsim.fit.fitreport.jacobian,variance));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Put all parameters in all datasets, and take care to make the
% offsetthingy right

Master = Multidataset{1};

for numberOfDatasets = 1:length(Multidataset)
    
    tempSpectrum = Multidataset{numberOfDatasets}.Tsim.fit.spectrum.tempSpectrum;
    section = Multidataset{numberOfDatasets}.Tsim.fit.spectrum.section;
    fixedRealtionParameters = Multidataset{numberOfDatasets}.Tsim.fit.globally.fixedRealtionParameters;
    offset = Multidataset{numberOfDatasets}.Tsim.fit.globally.offset;
    
    Multidataset{numberOfDatasets}.Tsim = Master.Tsim;
    
    Multidataset{numberOfDatasets}.Tsim.fit.spectrum.tempSpectrum =tempSpectrum;
    Multidataset{numberOfDatasets}.Tsim.fit.spectrum.section = section;
    Multidataset{numberOfDatasets}.Tsim.fit.globally.fixedRealtionParameters = fixedRealtionParameters;
    Multidataset{numberOfDatasets}.Tsim.fit.globally.offset = offset;
    
    for HowManyFixedRealtionParameters = 1:length(fixedRealtionParameters)
        
        Multidataset{numberOfDatasets}.Tsim.sim.simpar.(char(fixedRealtionParameters(HowManyFixedRealtionParameters))) ...
            = Master.Tsim.sim.simpar.(char(fixedRealtionParameters(HowManyFixedRealtionParameters))) + offset(HowManyFixedRealtionParameters) ;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Take care of the spectrum for all datasets by simulating each spectrum
    
    % Calling simulation function
    Multidataset{numberOfDatasets} = TsimSim(Multidataset{numberOfDatasets});
    
end

end