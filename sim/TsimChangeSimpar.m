function dataset = TsimChangeSimpar(dataset)
% TSIMCHANGESIMPAR Change (add and remove) parameters from the simpar
% structure. 
%
% Usage
%   dataset = TsimChangeSimpar(dataset)
%
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-05-29


% TODO Read configuration to see if the added parameter is in configuration
% and has a value there...

parameters = TsimParameters;
ParameterNames = parameters(:,1);
StandardParameterValues = parameters(:,10);

minsim = logical(cell2mat(parameters(:,7)));
userpar = logical(cell2mat(parameters(:,9)));    
minsimuser = userpar & minsim;
    
MinSimParameters = ParameterNames(minsimuser);


% Find simulationparameters user already has in simpar this is needed for
% default
% Parameter and values user wants
OldUserSimulationParameters = fieldnames(dataset.TSim.sim.simpar);
OldUserSimulationParameterValues = struct2cell(dataset.TSim.sim.simpar);


% all possible simparameters for user
allsimpar = logical(cell2mat(parameters(:,6)));
allsimuser = userpar & allsimpar;

PossibleUserSimulationParameterNames = ParameterNames(allsimuser);
PossibleUserSimulationParameterStandardValues = StandardParameterValues(allsimuser);
% TODO Read configuration to see if the added parameter is in configuration
% and has a value there... so mix with standardvalue

% Find default indices
Lia = ismember(PossibleUserSimulationParameterNames, OldUserSimulationParameters);
indexLia = 1:length(PossibleUserSimulationParameterNames);
indexLia = indexLia(Lia);

% Create Default
defaultPar = num2str(indexLia);

chooseloop = true;
while chooseloop
    
    option = [ ...
        strtrim(cellstr(num2str((1:length(PossibleUserSimulationParameterNames))')))...
        (PossibleUserSimulationParameterNames) ...
        ];
    
    answer = cliMenu(option,...
        'title','Please chose simulation parameters',...
        'default',defaultPar,'multiple',true);
    
    % Check if answer includes minsim... Give out warning and let user choose again.
    MinSim = cellstr(MinSimParameters);
    Big=cellstr(PossibleUserSimulationParameterNames);
    NewUserSimulationParameters=Big(str2double(answer));
    
    
    
    % Get EasySpin incompatibilities
    Incompatibilities = parameters(:,12);
    
    for inc = 1:length(Incompatibilities)
        indexInc(inc) = ~isempty(Incompatibilities{inc});
    end
    IncomParam1 = ParameterNames(indexInc);
    IncomParam2 = Incompatibilities(indexInc);
    
    for test = 1:length(IncomParam1)
        Bol(test) = any(ismember(IncomParam1(test),NewUserSimulationParameters)) && any(ismember(IncomParam2{test},NewUserSimulationParameters));
    end
    
    
    % Test for MinSim
    if ~isempty(setdiff(MinSim, NewUserSimulationParameters))
        disp(' ');
        disp('You need to choose more parameters');
        disp(' ');
        chooseloop = true;
    else
        %Test for Incopatibilities
        if any(Bol)
            disp(' ');
            disp('You cannot use g-strains together with D- or E-strains');
            disp(' ');
            chooseloop = true;
        else
            chooseloop = false;
        end
    end
    
    
    
end


% Add new Parameters and values (FOR NOW THE STANDARDVALUES)
% Find overlapp with oldparameters to contain their values

Lia = ismember(OldUserSimulationParameters, NewUserSimulationParameters);
OldUserSimulationParameters = OldUserSimulationParameters(Lia);
OldUserSimulationParameterValues = OldUserSimulationParameterValues(Lia);


[NewUserSimulationParameters, iNewUser] = setdiff(NewUserSimulationParameters, OldUserSimulationParameters);

NewUserSimulationParameterStandardValues = PossibleUserSimulationParameterStandardValues(str2double(answer));
NewUserSimulationParameterStandardValues = NewUserSimulationParameterStandardValues(iNewUser);

simparameters = [OldUserSimulationParameters; NewUserSimulationParameters];
simparametervalues = [OldUserSimulationParameterValues; NewUserSimulationParameterStandardValues];
simpar = cell2struct(simparametervalues, simparameters,1);

% Put it in dataset
dataset.TSim.sim.simpar = simpar;

end
