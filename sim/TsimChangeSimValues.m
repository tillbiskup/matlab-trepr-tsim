function dataset = TsimChangeSimValues(dataset)
% TSIMCHANGESIMVALUES changes values for the parameters in simpar structure.
%
% Usage
%   dataset = TsimChangeSimValues(dataset)
%
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-05-29



% Find simulationparameters user already has in simpar

SimulationParameters = fieldnames(dataset.TSim.sim.simpar);
SimulationParameterValues = struct2cell(dataset.TSim.sim.simpar);


changeloop = true;
while changeloop
    
    disp(' ');
    
    TsimParDisplay(dataset,'sim');
    
    disp(' ');
    
    prompt = 'Please enter parameter name whose value you want to change (q for Quit)';
    answerstr = cliInput(prompt);
    
    if  strcmpi('q', answerstr)
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
            NewValue = cliInput(prompt,'default',num2str(cell2mat(DefaultValue)),'numeric',true);
            dataset.TSim.sim.simpar.(Name) = NewValue;
            
            % Apply conventions
            dataset = TsimApplyConventions(dataset);
            
            changeloop = true;
        end
    end
end

 