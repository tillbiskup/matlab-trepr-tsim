function varargout = trEPRTSim_history(varargin)
% TREPRTSIM_HISTORY Manage history records of the TSim module (create, ...)
%
% Usage
%   dataset = trEPRTSim_history('write',dataset);
%
%   <command> - string 
%               currently only 'write'
%               'write' - write history record
%
%   dataset   - struct
%               Full trEPR toolbox dataset including TSim structure
%
% See also TREPRDATASTRUCTURE.

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-09-12

if ~nargin && ~nargout
    help trEPRTSim_history
    return;
end

if nargin && ischar(varargin{1})
    switch lower(varargin{1})
        case 'write'
            if nargin < 2
                fprintf('No dataset to operate on...\n');
                return;
            end
            if ~isstruct(varargin{2})
                fprintf('%s has wrong type',inputname(2));
                return;
            end
            dataset = varargin{2};
            [missing,~] = trEPRdataStructure('check',dataset);
            if ~isempty(missing)
                fprintf('%s lacks fields',inputname(2));
                return;
            end
            % Create history record
            history = trEPRdataStructure('history');
            % TODO: Proper name of method (?)
            history.method = 'trEPRTSim';
            history.parameters.TSim = dataset.TSim;
            history.parameters.calculated = dataset.calculated;
            dataset.history{end+1} = history;
            clear history;
            varargout{1} = dataset;            
        otherwise
            fprintf('Command ''%s'' unknown\n',varargin{1});
            return;
    end
end

end
