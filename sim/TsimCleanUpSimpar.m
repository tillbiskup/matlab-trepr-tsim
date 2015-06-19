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
% 2015-06-19


parameters = TsimParameters;
ParameterNames = parameters(:,1);
pepperpar =  cellfun(@(x)any(strcmpi(x,'pepper')),parameters(:,13));
pepperpar = ParameterNames(pepperpar);
tangopar =  cellfun(@(x)any(strcmpi(x,'tango')),parameters(:,13));
tangopar = ParameterNames(tangopar);

switch oldroutine
    case 'tango'
        % tango to pepper
        fields2beRemoved = setdiff(tangopar,pepperpar);
        
    case 'pepper'
        % pepper to tango
        fields2beRemoved = setdiff(pepperpar,tangopar);
        
end

for k=1:length(fields2beRemoved)
    if isfield(dataset.TSim.sim.simpar,fields2beRemoved(k))
        dataset.TSim.sim.simpar = rmfield(dataset.TSim.sim.simpar,fields2beRemoved(k));
    end
end



end
