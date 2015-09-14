function dataset = TsimCheckBoundaries(dataset)
% TSIMCHECKBOUDNARIES Check if boundaries are compatible with fitparvalue.
% If not change boundary. New boundary is 5% smaller or bigger than
% initialvalue
%
% Usage
%   dataset = TsimCheckBoundary(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including Tsim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-09-14

fraction = 1/20;

for k= 1:length(dataset.Tsim.fit.fitpar)
if ~(dataset.Tsim.fit.lb(k) < dataset.Tsim.fit.initialvalue(k))
    dataset.Tsim.fit.lb(k) = dataset.Tsim.fit.initialvalue(k)-(dataset.Tsim.fit.initialvalue(k)*fraction);
end

if ~(dataset.Tsim.fit.ub(k) > dataset.Tsim.fit.initialvalue(k))
    dataset.Tsim.fit.ub(k) = dataset.Tsim.fit.initialvalue(k)+(dataset.Tsim.fit.initialvalue(k)*fraction);
end

end
 