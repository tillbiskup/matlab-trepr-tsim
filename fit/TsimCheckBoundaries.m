function dataset = TsimCheckBoundaries(dataset)
% TSIMCHECKBOUDNARIES Check if boundaries are compatible with fitparvalue.
% If not change boundary. New boundary is 5% smaller or bigger than
% initialvalue
%
% Usage
%   dataset = TsimCheckBoundary(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-11

fraction = 1/20;

for k= 1:length(dataset.TSim.fit.fitpar)
if ~(dataset.TSim.fit.lb(k) < dataset.TSim.fit.initialvalue(k))
    dataset.TSim.fit.lb(k) = dataset.TSim.fit.initialvalue(k)-(dataset.TSim.fit.initialvalue(k)*fraction);
end

if ~(dataset.TSim.fit.ub(k) > dataset.TSim.fit.initialvalue(k))
    dataset.TSim.fit.ub(k) = dataset.TSim.fit.initialvalue(k)+(dataset.TSim.fit.initialvalue(k)*fraction);
end

end
 