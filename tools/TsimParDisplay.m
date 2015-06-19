function TsimParDisplay(dataset,command,varargin)
% TSIMPARDISPLAY Display parameters for simulating and/or fitting
% triplet spectra with Tsim.
%
% Usage
%   TsimSimini(dataset,<command>);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
%   command - string
%             one of 'sim', 'fit', 'opt', fitreport
%             'sim'      - display simulation parameters currently
%                          initialized, including their value (shows simpar)
%
%             'fit'      - display fit parameters currently initialized
%                          including values, lower and upper boundaries    
%
%             'opt'      - display additional fit parameters currently initialized,
%
%             'fitreport - display simulation parameters and  fitparameters 
%                          with initial values, boundaries and final values    
%                        
%
%
% See also TSIM

% Copyright (c) 2013-15, Deborah Meyer, Till Biskup
% 2015-05-29

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addRequired('dataset',@isstruct);
parser.addRequired('command',@ischar);
parser.parse(dataset,command,varargin{:});


switch lower(command)
    
    case 'sim'
        % Display simpar
        % TODO Can be made nicer with loading the parameters and displaying the
        % propper name (with description) instead of the internal name
        disp({'Simulation rotine:' dataset.TSim.sim.routine});
        
        disp(' ')
       
        disp(dataset.TSim.sim.simpar);
        
    case 'fit'
        % Display fitpar, initialvalues, lb and ub
        disp(dataset.TSim.fit.fitpar');
        disp(dataset.TSim.fit.lb);
        disp(dataset.TSim.fit.initialvalue);
        disp(dataset.TSim.fit.ub);
        
    case 'opt'
        disp(dataset.TSim.fit.fitopt);
        disp(' ')
        
        disp('Defined regions for weighting:')
        
        disp(' ')
       
        disp(dataset.TSim.fit.weighting.weightingArea)
        
        disp(' ')
        
    case 'fitreport'
        % Display simpar
        % TODO Can be made nicer with loading the parameters and displaying the
        % propper name (with description) instead of the internal name
        disp('Simulation parameters for final simulation')
        
        disp(' ')
        
        disp(dataset.TSim.sim.simpar);
        
        disp(' ')
        
        disp('Fit parameters: lower boundary, initialvalue, upper boundary')
        
        disp(' ')
        
        % Display fitpar, initialvalues, lb ub, and finalvalues
        disp(dataset.TSim.fit.fitpar');
        disp(dataset.TSim.fit.lb);
        disp(dataset.TSim.fit.initialvalue);
        disp(dataset.TSim.fit.ub);
        
        disp(' ')
        
        disp('Fit parameters: final values (not normalized)')
        
        disp(' ')
        
        disp(dataset.TSim.fit.finalvalue);
         
        disp(' ')
        
        disp('Fit parameters: standard deviation')
        
        disp(' ')
        
        disp((dataset.TSim.fit.report.stdDev)');
        
        disp(' ')
    otherwise
        disp('Booo!');
        return;
end

end