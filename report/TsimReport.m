function TsimReport(dataset,varargin)
% TSIMREPORT Generate report using template and tpl engine presenting an
% overview of the simulation/fit that has been performed on the data
% contained in dataset.
%
% Usage
%   TsimReport(dataset);
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% If you want to generate a report for a dataset saved as TEZ file, use
% something like
%
%   dataset = trEPRload(<filename>);
%   TsimReport(dataset);
%
% or, even shorter:
%
%   TsimReport(trEPRload(<filename>))
%
% See also TSIM, tpl

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-20

try
    % Parse input arguments using the inputParser functionality
    p = inputParser;            % Create inputParser instance.
    p.FunctionName = mfilename; % Include function name in error messages
    p.KeepUnmatched = true;     % Enable errors on unmatched arguments
    p.StructExpand = true;      % Enable passing arguments in a structure
    p.addRequired('dataset', @(x)isstruct(x));
    p.addParamValue('template','TsimFitReport-de.tex',@(x)ischar(x));
    p.parse(dataset,varargin{:});
catch exception
    disp(['(EE) ' exception.message]);
    return;
end

% Check whether we have the structure in dataset we need to report on
if ~isfield(dataset,'TSim')
    disp('(WW) Dataset doen''t contain "TSim" structure... aborting.');
    return;
end

% TODO: Check whether we have simulation or fit and choose appropriate
% template.

% Check whether template file exists
if ~exist(p.Results.template,'file')
    disp(['(EE) Template file ' p.Results.template ' seems not to exist.']);
    return;
end

% Get filename of dataset loaded
[~,filename,~] = fileparts(dataset.file.name);
% If field is empty, ask user to provide some
if isempty(filename)
    filename = cliInput('Filename for report (without extension)');
    if isempty(filename)
        return;
    end
end

% TODO: Create central figure for first page of report showing simulation
% or fit together with experimental data
% Might be a call of "MakeShinyFigure" followed by fig2file or something
% similar...

% After creating the figure, assign the figure file name to a field to
% dataset that get's only used here for the template.
% HINT: May be same name as dataset filename
dataset.TSim.resultsFigure = filename;

% TODO: Handle slice/average and assign to some other temporary fields in
% dataset that get used only here for creating the template.
% Reason: Normally, you want to tell the reader center position and width
% of an average, but what you get is only start and end positions.

% Prepare template engine "tpl"
t = tpl();
t.setTemplate(p.Results.template);
t.setDelimiter({'[[',']]'});
t.setAssignments(dataset);

% Write filled template to tex file
commonTextFileWrite([filename '-report.tex'], cellstr(t.render));

% TODO: Decide whether one would like to (optionally)
%       * Call LaTeX (pdflatex) to compile the resulting report
%       * Save report (tex file) and figure file(s) in ZIP archive

end