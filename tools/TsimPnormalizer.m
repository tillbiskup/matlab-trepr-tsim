function [normalized] = TsimPnormalizer(unnormalized)
% TSIMPNORMALIZER Normalize populations
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
% 2015-05-29

normalized = unnormalized./sum(unnormalized);

end