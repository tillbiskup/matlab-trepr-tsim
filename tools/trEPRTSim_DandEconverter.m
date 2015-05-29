function [converted] = trEPRTSim_DandEconverter(unconverted)
% TREPRTSIM_DANDECONVERTER Converts D and E in principal values of the D
% Tensor or the other way round. It makes sure that the convention E <= D/3
% is followed.
%
% Usage
%   [converted] = trEPRTSim_DandEconverter(unconverted)
%
%
%   converted   - vector
%                 two element vector if input was a three element vector
%                 three element vector if input was a two element vector
%
%   unconverted - vector
%                 two element vector with D (first element) and E (second element) values
%                 three element vector with the three principal values (dxx, dyy, dzz) of the
%                 D tensor
%
% See also TREPRTSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-05-28


switch  length(unconverted)
    case 2
        converted = [-1,-1,2]./3 .* unconverted(1) + [1,-1,0].*unconverted(2);
        [~, icon] = sort(abs(converted),'ascend');
        converted = converted(icon);
    case 3
        [~, icon] = sort(abs(unconverted),'ascend');
        unconverted = unconverted(icon);
        converted = [1, 0].*(3/2).*abs(unconverted(3)) + [0, 1]./2.*abs(unconverted(1)-unconverted(2));
    otherwise
        msg = 'Error occured.';
        error(msg);
end