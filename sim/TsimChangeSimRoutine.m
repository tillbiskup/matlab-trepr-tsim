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
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-19

option ={...
    'p','Pepper';...
    't','Tango'};
answer = cliMenu(option,'title',...
    'Please chose a simulation routine','default','p');

switch lower(answer)
    case 'p'
        dataset.TSim.sim.routine = 'pepper';
    case 't'
        dataset.TSim.sim.routine = 'tango';
end

dataset.TSim.acknowledgement.sim = TsimAcknowledgement(dataset);

disp(' ');
disp('**********************************************************');
disp('**********************************************************');
disp('**                    DISCLAIMER                        **');
disp('**********************************************************');
disp('**********************************************************');
disp('**');
cellfun(@(x)disp(['** ' x]),dataset.TSim.acknowledgement.sim);
disp('**');
disp('**********************************************************');
disp('**********************************************************');
disp(' ');


end