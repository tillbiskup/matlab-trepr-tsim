function dataset = TsimChangeSimRoutine(dataset)
% TSIMCHANGESIMROUTINE changes simulation routine in TSim structure
%
% Usage
%   dataset = TsimChangeSimRoutine(dataset)
%
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TREPRTSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-05-29


disp('The simulation routines currently implemented:')
disp(' ');
option ={...
    'p','Pepper';...
    's','Stephan'};
answer = cliMenu(option, 'default','p');
switch lower(answer)
    case 'p'
        dataset.TSim.sim.routine = 'pepper';
    case 's'
        disp(' ');
        disp('Sorry not implemented. Pepper will be used instead.')
        disp(' ');
        dataset.TSim.sim.routine = 'pepper';
end
end