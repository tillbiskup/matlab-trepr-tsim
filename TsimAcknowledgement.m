function Acknowledgement = TsimAcknowledgement(dataset)
% TSIMPARDISPLAY Display parameters for simulating and/or fitting
% triplet spectra with Tsim.
%
% Usage
%   TsimAcknowledgement(dataset);
%
%   dataset       - struct
%                   Full trEPR toolbox dataset including TSim structure
%
%  Acknowledgment - cell
%                   Contains acknowledgement for simulation routine 
%                        
%
% See also TSIM

% Copyright (c) 2013-15, Deborah Meyer, Till Biskup
% 2015-05-29

switch lower(dataset.TSim.sim.routine)
    case 'tango' 
        Acknowledgement = {...
            'If you''re using this routine for simulating your data,'...
            'please acknowledge the following people:'...
            ' ' ...
            'Stephan Rein and Sylwia Kacprzak' ...
            };
        
    case 'pepper'
        Acknowledgement = {...
            'If you''re using this routine for simulating your data,'...
            'please cite the publications you will find at:'...
            ' ' ...
            'http://www.easyspin.org/' ...
            };
end
end