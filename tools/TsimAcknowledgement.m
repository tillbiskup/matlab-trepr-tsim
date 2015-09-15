function acknowledgement = TsimAcknowledgement(dataset)
% TSIMACKNOWLEDGEMENT Return acknowledgements for simulation routine
% depending on the routine chosen.
%
% Usage
%   acknowledgement = TsimAcknowledgement(dataset);
%
%   dataset        - struct
%                    Full trEPR toolbox dataset including Tsim structure
%
%   acknowledgment - cell
%                    Contains acknowledgement for simulation routine 
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-09-15

switch lower(dataset.Tsim(1).sim.routine)
    case 'tango' 
        acknowledgement = {...
            'If you''re using this routine for simulating your data,'...
            'please acknowledge the following people:'...
            ' ' ...
            'Stephan Rein and Sylwia Kacprzak' ...
            };
        
    case 'pepper'
        acknowledgement = {...
            'If you''re using this routine for simulating your data,'...
            'please cite the publications you will find at:'...
            ' ' ...
            'http://www.easyspin.org/' ...
            };
end

end