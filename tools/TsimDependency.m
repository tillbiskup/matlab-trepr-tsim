function [status, missing] = TsimDependency()
% TSIMDEPENDECY Check for dependencies necessary for simulation.
%
% Usage
%   [status, missing] = TsimDependency()
%
%   status  - scalar
%             0 if everything is fine, 1 otherwise
%
%   missing - cell array
%             names of missing functions
%
% See also TSIM

% Copyright (c) 2013, Deborah Meyer, Till Biskup
% 2013-08-06

% List of necessary functions
dep = {...
    'lsqcurvefit',...
    'pepper',...
    'trEPRload'...
    };

% Preset return variables
status = 0;
missing = cell(0);

% Check dependencies
check = cellfun(@(x)~exist(x, 'file'), dep);

if ~nargout
    if any(check)
        disp('There are files missing:');
        missing = dep(check);
        cellfun(@disp, missing);
    else
        disp('Everything seems fine.');
    end
else
    if any(check)
        status = 1;
        missing = dep(check);
    end
end

end