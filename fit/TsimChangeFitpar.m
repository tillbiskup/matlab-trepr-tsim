function dataset = TsimChangeFitpar(dataset)
% TSIMCHANGEFITPAR Choose different/additional fitting parameters.
%
% Usage
%   dataset = TsimChangeFitpar(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-10

Parameters = TsimParameters;
ParameterNames = Parameters(:,1);
fitpar = logical(cell2mat(Parameters(:,5)));
userpar = logical(cell2mat(Parameters(:,9)));
fituser = userpar & fitpar;

% Check if there is already some information
oldfitpar = dataset.TSim.fit.fitpar;

% Find default indices
Lia = ismember(ParameterNames(fituser), oldfitpar);
indexLia = 1:length(fituser);
indexLia = indexLia(Lia);

% Create Default
defaultPar = num2str(indexLia);

% Create Possible Fitting Parameters
PossibleFitparameters = ParameterNames(fituser);



option = [ ...
    strtrim(cellstr(num2str((1:length(PossibleFitparameters))')))...
    (PossibleFitparameters) ...
    ];

answer = cliMenu(option,...
    'title','Please choose parameters for fitting',...
    'default',defaultPar,'multiple',true);


Big=cellstr(ParameterNames(fituser));
NewFitParameters=Big(str2double(answer));

dataset.TSim.fit.fitpar = NewFitParameters;

dataset = TsimChekFitpar(dataset);

end