function dataset = TsimChangeFitopt(dataset, keyword)
% TSIMCHANGEFITOPT Change parameters in fitopt.
%
%
% Usage
%   dataset = TsimChangeFitopt(dataset)
%
%   dataset   - struct
%               Full trEPR toolbox dataset including Tsim structure
%
%   keyword   - string
%               one of the following: MaxIter, MaxFunEval, TolFun
%
%

% Copyright (c) 2013-15, Deborah Meyer, Till Biskup
% 2015-09-14


% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addRequired('dataset',@isstruct);
parser.addRequired('keyword',@ischar);
parser.parse(dataset,keyword);


prompt = 'Please enter new value: ';
NewValue = cliInput(prompt,'default',num2str(dataset.Tsim.fit.fitopt.(keyword)),'numeric',true);
dataset.Tsim.fit.fitopt.(keyword) = NewValue;

end