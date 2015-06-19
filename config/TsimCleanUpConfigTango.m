function config = TsimCleanUpConfigTango(config)
% TSIMCLEANUPCONFIGTango Test Userconfiguraton for not existing Parameters,
% MinSim and TangoIncompatibilities. If there were not all 
% minsimparameters in StandardSimulationParameter after Clean Up there are 
%
% Usage
%   config = TsimCleanUpConfigTango(config);
%
%   config - struct
%            Configuration structure from TsimConfigGet
%
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-03


parameters = TsimParameters;
ParameterNames = parameters(:,1);

% Load minimal set of Simulation parameters
minsim = logical(cell2mat(parameters(:,7)));
userpar = logical(cell2mat(parameters(:,9)));
tangopar =  cellfun(@(x)any(strcmpi(x,'tango')),parameters(:,13));
minsimuser = userpar & minsim & tangopar;

minsimparameters = parameters(minsimuser,1);


% Remove Overlaps
config.AdditionalSimulationParameters = removeFieldsInSecondThatAreInFirst(...
    config.StandardSimulationParameters,config.AdditionalSimulationParameters);

% Make config flat
FlatConfig = commonStructFlatten(config,'overwrite',false);

% Remove Fields that don't exist
% Get all possible Fieldnames
AllPoss = ParameterNames(userpar & tangopar);
FlatFieldnames = fieldnames(FlatConfig);
for k = 1:length(FlatFieldnames)
    if ~ismember(FlatFieldnames{k},AllPoss)
        
        Bigfieldnames = fieldnames(config);
        for l = 1:length(Bigfieldnames)
            
            if isfield(config.(Bigfieldnames{l}),FlatFieldnames{k})
                config.(Bigfieldnames{l}) = rmfield(config.(Bigfieldnames{l}),FlatFieldnames{k});
            end
            
        end
    end
end

% Is MinSim Parameter in config
FoundInConfig = minsimparameters(ismember(minsimparameters,fieldnames(FlatConfig)));

for k=1:length(FoundInConfig)
    Temp.(FoundInConfig{k}) = FlatConfig.(FoundInConfig{k});
end

% For MinsimParameters not found in Config Use defaultvalue
NotFoundInConfig = minsimparameters(~ismember(minsimparameters,fieldnames(FlatConfig)));

structParam = TsimParameters('struct',true);

for k=1:length(NotFoundInConfig)
    Temp.(NotFoundInConfig{k}) = structParam.(NotFoundInConfig{k}).standardvalue;
end

% Make Flat Temp config to normal config
Names = fieldnames(Temp);
for k = 1:length(Names)
config.StandardSimulationParameters.(Names{k}) = Temp.(Names{k});
end

% Check for EasySpin incompatibilities
[MoreThanMinsim, iconfigPar] = setdiff(fieldnames(config.StandardSimulationParameters),minsimparameters);
[~, Order]= sort(iconfigPar);
MoreThanMinsim = MoreThanMinsim(Order);

% Get EasySpin incompatibilities and Shift incompatible Parameters To
% AdditionalSimulation Part
Incompatibilities = parameters(:,12);
IncomParam1 = ParameterNames(~cellfun('isempty',Incompatibilities));

Winner = {};
for test = 1:length(MoreThanMinsim)
    if any(ismember(MoreThanMinsim(test),IncomParam1))
        index = ismember(IncomParam1,MoreThanMinsim(test));
        Winner = IncomParam1{index};
        break
    end
end

if ~isempty(Winner)
    AllKnowinStruct = TsimParameters('struct', true);
    FieldsToBeShifted = AllKnowinStruct.(Winner).notUseWith;
    
    for k=1:length(FieldsToBeShifted)
        if isfield(config.StandardSimulationParameters,FieldsToBeShifted{k})
            Value = commonGetCascadedField(config.StandardSimulationParameters,FieldsToBeShifted{k});
            config.StandardSimulationParameters = rmfield(config.StandardSimulationParameters,FieldsToBeShifted{k});
            config.AdditionalSimulationParameters.(FieldsToBeShifted{k}) = Value;
        end
    end
end

end

function second = removeFieldsInSecondThatAreInFirst(first,second)
% Remove Fields in Additional Parameters that are also in StandardParameters
Names=fieldnames(second);
overlap =Names(ismember(Names,fieldnames(first)));
second = rmfield(second,overlap);
end