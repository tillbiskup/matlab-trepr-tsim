
% (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-23


    
% Chose wether it shall be simulated or fitted
answer = cliMenu({'f','fit';'s','simulate'},'default','f','title',...
    'Do you wish to simulate or to fit?');

 display(answer);

if answer == 'f'
% %If fitting was chosen
% filename = input('Enter filename: ','s');
% 
% % The experimental data are loaded by the function <trEPRload>.
% data = trEPRload(filename);

% Get fitparameters
parameters = trEPRTSim_fitpar();
fitpar = parameters(:,1);
fitpardescription = parameters(:,3);
option = [fitpar fitpardescription];

%Chose fit parameters
answer = cliMenu(option,...
    'title','Please chose one or more fit parmeters',...
    'default','D, E, scale, lw','multiple',true);

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

% Hier käme: Display fittingoptions (lsqcurvefit, levenberg-marquardt, 
% Tolfun,... all die dinge werden momentan gar nicht genutzt, 
% number of iterations, maxiter)
% and simulation routine (pepper,...)

%Ask for changes
option = {'m','Change MaxIter';'i','Change number of iterations';'s','Change simulation routine';'f','Start fitting';'q','Quit'};
answer = cliMenu(option,'title',...
    'How to continue?','default','f');

display(answer);

% Hier käme: Fitting and nice pictures
% Ask how to continue
option = {'s','Save fitting and simulation parameters';'f','Fit again with fitted values as starting point';'b','start fit again from beginning';'i','start a simulation';'q','Quit'};
answer = cliMenu(option,'title',...
    'How to continue?','default','f');

display(answer);
else
    % Simulation was chosen
    % Hier käme: Initialize minimal simulation parameters trEPRTSim_simini 
    % und zeige Sie an, inklusive Werte

    % Werte ändern oder zahl der parametern ändern oder simulieren
    % Hier käme: Display all possible simulation parameters and the starting values
    % of the minimal set
    
    display('simulation was chosen');
end
