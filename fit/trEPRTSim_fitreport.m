function report = trEPRTSim_fitreport(tofit,inipar,fittedpar,lb,ub)
% TREPRTSIM_FITREPORT Report fit results and final parameter set.
%
% Usage
%   report  = trEPRTSim_fitreport(tofit,inipar,fittedpar,lb,ub)
%
%   par     - vector
%             simulation parameters
%
%   g       - scalar / vector
%             g factor used for conversion MHz -> mT
%             In case of g being a vector, g_iso is calculated first
%
%   inifactor -scalar/Bullshit
%
%   report  - cell array
%
% See also TREPRTSIM

% (c) 2005, Moritz Kirste
% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-15

% Get fit parameters and their definitions
fitparDef = trEPRTSim_fitpar();
fittedparDef = fitparDef(tofit,:);

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
        fittedparDef{k,1},inipar(k),lb(k),ub(k),fittedpar(k),...
        fittedparDef{k,4}); %#ok<AGROW>
end

% TODO
% - Conversion of units
% - other stuff such as additional output parameters

% mhz2rcm = 10e6/clight*10e-2; % MHz --> 1/cm
% results = [results sprintf(['D = ', num2str(fittedpar(1)*1e3*mhz2rcm),' 1/cm = ',num2str(mhz2mt(fittedpar(1)*1e3,g)*10),' Gauss\n'])];
