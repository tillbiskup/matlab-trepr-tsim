function answer = cliMenu(options,varargin)
% CLIMENU Display menu in the command line with options waiting for user
% input.
%
% The function is an interface to the Matlab(r) function "input" trying to
% unify the "look&feel" and to simplify the use of command-line menus.
%
% Usage
%   answer = cliMenu(options)
%   answer = cliMenu(options,<parameter>,<option>)
%
%   options - cell array (nx2)
%             Strings with options.
%             The first column contains the character(s) to type, the
%             second the description of each option.
%
%   answer  - string
%             User input as string.
%
% Optional parameters
%
%   title   - string
%             Title string displayed at the beginning of the menu.
%             Default: "Please choose an option:"
%
%   prompt  - string
%             String to display at the beginning of the line for user
%             input.
%             Default: "Your choice:"
%             If there is a default option, this gets added in brackets,
%             such as: "Your choice (default: [a]):"
%
%   default - string
%             Default option to use, if user just hits "return".
%             Default: empty string (meaning no option).
%
% If the user chooses an option that doesn't exist, the function displays
% an error message telling the user that the chosen option doesn't exist,
% followed by the menu again.
%
% The (optional) default option is tested against the options provided. If
% the default isn't contained in the options, the routine replies with an
% error message and quits.
%
% Please note: Be short and comprehensive with your options' description,
% particularly due to the rather limited length of a usual command line.
% Restrict yourself to less than 60 characters for each description, if
% ever possible. Have in mind: Somebody has to read (and understand) it...
%
% SEE ALSO: input, ginput, keyboard

% (c) 2013, Till Biskup
% 2013-08-16

% Parse input arguments using the inputParser functionality
parser = inputParser;   % Create an instance of the inputParser class.
parser.FunctionName  = mfilename; % Include function name in error messages
parser.KeepUnmatched = true; % Enable errors on unmatched arguments
parser.StructExpand  = true; % Enable passing arguments in a structure

parser.addRequired('options',@(x)iscell(x) && size(x,2) == 2);
parser.addParamValue('title','Please choose an option:',@ischar);
parser.addParamValue('prompt','Your choice',@ischar);
parser.addParamValue('default','',@ischar);
parser.parse(options,varargin{:});

% If default option, check whether it exists in the options given
if ~isempty(parser.Results.default) ...
        && ~any(strcmpi(parser.Results.options(:,1),parser.Results.default))
    disp(['You chose "' parser.Results.default '" as default, ' ...
        'but the option doesn''t exist.']);
    return;
end

% Determine maximum length of options for aligned display of description of
% options
maxLengthOption = max(cellfun(@(x)length(x),options(:,1)));

% Create options of menu
menuOptions = cell(size(options,1),1);
for k=1:size(options,1)
    menuOptions{k} = sprintf(' [%s]%s %s\\n',options{k,1},...
        blanks(maxLengthOption-length(options{k,1})),options{k,2});
end

% Set menu title
menuTitle = [parser.Results.title '\n'];

% Set promt text
if isempty(parser.Results.default)
    menuPrompt = [parser.Results.prompt ': '];
else
    menuPrompt = [parser.Results.prompt ' (default: [' ...
        parser.Results.default ']): '];
end

% Set loop condition for while loop.
loop = true;

% As long as loop condition holds true, stay in while loop
while loop
    % Display menu in command line
    answer = input([menuTitle menuOptions{:} menuPrompt],'s');

    % If user just hit "enter" key, set reply to default value if any
    if isempty(answer) && ~isempty(parser.Results.default)
        answer = parser.Results.default;
    end
    
    % Check whether reply is valid, otherwise start loop again
    if any(strcmpi(options(:,1),answer))
        loop = false;
    else
        disp(' ');
        disp(['Option "' answer '" not understood.']);
        disp(' ');
        loop = true;
    end
end
