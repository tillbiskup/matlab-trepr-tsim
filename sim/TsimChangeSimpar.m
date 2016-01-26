function dataset = TsimChangeSimpar(dataset, varargin)
% TSIMCHANGESIMPAR Change (add and remove) parameters from the simpar
% structure. Varargin can be the name(s) of parameter that should be added.
% This means the user is no userinteraction. If parameter colides with
% easyspin incompatibilities it is not added.
%
% Usage
%   dataset = TsimChangeSimpar(dataset)
%
%
%   dataset - struct
%             Full trEPR toolbox dataset including Tsim structure
%
%   varargin - string
%              name of parameterst to ADD to simpar. 
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-09-14

Temp = CreateTemporaryParameterStruct(dataset);

if ~isempty(varargin)
    old = fieldnames(dataset.Tsim.sim.simpar);
    varas = varargin{1};
    
    for k=1:length(varas)
        add(k) = varas(k);
    end

    NewUserSimulationParameters = [old;add'];
    
    Bol = TestFunction(NewUserSimulationParameters);
    if any(Bol)
        disp('Parameter(s) could not be added.')
        return
    end
else
    parameters = TsimParameters;
    ParameterNames = parameters(:,1);
    minsim = logical(cell2mat(parameters(:,7)));
    userpar = logical(cell2mat(parameters(:,9)));
    pepperpar =  cellfun(@(x)any(strcmpi(x,'pepper')),parameters(:,13));
    tangopar =  cellfun(@(x)any(strcmpi(x,'tango')),parameters(:,13));

    routine = dataset.Tsim.sim.routine;
    
    switch routine
        case 'pepper'
            minsimuser = userpar & minsim & pepperpar;
        case 'tango'
            minsimuser = userpar & minsim & tangopar;
    end
    
    
    MinSimParameters = ParameterNames(minsimuser);
    
    
    % Find simulationparameters user already has in simpar this is needed for
    % default
    OldUserSimulationParameters = fieldnames(dataset.Tsim.sim.simpar);
    
    % all possible simparameters for user
    allsimpar = logical(cell2mat(parameters(:,6)));
     switch routine
        case 'pepper'
            allsimuser = userpar & allsimpar & pepperpar;
        case 'tango'
           allsimuser = userpar & allsimpar & tangopar;
    end
    
    PossibleUserSimulationParameterNames = ParameterNames(allsimuser);
    
    
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
        
        Bol = TestFunction(NewUserSimulationParameters);
        
        % Test for Incompatibilies
        if any(Bol)
            disp(' ');
            disp('You cannot use strains together with ordering.');
            disp('You cannot use g-strains together with D- or E-strains.');
            disp(' ');
            chooseloop = true;
        else
            chooseloop = false;
            % Test for MinSim and Add missing Parameters
            if ~isempty(setdiff(MinSim, NewUserSimulationParameters))
                disp(' ');
                disp('Additional missing parameters have been selected.');
                disp(' ');
                Missing = setdiff(MinSim, NewUserSimulationParameters);
                NewUserSimulationParameters = [NewUserSimulationParameters;Missing];
            end
        end
    end
    
end
% Add new Parameters (NewUserSimulationParameters) and values from
% TempStruct to simpar

for k=1:length(NewUserSimulationParameters)
    simpar.(NewUserSimulationParameters{k}) = Temp.(NewUserSimulationParameters{k});
end

dataset.Tsim.sim.simpar = simpar;

end

    function Bol = TestFunction(NewUserSimulationParameters)
        % Get EasySpin incompatibilities
        parameters = TsimParameters;
        ParameterNames = parameters(:,1);
        Incompatibilities = parameters(:,12);
        
        for inc = 1:length(Incompatibilities)
            indexInc(inc) = ~isempty(Incompatibilities{inc});
        end
        IncomParam1 = ParameterNames(indexInc);
        IncomParam2 = Incompatibilities(indexInc);
        
        for test = 1:length(IncomParam1)
            Bol(test) = any(ismember(IncomParam1(test),NewUserSimulationParameters) && any(ismember(IncomParam2{test},NewUserSimulationParameters)));
        end
        
    end


function Temp = CreateTemporaryParameterStruct(dataset)
Temp = dataset.Tsim.sim.simpar;

% Find AdditionalSimulatioParameters and theire Values
% Value is from Config. If there is no value theire Value is from Standard

routine = dataset.Tsim.sim.routine;
% all possible simparameters for user
parameters = TsimParameters;
ParameterNames = parameters(:,1);
userpar = logical(cell2mat(parameters(:,9)));
allsimpar = logical(cell2mat(parameters(:,6)));
pepperpar =  cellfun(@(x)any(strcmpi(x,'pepper')),parameters(:,13));
tangopar =  cellfun(@(x)any(strcmpi(x,'tango')),parameters(:,13));
switch routine
    case 'pepper'
        allsimuser = userpar & allsimpar & pepperpar;
    case 'tango'
        allsimuser = userpar & allsimpar & tangopar;
end
allsimuser = ParameterNames(allsimuser);

% Additional Parameters
AdditionalParameters = setdiff(allsimuser,fieldnames(dataset.Tsim.sim.simpar));

% Values for additional Parameters
% Is Parameter in config
config = TsimConfigGet('parameters');
FlatConfig = commonStructFlatten(config,'overwrite',false);
FoundInConfig = AdditionalParameters(ismember(AdditionalParameters,fieldnames(FlatConfig)));

for k=1:length(FoundInConfig)
    Temp.(FoundInConfig{k}) = FlatConfig.(FoundInConfig{k});
end

% For Parameters not found in Config Use defaultvalue
NotFoundInConfig = AdditionalParameters(~ismember(AdditionalParameters,fieldnames(FlatConfig)));

structParam = TsimParameters('struct',true);

for k=1:length(NotFoundInConfig)
    Temp.(NotFoundInConfig{k}) = structParam.(NotFoundInConfig{k}).standardvalue;
end

end
