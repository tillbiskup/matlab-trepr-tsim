function dataset = TsimChangeBoundary(dataset)
% TSIMCHANGEBOUNDARY Change boundaryvalues for parameters. If Parameter is 
% not inside boundary any mor it is changed.
%
% Usage
%   dataset = TsimChangeBoundary(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-11


% Find boundaries user has

FitParameters = dataset.TSim.fit.fitpar;
FitParameterLb = dataset.TSim.fit.lb;
FitParameterUb = dataset.TSim.fit.ub;

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
            dataset.TSim.fit.lb(match) = NewValues(1);
            dataset.TSim.fit.ub(match) = NewValues(2);
            
            dataset = TsimCheckBoundaries(dataset);
            
            changeloop = true;
        end
    end
end

end
