
% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-23


% Chose wether it shall be simulated or fitted
answer = cliMenu({'f','Fit';'s','Simulate'},'default','f','title',...
    'Do you wish to simulate or to fit?');

switch answer
    case 'f'
        action = 'fit';
    case 's'
        action = 'sim';
    otherwise
        % Shall never happen
        action = '';
end


display(answer);

outerloop = true;
while outerloop
    
    switch lower(action)
        case {'fit','f'}
            fitouterloop = 1;
            % fitting was chosen
            % filename = input('Enter filename: ','s');
            %
            % The experimental data are loaded by the function <trEPRload>.
            % data = trEPRload(filename);
            while fitouterloop == 1
                
                fitiniloop = true;
                while fitiniloop == 1
                    % Get fitparameters
                    parameters = trEPRTSim_fitpar();
                    fitpardescription = parameters(:,3);
                    option = [strtrim(cellstr(num2str((1:length(fitpardescription))'))) fitpardescription];
                    
                    
                    %Chose fit parameters
                    answer = cliMenu(option,...
                        'title','Please chose one or more fit parameters',...
                        'default','1, 2, 6, 7','multiple',true);
                    
                    
                    display(answer);
                    
                    %Hier käme:Display chosen fittingparameters with values, upper and lower bounderies
                    % Baue tofit
                    
                    %Ask for different things
                    option = {...
                        'p','Fit different parameters';...
                        'v','Change starting values and/or boundary values';...
                        'c','Continue';...
                        'q','Quit'};
                    answer = cliMenu(option,'title',...
                        'How to continue?','default','c');
                    
                    display(answer);
                    
                    switch lower(answer)
                        case 'p'
                            % Parameters
                            fitiniloop = 1;
                        case 'c'
                            % Continue
                            fitiniloop = 0;
                        case 'q'
                            % Quit
                            return;
                        otherwise
                            % Shall never happen
                            disp('booo!');
                    end
                end
                
                fitloop = 1;
                while fitloop == 1
                    
                    fitoptionloop = 1;
                    while fitoptionloop == 1
                        % Hier käme: Display fittingoptions (lsqcurvefit, levenberg-marquardt,
                        % Tolfun,... all die dinge werden momentan gar nicht genutzt,
                        % number of iterations, maxiter)
                        % and simulation routine (pepper,...)
                        
                        %Ask for changes
                        option = {...
                            'm','Change MaxIter';...
                            'i','Change number of iterations';...
                            's','Change simulation routine';...
                            'f','Start fitting';...
                            'q','Quit'};
                        answer = cliMenu(option,'title',...
                            'How to continue?','default','f');
                        
                        display(answer);
                        
                        switch lower(answer)
                            case 'm'
                                % Change MaxIter
                                fitoptionloop = 1;
                            case 'i'
                                fitoptionloop = 1;
                            case 's'
                                fitoptionloop = 1;
                            case 'f'
                                fitoptionloop = 0;
                            case 'q'
                                % Quit
                                return;
                            otherwise
                                disp('WTF!');
                        end
                        
                    end
                    
                    % Hier käme: Fitting and nice pictures
                    % Ask how to continue
                    option = {...
                        'a','Save fitting and simulation parameters';...
                        'f','Fit again with fitted values as starting point';...
                        'n','Start new fit from beginning';...
                        's','Start a simulation';...
                        'q','Quit'};
                    answer = cliMenu(option,'title',...
                        'How to continue?','default','f');
                    
                    display(answer);
                    
                    switch lower(answer)
                        case 'q'
                            % quit
                            return;
                        case 'f'
                            % Fit again
                            fitloop = true;
                        case 'n'
                            % New fit
                            fitloop = false;
                        case 's'
                            % Simulation (with fit values as starting point)
                            fitouterloop = false;
                            action = 'sim';
                            break;
                        otherwise
                            % Shall never happen
                            disp('you did bullshit... however you managed');
                    end
                    
                end
                
            end
            
            display(answer);
            
        case {'sim','s'}
            
            simouterloop = true;
            while simouterloop == 1
                
                % Simulation was chosen
                % Hier käme: Initialize minimal simulation parameters trEPRTSim_simini
                
                siminiloop = true;
                while siminiloop == 1
                    
                    % Zeige simulationsparameter, inklusive Werte an
                    % Werte ändern oder zahl der parametern ändern oder simulieren
                    option ={...
                        'v','Change values of chosen simulation parameters';...
                        'p','Choose different simulation parameters';...
                        's','Start simulation';...
                        'q','Quit'};
                    answer = cliMenu(option, 'default','s');
                    % Hier käme: Display all possible simulation parameters and the starting values
                    % of the minimal set
                    
                    display(answer);
                    
                    switch lower(answer)
                        case 'q'
                            % Quit
                            return;
                        case 'v'
                            % Change values
                            siminiloop = 1;
                        case 'p'
                            % Change parameters
                            siminiloop = 1;
                        case 's'
                            % Simulate
                            siminiloop = 0;
                        otherwise
                            % Shall never happen
                            disp('Moron!');
                    end
                    
                end
                
                % Hier wird simuliert
                
                option = {...
                    'a','Save simulation parameters';...
                    'n','Start a new simulation';...
                    'f','Start a fit';...
                    'q','Quit'};
                answer = cliMenu(option,'title',...
                    'How to continue?','default','q');
                
                display(answer)
                
                switch lower(answer)
                    case 'q'
                        % quit
                        return;
                    case 'n'
                        % New simulation
                        simouterloop = 1;
                    case 's'
                        % Save simulation
                        simouterloop = 1;
                    case 'f'
                        % Start fit
                        action = 'fit';
                        simouterloop = false;
                    otherwise
                        % Shall never happen
                        simouterloop = true;
                end
                
            end
            
    end
    
end



