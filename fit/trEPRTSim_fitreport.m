function report = trEPRTSim_fitreport(dataset)
% TREPRTSIM_FITREPORT Report fit results and final parameter set.
%
% Usage
%   report  = trEPRTSim_fitreport(tofit,inipar,fittedpar,lb,ub)
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
%   report  - cell array
%
% See also TREPRTSIM

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-09-12

% Get fit parameters and their definitions
fitparDef = trEPRTSim_fitpar();
fittedparDef = fitparDef(dataset.TSim.fit.fitini.tofit,:);

% Get length of parameter names for nice typesetting  of table below
lengthofparameternames = cellfun(@(x)length(x),fittedparDef(:,1));

report = cell(0,1);

report{end+1,1} = 'The following parameters have been fitted:';
report{end+1,1} = '';
% Depending on maximum length of parameter name, insert one or two tabs
if max(lengthofparameternames) > 7
    report{end+1,1} = sprintf('Name\t\tstart\t\tlb\t\tub\t\tfinal\t\tunit');
else
    report{end+1,1} = sprintf('Name\tstart\t\tlb\t\tub\t\tfinal\t\tunit');
end
for k=1:size(fittedparDef,1)
    report{end+1,1} = sprintf('%s\t%e\t%e\t%e\t%e\t%s',...
        fittedparDef{k,1},...
        dataset.TSim.fit.inipar(k),...
        dataset.TSim.fit.fitini.lb(k),...
        dataset.TSim.fit.fitini.ub(k),...
        dataset.TSim.fit.fittedpar(k),...
        fittedparDef{k,4}); %#ok<AGROW>
end

% TODO
% - Conversion of units
% - other stuff such as additional output parameters

% mhz2rcm = 10e6/clight*10e-2; % MHz --> 1/cm
% results = [results sprintf(['D = ', num2str(fittedpar(1)*1e3*mhz2rcm),' 1/cm = ',num2str(mhz2mt(fittedpar(1)*1e3,g)*10),' Gauss\n'])];
