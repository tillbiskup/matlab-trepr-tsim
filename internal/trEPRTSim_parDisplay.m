function trEPRTSim_parDisplay(dataset,command,varargin)
% TREPRTSIM_PARDISPLAY Display parameters for simulating and/or fitting
% triplet spectra with trEPRTSim.
%
% Usage
%   trEPRTSim_simini(dataset,<command>);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
%   command - string
%             one of 'sim', 'fit' or 'simall'
%             'sim'    - display simulation parameters currently
%                        initialized, including their value
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
% See also TREPRTSIM

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-12-06

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
        % Display parameters from Sys structure
        SysFields = fieldnames(dataset.TSim.sim.Sys);
       
        % Remove spin multiplicity from display
        SysFields(ismember(SysFields,{'S'})) = [];
        maxLengthSysFields = max(cellfun(@(x)length(x),SysFields));
        maxLengthFields = max(maxLengthSysFields,maxLengthExpFields);
        for k=1:length(SysFields)
            if strcmpi(SysFields{k},'D')
                fprintf('D%s ',blanks(maxLengthFields-1));
                fprintf('%10.4f ',dataset.TSim.sim.Sys.D(3)*3/2);
                fprintf('\n');
                fprintf('E%s ',blanks(maxLengthFields-1));
                fprintf('%10.4f ',(dataset.TSim.sim.Sys.D(1)-...
                    dataset.TSim.sim.Sys.D(2))/2);
                fprintf('\n');
            else
                fprintf('%s%s ',SysFields{k},...
                    blanks(maxLengthFields-length(SysFields{k})));
                for m = 1:length(dataset.TSim.sim.Sys.(SysFields{k}))
                    fprintf('%10.4f ',dataset.TSim.sim.Sys.(SysFields{k})(m));
                end
            fprintf('\n');
            end
        end
        % Display selected parameters from Exp structure
        for k=1:length(SimExpFields)
            fprintf('%s%s ',SimExpFields{k},...
                blanks(maxLengthFields-length(SimExpFields{k})));
            for m = 1:length(dataset.TSim.sim.Exp.(SimExpFields{k}))
                fprintf('%10.4f ',dataset.TSim.sim.Exp.(SimExpFields{k})(m));
            end
            fprintf('\n');
        end
         % Display parameters from Opt structure
        OptFields = fieldnames(dataset.TSim.sim.Opt);
         for k=1:length(OptFields)
            fprintf('%s%s ',OptFields{k},...
                blanks(maxLengthFields-length(OptFields{k})));
            
            for m = 1:length(dataset.TSim.sim.Opt.(OptFields{k}))
                if ischar(dataset.TSim.sim.Opt.(OptFields{k}))
                    fprintf('%s%s ',dataset.TSim.sim.Opt.(OptFields{k})(m));
                else
                    fprintf('%10.4f ',dataset.TSim.sim.Opt.(OptFields{k})(m));
                end
            end
            fprintf('\n');
         end
        
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
        parameters = trEPRTSim_fitpar;
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
        % Display parameters from Sys structure
        conf = trEPRTSim_conf;
        SysFields = fieldnames(conf.Sys);
        maxLengthSysFields = max(cellfun(@(x)length(x),SysFields));
        maxLengthFields = max(maxLengthSysFields,maxLengthExpFields);
        for k=1:length(SysFields)
            if strcmpi(SysFields{k},'D')
                fprintf('D%s ',blanks(maxLengthFields-1));
                fprintf('%10.4f ',conf.Sys.D(3)*3/2);
                fprintf('\n');
                fprintf('E%s ',blanks(maxLengthFields-1));
                fprintf('%10.4f ',(conf.Sys.D(1)-conf.Sys.D(2))/2);
                fprintf('\n');
            else
                fprintf('%s%s ',SysFields{k},...
                    blanks(maxLengthFields-length(SysFields{k})));
                for m = 1:length(conf.Sys.(SysFields{k}))
                    fprintf('%10.4f ',conf.Sys.(SysFields{k})(m));
                end
                fprintf('\n');
            end
        end
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