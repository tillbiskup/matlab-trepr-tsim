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
% See also TREPRTSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-05-29



% Find simulationparameters user already has in simpar

SimulationParameters = fieldnames(dataset.TSim.sim.simpar);
SimulationParameterValues = struct2cell(dataset.TSim.sim.simpar);


changeloop = true;
while changeloop
    
    disp(' ');
    
    trEPRTSim_parDisplay(dataset,'sim');
    
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
            
            % Chek for things
            if isfield(dataset.TSim.sim.simpar,'p1') && isfield(dataset.TSim.sim.simpar,'p2') && isfield(dataset.TSim.sim.simpar,'p3')
                [normalized] = trEPRTSim_Pnormalizer([(dataset.TSim.sim.simpar.p1) (dataset.TSim.sim.simpar.p2) (dataset.TSim.sim.simpar.p3)]);
                
                dataset.TSim.sim.simpar.p1 = normalized(1);
                dataset.TSim.sim.simpar.p2 = normalized(2);
                dataset.TSim.sim.simpar.p3 = normalized(3);
                
            end
            
            % D and E should follow the convention E <= 1/3 D
            if isfield(dataset.TSim.sim.simpar,'D') && isfield(dataset.TSim.sim.simpar,'E')
                
                converted = trEPRTSim_DandEconverter(trEPRTSim_DandEconverter([dataset.TSim.sim.simpar.D dataset.TSim.sim.simpar.E]));
                
                dataset.TSim.sim.simpar.D = converted(1);
                dataset.TSim.sim.simpar.E = converted(2);
                
            end
            
            changeloop = true;
        end
    end
end

 