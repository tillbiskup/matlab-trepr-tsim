function dataset = TsimChangeSimValues(dataset,varargin)
% TSIMCHANGESIMVALUES changes values for the parameters in simpar structure.
%
% Usage
%   dataset = TsimChangeSimValues(dataset)
%
%
%   dataset -  struct
%              Full trEPR toolbox dataset including TSim structure
% 
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-07-06

changeloop = true;
while changeloop
    
    SimulationParameters = fieldnames(dataset.TSim.sim.simpar);
    SimulationParameterValues = struct2cell(dataset.TSim.sim.simpar);
    
    disp(' ');
    
    TsimParDisplay(dataset,'sim');
    
    disp(' ');
    
    prompt = 'Please enter parameter name whose value you want to change (Enter for return)';
    answerstr = cliInput(prompt);
    
    if  isempty(answerstr)
        changeloop = false;
    else
        
        if ~any(strcmpi(answerstr, cellstr(SimulationParameters)))
            disp(' ');
            disp('Input not understood');
            disp(' ');
            changeloop = true;
        else
            match = strcmpi(answerstr, cellstr(SimulationParameters));
            DefaultValue = SimulationParameterValues(match);
            Name = SimulationParameters{match};
            prompt = 'Please enter new value: ';
            
            if strcmp(Name,'InterpolB0')
                NewValue = cliInput(prompt,'default',cell2mat(DefaultValue),'numeric',false);
            else
                NewValue = cliInput(prompt,'default',num2str(cell2mat(DefaultValue)),'numeric',true);
            end
            
            dataset.TSim.sim.simpar.(Name) = NewValue;
            
            % Apply conventions
            dataset = TsimApplyConventions(dataset,'populations',false);
            
            changeloop = true;
        end
    end
end
dataset = TsimApplyConventions(dataset);
end

