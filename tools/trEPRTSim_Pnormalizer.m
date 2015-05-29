function [normalized] = trEPRTSim_Pnormalizer(unnormalized)
% TREPRTSIM_Pnormalizer Normalizes the Populations so the sum is always
% equal to one
%
% Usage
%   [normalized] = trEPRTSim_DandEconverter(unnormalized)
%
%
%   normalized   - vector
%                  three element vector containing the normalized
%                  populations
%
%   unnormalized - vector
%                  three element vector containing the unnormalized
%                  populations
%
%
% See also TREPRTSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-05-28


    norma = sum(unnormalized);
    normalized = unnormalized./norma;
    
end