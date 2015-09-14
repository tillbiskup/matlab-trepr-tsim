function dataset = TsimChangeBoundary(dataset)
% TSIMCHANGEBOUNDARY Change boundaryvalues for parameters. If Parameter is 
% not inside boundary any mor it is changed.
%
% Usage
%   dataset = TsimChangeBoundary(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including Tsim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-09-14


% Find boundaries user has

FitParameters = dataset.Tsim.fit.fitpar;
FitParameterLb = dataset.Tsim.fit.lb;
FitParameterUb = dataset.Tsim.fit.ub;

changeloop = true;
while changeloop
    
    disp(' ');
    
    TsimParDisplay(dataset,'fit');
    
    disp(' ');
    
    prompt = 'Please enter parameter name whose boundaries you want to change (Enter for return)';
    answerstr = cliInput(prompt);
    
    if  isempty(answerstr)
        changeloop = false;
    else
        
        if ~any(strcmpi(answerstr, cellstr(FitParameters)))
            disp(' ');
            disp('Input not understood');
            disp(' ');
            changeloop = true;
        else
            match = strcmpi(answerstr, cellstr(FitParameters));
            DefaultValue = [FitParameterLb(match) FitParameterUb(match)];
            prompt = 'Please enter new boundaries: ';
            NewValues = cliInput(prompt,'default',num2str(DefaultValue),'numeric',true);
            dataset.Tsim.fit.lb(match) = NewValues(1);
            dataset.Tsim.fit.ub(match) = NewValues(2);
            
            dataset = TsimCheckBoundaries(dataset);
            
            changeloop = true;
        end
    end
end

end
