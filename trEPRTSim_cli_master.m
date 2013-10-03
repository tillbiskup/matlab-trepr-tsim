% TREPRTSIM_CLI CLI for simulating and fitting spin-polarized EPR spectra
% of triplets.
%
% Integral part of the TSim module of the trEPR toolbox.

% (c) 2013, Deborah Meyer, Till Biskup
% 2013-10-03

% For the time being, erase everything in the workspace... (quite rude)
clear all; close all;

% Check for dependencies
[status, missing] = trEPRTSim_dependency();
if (status == 1)
     disp('There are files missing required for the fit:');
     cellfun(@disp, missing);
    return
else
    % Remove unwanted variables from workspace
    clear status missing
end

% % Read initial values from config file
% conf = trEPRTSim_conf;

% Chose wether it shall be simulated or fitted
answer = cliMenu({'f','Fit';'s','Simulate';'q','Quit'},'default','f','title',...
    'Do you wish to simulate or to fit?');

switch answer
    case 'f'
        action = 'fit';
    case 's'
        action = 'sim';
    case 'q'
        disp('Goodbye!');
        return;
    otherwise
        % Shall never happen
        action = '';
end

outerloop = true;
while outerloop
    switch lower(action)
        case {'fit','f'}
            [dataset,command] = trEPRTSim_cli_fit();
            switch lower(command)
                case 'exit'
                    outerloop = false;
                case 'sim'
                    action = 'sim';
                otherwise
            end
        case {'sim','s'}
            if exist('dataset','var')
                if exist('command','var')
                    [dataset,command] = trEPRTSim_cli_sim(dataset,command);
                else
                    [dataset,command] = trEPRTSim_cli_sim(dataset);
                end
            else
                [dataset,command] = trEPRTSim_cli_sim();
            end
            switch lower(command)
                case 'exit'
                    outerloop = false;
                case 'fit'
                    action = 'fit';
                otherwise
            end
    end
end

% Remove unnecessary variables from workspace
clear action answer command outerloop

