function [dataset, siminiloop, quit] = TsimIniSimCli(dataset)
% TSIMINISIMCLI Cli used by sim and fit part to initialize simparameters.
%
% Usage
%   [dataset, siminiloop, quit] = TsimChangeSimValues(dataset)
%
%
%   dataset    -  struct
%                 Full trEPR toolbox dataset including TSim structure
% 
%   siminiloop - boolean
%                
%   quit       - boolean
% 
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-15




quit = false;
disp(' ');

% Display current set of simulation parameters with
% their values
disp('The simulation parameters currently chosen:')

disp(' ');

TsimParDisplay(dataset,'sim');

disp(' ');

% Change values, numbers of simulation parameters, or start
% simulation (changing simulation routine not implemented yet)
option ={...
    'v','Change values of chosen simulation parameters';...
    'p','Choose different/additional simulation parameters';...
    'r','Change simulation routine';...
    'c','Continue';...
    'q','Quit'};
answer = cliMenu(option,'default','c');

disp(' ');

switch lower(answer)
    case 'v'
        % Change values
        dataset = TsimChangeSimValues(dataset);
        siminiloop = true;
    case 'p'
        % Choose different simulation parameters
        dataset = TsimChangeSimpar(dataset);
        siminiloop = true;
    case 'r'
        % Change simulation routine
        dataset = TsimChangeSimRoutine(dataset);
        siminiloop = true;
    case 'q'
        % Quit
        quit = true;
        siminiloop = false;
        return;
    case 'c'
        % Continue
        siminiloop = false;
        return;
    otherwise
        % Shall never happen
        disp('Moron!');
end
end
