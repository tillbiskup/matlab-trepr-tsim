function varargout = trEPRTSim_dataStructure(varargin)
% TREPRTSIM_DATASTRUCTURE Return data structure for trEPR TSim module, or
% test compliance of given structure with the data structure of the module.
%
% Usage
%   structure = trEPRTSim_dataStructure;
%   structure = trEPRTSim_dataStructure(<command>)
%   [missingFields,wrongType] = trEPRTSim_dataStructure(<command>,structure)
%
%   <command> - string 
%               one of 'structure', 'model' or 'check'
%               'structure' - return (empty) trEPR toolbox data structure
%               'model' -     return trEPR toolbox data structure with
%                             field types as values
%               'check' -     check given structure for compliance with the
%                             toolbox data structure
%
%   structure - struct
%               either empty trEPR toolbox data structure or 
%               trEPR toolbox data structure with field types as values
%
%   missingFields - cell array
%                   List of fields missing in the structure with respect to
%                   the toolbox data structure
%
%   wrongType -     cell array
%                   List of fields in structure having the wrong type with
%                   respect to the toolbox data structure
%
% See also TREPRLOAD, TREPRDATASTRUCTURE.

% (c) 2013-14, Deborah Meyer, Till Biskup
% 2014-11-14

if ~nargin && ~nargout
    help trEPRTSim_dataStructure
    return;
end

% Create empty trEPR toolbox data structure
dataStructure = struct();
dataStructure.calculated = [];
dataStructure.TSim = struct(...
    'sim',struct(...
        'Sys',struct(...
            'S',1,...
            'g',[],...
            'D',[]...
            ),...
        'Exp',struct(...
            'mwFreq',[],...
            'Range',[],...
            'nPoints',[],...
            'Harmonic',1,...
            'Temperature',[],...
            'Ordering',[]...
            ),...
        'Opt',struct(...
            'nKnots',[],...
            'Method',''...
            ),...
        'routine','' ...
        ),...
    'fit',struct(...
        'inipar',[], ...
        'fittedpar',[], ...
        'fitini',struct(...
            'fitpar',[],...
            'tofit',logical([]),...
            'lb',[], ...
            'ub',[] ...
            ),...
        'fitcut',struct(...
             'cutpoints',[], ...
             'mutilatedData',[],...
             'mutilatedField',[],...
             'cuttedIndices',[]...
             ),...
        'fitopt',struct(...
            'MaxIter',[],...
            'TolFun',[] ...
           ),...
        'routine','' ...
        ), ...
    'parameters',struct(...
        ), ...    
    'remarks',struct(...
        'purpose','' ...
        ),...
    'format',struct(...
        'name','TSim module', ...
        'version','0.5' ...
        ) ...
    );
dataStructure.TSim.remarks.comment = cell(0);
dataStructure.TSim.fit.fitini.fitparameters = cell(0);
dataStructure.TSim.sim.addsimpar = cell(0);

% Create trEPR toolbox data model (structure with field types as values)
dataModel = struct();
dataModel.calculated = 'ismatrix';
dataModel.TSim = struct(...
    'sim',struct(...
        'Sys',struct(...
            'S','isscalar',...
            'g','isvector',...
            'D','isvector'...
            ),...
        'Exp',struct(...
            'mwFreq','isscalar',...
            'Range','isvector',...
            'nPoints','isscalar',...
            'Harmonic','isscalar',...
            'Temperature','isvector',...
            'Ordering','isscalar'...
            ), ...
        'Opt',struct(...
            'nKnots','isvector',...
            'Method','isstring'...
            ),...
        'addsimpar','iscell',...
        'routine','isstring' ...
        ),...
    'fit',struct(...
        'inipar','isvector', ...
        'fittedpar','isvector', ...
        'fitini',struct(...
            'fitpar','isvector',...
            'tofit','islogical',...
            'lb','isvector', ...
            'ub','isvector', ...
            'fitparameters','iscell' ...
            ),...
        'fitcut',struct(...
             'cutpoints','ismatrix',...
             'mutilatedData','isvector',...
             'mutilatedField','isvector',...
             'cuttedIndices','isvector'...
             ),...
        'fitopt',struct(...
            'MaxIter','isscalar',...
            'TolFun','isscalar'...
           ),...
        'routine','isstring' ...
        ), ...
    'parameters',struct(...
        ), ...
    'remarks',struct(...
        'purpose','ischar',...
        'comment','iscell' ...
        ),...
    'format',struct(...
        'name','ischar', ...
        'version','ischar' ...
        ) ...
    );

if nargin && ischar(varargin{1})
    switch lower(varargin{1})
        case 'structure'
            if nargout
                varargout{1} = dataStructure;
            end
        case 'model'
            if nargout
                varargout{1} = dataModel;
            end
        case 'check'
            if nargin < 2
                fprintf('No structure to check...\n');
                return;
            end
            if ~isstruct(varargin{2})
                fprintf('%s has wrong type',inputname(2));
                return;
            end
            
            [missingFields,wrongType] = ...
                checkStructure(dataModel,varargin{2},inputname(2));

            if ~isempty(missingFields)
                fprintf('There are missing fields:\n');
                for k=1:length(missingFields)
                    fprintf('  %s\n',char(missingFields{k}));
                end
            end
            if ~isempty(wrongType)
                fprintf('There are fields with wrong type:\n');
                for k=1:length(wrongType)
                    fprintf('  %s\n',char(wrongType{k}));
                end
            end
            if isempty(missingFields) && isempty(wrongType)
                fprintf('Basic test passed! Structure seems fine...\n');
            end
            
            varargout{1} = missingFields;
            varargout{2} = wrongType;
            
        otherwise
            fprintf('Command ''%s'' unknown\n',varargin{1});
            return;
    end
else
    if nargout
        varargout{1} = dataStructure;
    end
end

end

function [missingFields,wrongType] = checkStructure(model,structure,name)
missingFields = cell(0);
wrongType = cell(0);
    function traverse(model,structure,parent)
        modelFieldNames = fieldnames(model);
        for k=1:length(modelFieldNames)
            if ~isfield(structure,modelFieldNames{k})
                missingFields{end+1} = ...
                    sprintf('%s.%s',parent,modelFieldNames{k}); %#ok<AGROW>
            else
                if isstruct(model.(modelFieldNames{k}))
                    if ~isstruct(structure.(modelFieldNames{k}))
                        wrongType{end+1} = ...
                            sprintf('%s.%s',parent,modelFieldNames{k}); %#ok<AGROW>
                    end
                    traverse(...
                        model.(modelFieldNames{k}),...
                        structure.(modelFieldNames{k}),...
                        [parent '.' modelFieldNames{k}]...
                        );
                else
                    functionHandle = str2func(model.(modelFieldNames{k}));
                    if ~functionHandle(structure.(modelFieldNames{k}))
                        if strcmp(model.(modelFieldNames{k}),'isscalar') || ...
                                strcmp(model.(modelFieldNames{k}),'isvector')
                            if isnumeric(structure.(modelFieldNames{k})) && ...
                                    isempty(structure.(modelFieldNames{k}))
                                return;
                            end
                        end
                        wrongType{end+1} = ...
                            sprintf('%s.%s',parent,modelFieldNames{k}); %#ok<AGROW>
                    end
                end
            end
        end
    end
traverse(model,structure,name);
end
