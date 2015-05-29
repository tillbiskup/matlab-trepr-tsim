function TsimParDisplay(dataset,command,varargin)
% TSIMPARDISPLAY Display parameters for simulating and/or fitting
% triplet spectra with Tsim.
%
% Usage
%   TsimSimini(dataset,<command>);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
%   command - string
%             one of 'sim', 'fit' or 'simall'
%             'sim'    - display simulation parameters currently
%                        initialized, including their value (shows simpar)
%
%             'fit'    - display fit parameters currently initialized
%
%             'fitpar' - display fit parameters currently initialized,
%                        including values, lower and upper boundaries
%
%             'simall' - display all possible simulation parameters
%
%             'simpar' - display simulation parameters currently
%                        initialized, excluding their value
%
% See also TSIM

% Copyright (c) 2013-15, Deborah Meyer, Till Biskup
% 2015-05-29

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addRequired('dataset',@isstruct);
parser.addRequired('command',@ischar);
parser.parse(dataset,command,varargin{:});

SimExpFields = {'mwFreq','nPoints','Range','Temperature','Ordering'};
FitExpFields = {'Temperature','scale','Ordering'};
maxLengthExpFields = max(cellfun(@(x)length(x),SimExpFields));

switch lower(command)
    case 'sim'
       % Display simpar 
       % TODO Can be made nicer with loading the parameters and displaying the
       % propper name (with description) instead of the internal name
       disp(dataset.TSim.sim.simpar);
        
    case 'fit'
        % TODO: Display lb, ub
        % TODO: Display only those parameters that were chosen
        % Hint: Use fit.fitparameters etc
        % Display parameters from Sys structure
        SysFields = fieldnames(dataset.TSim.sim.Sys);
        maxLengthSysFields = max(cellfun(@(x)length(x),SysFields));
        maxLengthFields = max(maxLengthSysFields,maxLengthExpFields);
        for k=1:length(SysFields)
            fprintf('%s%s ',SysFields{k},...
                blanks(maxLengthFields-length(SysFields{k})));
            for m = 1:length(dataset.TSim.sim.Sys.(SysFields{k}))
                fprintf('%10.4f ',dataset.TSim.sim.Sys.(SysFields{k})(m));
            end
            fprintf('\n');
        end
        % Display selected parameters from Exp structure
        for k=1:length(FitExpFields)
            fprintf('%s%s ',FitExpFields{k},...
                blanks(maxLengthFields-length(FitExpFields{k})));
            for m = 1:length(dataset.TSim.sim.Exp.(FitExpFields{k}))
                fprintf('%10.4f ',dataset.TSim.sim.Exp.(FitExpFields{k})(m));
            end
            fprintf('\n');
        end
    case 'fitpar'
        % TODO: Display lb, ub
        % TODO: Display only those parameters that were chosen
        % Hint: Use fit.fitparameters etc
        parameters = TsimFitpar;
        parameters = parameters(dataset.TSim.fit.fitini.tofit,:);
        maxLengthFields = max(cellfun(@(x)length(x),parameters(:,1)));
        % Set minimum length for maxLengthFields to hold heading
        if maxLengthFields < 4
            maxLengthFields = 4;
        end
        % Print headline
        fprintf('Name%s  start\t\tlb\t\tub\n',...
            blanks(maxLengthFields-4));
        for k=1:size(parameters,1)
            fprintf('%s%s  %10.5f\t%10.5f\t%10.5f\n',parameters{k,1},...
                blanks(maxLengthFields-length(parameters{k,1})),...
                dataset.TSim.fit.inipar(k),...
                dataset.TSim.fit.fitini.lb(k),...
                dataset.TSim.fit.fitini.ub(k));
        end
    case 'simall'
        % Display all possible useraccessible simparameters
        
        % Display selected parameters from Exp structure
        for k=1:length(SimExpFields)
            fprintf('%s%s ',SimExpFields{k},...
                blanks(maxLengthFields-length(SimExpFields{k})));
            for m = 1:length(dataset.TSim.sim.Exp.(SimExpFields{k}))
                fprintf('%10.4f ',dataset.TSim.sim.Exp.(SimExpFields{k})(m));
            end
            fprintf('\n');
        end
    case 'simpar'
        % Display parameters from Sys and Exp structure
        SysFields = (fieldnames(dataset.TSim.sim.Sys))';
        simpar = [SysFields,SimExpFields];
        fprintf('%s', strJoin(simpar,', '));
    otherwise
        disp('Booo!');
        return;
end

end