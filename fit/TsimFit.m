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
BigSpectrum = [BigSpectrum; Multidataset{numberOfDatasets}.Tsim.fit.spectrum.tempSpectrum];
end



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

Multidataset{1}.Tsim.fit.fitreport.exitmessage = output.message;

%%%%%%%%%%%%%%%%%%%
% cut residual according to length of individual spectra

whereToCut = cumsum([0 cellfun(@(x)x.Tsim.sim.simpar.nPoints,Multidataset)]);

%%%%%%%%%%%%%%%%%%%%
for numberOfDatasets = 1:length(Multidataset)
    Multidataset{numberOfDatasets}.Tsim.fit.fitreport.jacobian = jacobian;
    Multidataset{numberOfDatasets}.Tsim.fit.fitreport.residual = ...
        residual(1+whereToCut(numberOfDatasets):whereToCut(numberOfDatasets+1));
    variance = var(Multidataset{numberOfDatasets}.Tsim.fit.fitreport.residual);
    Jac = Multidataset{numberOfDatasets}.Tsim.fit.fitreport.jacobian;
Multidataset{numberOfDatasets}.Tsim.fit.fitreport.stdDev = ...
    full(commonFitStdDev(Jac,variance));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Put all parameters in all datasets, and take care to make the
% offsetthingy right

Master = Multidataset{1};

for numberOfDatasets = 1:length(Multidataset)
    
    tempSpectrum = Multidataset{numberOfDatasets}.Tsim.fit.spectrum.tempSpectrum;
    section = Multidataset{numberOfDatasets}.Tsim.fit.spectrum.section;
    Range = Multidataset{numberOfDatasets}.Tsim.sim.simpar.Range;
    nPoints = Multidataset{numberOfDatasets}.Tsim.sim.simpar.nPoints;
    mwFreq =   Multidataset{numberOfDatasets}.Tsim.sim.simpar.mwFreq;

    
    fixedRelationParameters = Multidataset{numberOfDatasets}.Tsim.fit.globally.fixedRelationParameters;
    offset = Multidataset{numberOfDatasets}.Tsim.fit.globally.offset;
    stDev = Multidataset{numberOfDatasets}.Tsim.fit.fitreport.stdDev;
    residual = Multidataset{numberOfDatasets}.Tsim.fit.fitreport.residual;
    jacobian = Multidataset{numberOfDatasets}.Tsim.fit.fitreport.jacobian;

    
    
    
    Multidataset{numberOfDatasets}.Tsim = Master.Tsim;
    
    Multidataset{numberOfDatasets}.Tsim.fit.spectrum.tempSpectrum =tempSpectrum;
    Multidataset{numberOfDatasets}.Tsim.fit.spectrum.section = section;
    Multidataset{numberOfDatasets}.Tsim.sim.simpar.Range = Range;
    Multidataset{numberOfDatasets}.Tsim.sim.simpar.nPoints = nPoints;
    Multidataset{numberOfDatasets}.Tsim.sim.simpar.mwFreq = mwFreq;
    
    
    Multidataset{numberOfDatasets}.Tsim.fit.globally.fixedRelationParameters = fixedRelationParameters;
    Multidataset{numberOfDatasets}.Tsim.fit.globally.offset = offset;
    Multidataset{numberOfDatasets}.Tsim.fit.fitreport.stdDev = stDev;
    Multidataset{numberOfDatasets}.Tsim.fit.fitreport.residual = residual;
    Multidataset{numberOfDatasets}.Tsim.fit.fitreport.jacobian = jacobian;
    
    for HowManyFixedRelationParameters = 1:length(fixedRelationParameters)
        
        Multidataset{numberOfDatasets}.Tsim.sim.simpar.(char(fixedRelationParameters(HowManyFixedRelationParameters))) ...
            = Master.Tsim.sim.simpar.(char(fixedRelationParameters(HowManyFixedRelationParameters))) + offset(HowManyFixedRelationParameters) ;
        
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Make the finalvalues right
    % Take care of offset
    
    numbers = 1:length(Multidataset{1}.Tsim.fit.fitpar);
    whereInFinalValues = numbers(ismember(Multidataset{1}.Tsim.fit.fitpar,  Multidataset{1}.Tsim.fit.globally.fixedRelationParameters));
    
    for foundIt=1:length(whereInFinalValues)
        
        numbers2 = 1:length(Multidataset{1}.Tsim.fit.globally.fixedRelationParameters);
        BoolwhereInOffset = ismember(Multidataset{1}.Tsim.fit.globally.fixedRelationParameters, Multidataset{numberOfDatasets}.Tsim.fit.fitpar(whereInFinalValues(foundIt)) );
        
        Multidataset{numberOfDatasets}.Tsim.fit.finalvalue(whereInFinalValues(foundIt)) = Multidataset{numberOfDatasets}.Tsim.fit.finalvalue(whereInFinalValues(foundIt)) + ...
            Multidataset{numberOfDatasets}.Tsim.fit.globally.offset(numbers2(BoolwhereInOffset));
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Take care of the spectrum for all datasets by simulating each spectrum
    
    % Calling simulation function
    Multidataset{numberOfDatasets} = TsimSim(Multidataset{numberOfDatasets});
    
end

end