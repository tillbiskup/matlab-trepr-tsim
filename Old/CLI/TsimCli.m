% TSIMCLI CLI for simulating and fitting spin-polarized EPR spectra
% of triplets.
%
% Integral part of the TSim module of the trEPR toolbox.

% Copyright (c) 2013, Deborah Meyer, Till Biskup
% 2013-12-16

% For the time being, erase everything in the workspace... (quite rude)
clear all; close all;

% Check for dependencies
[status, missing] = TsimDependency();
if (status == 1)
     disp('There are files missing required for the fit:');
     cellfun(@disp, missing);
    return
else
    % Remove unwanted variables from workspace
    clear status missing
end

% Is there already a dataset, that shall be loaded
answer = cliMenu({'y','Yes';'n','No';'q','Quit'},'default','n','title',...
    'Do you wish to load an existing dataset');

switch answer
    case 'y'
         loaddatasetloop = true;
       % Load dataset
       while loaddatasetloop
           
           disp(' ');
          datasetname = '';
           while isempty(datasetname)
               datasetname = input(sprintf('%s\n%s',...
                   'Please enter the name of the dataset',...
                   'you wish to load (''q'' to quit): '),'s');
               if strcmpi(datasetname,'q')
                   % Quit
                   command = 'exit';
                   disp('Goodbye!');
                   return;
               end
               
               if ~exist(datasetname,'file')
                   fprintf('\nFile "%s" not found. Please try again\n\n',...
                       datasetname);
                   datasetname = '';
               end
           end
           
           % Load dataset using <trEPRTload>
           [dataset, warnings] = trEPRload(datasetname);
           if size(warnings)
               loaddatasetloop = true;
           else
               loaddatasetloop = false;
           end
           
           clear warnings
       end % loaddatasetloop
      
    case 'n'
        % do nothing;
    case 'q'
        disp('Goodbye!');
        return;
    otherwise
        % Shall never happen
        action = '';
end

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
            if exist('dataset','var')
                if exist('command','var')
                    [dataset,command] = TsimCli_fit(dataset,command);
                else
                    [dataset,command] = TsimCli_fit(dataset);
                end
            else
                [dataset,command] = TsimCli_fit();
            end
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
                    [dataset,command] = TsimCli_sim(dataset,command);
                else
                    [dataset,command] = TsimCli_sim(dataset);
                end
            else
                [dataset,command] = TsimCli_sim();
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

