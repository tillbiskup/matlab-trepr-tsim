function [normalized] = TsimPnormalizer(unnormalized)
% TSIMPnormalizer Normalizes the Populations so the sum is always
% equal to one
%
% Usage
%   [normalized] = TsimDandEconverter(unnormalized)
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
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-05-28


    norma = sum(unnormalized);
    normalized = unnormalized./norma;
    
end