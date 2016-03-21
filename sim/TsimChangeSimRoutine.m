function dataset = TsimChangeSimRoutine(dataset)
% TSIMCHANGESIMROUTINE changes simulation routine in Tsim structure
%
% Usage
%   dataset = TsimChangeSimRoutine(dataset)
%
%
%   dataset - struct
%             Full trEPR toolbox dataset including Tsim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-09-22

option ={...
    'p','Pepper';...
    't','Tango';...
    'b', 'Bachata'};
answer = cliMenu(option,'title',...
    'Please chose a simulation routine','default','p');

switch lower(answer)
    case 'p'
        dataset.Tsim.sim.routine = 'pepper';
    case 't'
        dataset.Tsim.sim.routine = 'tango';
    case 'b'
        dataset.Tsim.sim.routine = 'bachata';
end

dataset.Tsim.acknowledgement.sim = TsimAcknowledgement(dataset);

disp(' ');
disp('**********************************************************');
disp('**********************************************************');
disp('**                    DISCLAIMER                        **');
disp('**********************************************************');
disp('**********************************************************');
disp('**');
cellfun(@(x)disp(['** ' x]),dataset.Tsim.acknowledgement.sim);
disp('**');
disp('**********************************************************');
disp('**********************************************************');
disp(' ');


end