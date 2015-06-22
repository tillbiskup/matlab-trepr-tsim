function dataset = TsimCleanUpSimpar(dataset, oldroutine)
% TSIMCLEANUPSIMPAR Possibly remove parameters from the simpar
% structure. 
%
% Usage
%   dataset = TsimChangeSimpar(dataset)
%
%
%   dataset    - struct
%                Full trEPR toolbox dataset including TSim structure
%
%   oldroutine - string
%                name of oldroutine. 
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-22


parameters = TsimParameters;
ParameterNames = parameters(:,1);
pepperpar =  cellfun(@(x)any(strcmpi(x,'pepper')),parameters(:,13));
pepperparnames = ParameterNames(pepperpar);
tangopar =  cellfun(@(x)any(strcmpi(x,'tango')),parameters(:,13));
tangoparnames = ParameterNames(tangopar);
minsim = logical(cell2mat(parameters(:,7)));
userpar = logical(cell2mat(parameters(:,9)));

switch oldroutine
    case 'tango'
        % tango to pepper
        fields2beRemoved = setdiff(tangoparnames,pepperparnames);
        fields2beAdded = ParameterNames(minsim & pepperpar & userpar);

    case 'pepper'
        % pepper to tango
        fields2beRemoved = setdiff(pepperparnames,tangoparnames);
        fields2beAdded = ParameterNames(minsim & tangopar & userpar);
        
end

for k=1:length(fields2beRemoved)
    if isfield(dataset.TSim.sim.simpar,fields2beRemoved{k})
        dataset.TSim.sim.simpar = rmfield(dataset.TSim.sim.simpar,fields2beRemoved{k});
    end
end

parameterstruct = TsimParameters('struct',true);

for k= 1:length(fields2beAdded)
    if ~isfield(dataset.TSim.sim.simpar,fields2beAdded{k})
        dataset.TSim.sim.simpar.(fields2beAdded{k}) = parameterstruct.(fields2beAdded{k}).standardvalue;
    end
end

end
