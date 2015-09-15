function varargout = TsimHistory(varargin)
% TSIMHISTORY Manage history records of the Tsim module (create, ...)
%
% Usage
%   dataset = TsimHistory('write',dataset);
%
%   <command> - string 
%               currently only 'write'
%               'write' - write history record
%
%   dataset   - struct
%               Full trEPR toolbox dataset including Tsim structure
%
% See also TREPRDATASTRUCTURE.

% Copyright (c) 2013-15, Deborah Meyer, Till Biskup
% 2015-09-15

if ~nargin && ~nargout
    help TsimHistory
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
            % TODO: Proper name of method taken from TsimInfo
            history.method = 'Tsim';
            history.parameters.Tsim = dataset.Tsim;
            for counter = 1:length(dataset.Tsim)
                history.parameters.Tsim(counter).fit.spectrum = rmfield(...
                    history.parameters.Tsim(counter).fit.spectrum,'tempSpectrum');
            end
            dataset.history{end+1} = history;
            clear history;
            varargout{1} = dataset;            
        otherwise
            fprintf('Command ''%s'' unknown\n',varargin{1});
            return;
    end
end

end
