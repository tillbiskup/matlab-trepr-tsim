function varargout = TsimInfo(varargin)
% TSIMINFO Display/return information about the trEPR toolbox Tsim
% module.
%
% TSIMINFO without any input and output parameters displays
% information about the trEPR toolbox Tsim module.
%
% If called with an output parameter, TsimInfo returns a structure
% "info" that contains all the information known to Matlab(r) about the
% trEPR toolbox Tsim module.
%
% Usage
%   TsimInfo
%
%   info = TsimInfo;
%
%   version = TsimInfo('version')
%   url = TsimInfo('url')
%   dir = TsimInfo('dir')
%
%   info    - struct
%             Fields: maintainer, url, bugtracker, vcs, version, path,
%                     name, description
%
%             maintainer  - struct
%                           Fields: name, email
%
%             url         - string
%                           URL of the toolbox website
%
%             bugtracker  - struct
%                           Fields: type, url
%
%             vcs         - struct
%                           Fields: type, url
%
%             version     - struct
%                           Fields: Name, Version, Release, Date
%                           This struct is identical to the output of the
%                           Matlab(r) "ver" command.
%
%             path        - string
%                           installation directory of the toolbox
%
%             name        - string
%                           name of the toolbox module
%
%             description - string
%                           short description of the toolbox module
%
%   version - string
%             <version> yyyy-mm-dd
%
%   url     - string
%             URL of the toolbox website
%
%   dir     - string
%             installation directory of the toolbox
%
% See also VER

% Copyright (c) 2013-15, Deborah Meyer, Till Biskup
% 2015-09-14

% The place to centrally manage the revision number and date is the file
% "Contents.m" in the root directory of the trEPR toolbox SIM module.
%
% THE VALUES IN THAT FILE SHOULD ONLY BE CHANGED BY THE OFFICIAL MAINTAINER
% OF THE TOOLBOX MODULE!
%
% As the "ver" command works not reliably, as it works only in case the
% toolbox module is on the Matlab(r) search path, we parse this file here
% manually.
%
% Additional information about the maintainer, the URL, etcetera, are
% stored below. Again:
%
% THESE VALUES SHOULD ONLY BE CHANGED BY THE OFFICIAL MAINTAINER OF THE
% TOOLBOX MODULE!

info = struct();
info.maintainer(1) = struct(...
    'name','Deborah Meyer',...
    'email','deborah.meyer@physchem.uni-freiburg.de'...
    );
info.maintainer(2) = struct(...
    'name','Till Biskup',...
    'email','till@till-biskup.de'...
    );
info.url = 'http://till-biskup.de/en/software/matlab/trepr/';
info.bugtracker = struct(...
    'type','BugZilla',...
    'url','https://r3c.de/bugs/till/'...
    );
info.vcs = struct(...
    'type','git',...
    'url','git@sw2.physchem.uni-freiburg.de/triplet.git'...
    );
info.description = ...
    'a module for the trEPR toolbox for simulating triplet spectra';

% For all version information, parse the "Contents.m" file in the toolbox
% root directory
% Get path to file "Contents.m"
[path,~,~] = fileparts(mfilename('fullpath'));
contentsFile = [ path(1:end-8) 'Contents.m' ];
% Read first two lines of "Contents.m"
contentsFileHeader = cell(2,1);
fid = fopen(contentsFile);
for k=1:2
    contentsFileHeader{k} = fgetl(fid);
end
fclose(fid);

info.name = contentsFileHeader{1}(3:end);
C = textscan(contentsFileHeader{2}(3:end),'%s %s %s %s');

info.version = struct();
info.version.Name = contentsFileHeader{1}(3:end);
info.version.Version = C{2}{1};
if isempty(C{4})
    info.version.Release = '';
    info.version.Date = ...
        datestr(datenum(char(C{3}{1}), 'dd-mmm-yyyy'), 'yyyy-mm-dd');
else
    info.version.Release = C{3}{1};
    info.version.Date = ...
        datestr(datenum(char(C{4}{1}), 'dd-mmm-yyyy'), 'yyyy-mm-dd');
end

% Get install directory
[path,~,~] = fileparts(mfilename('fullpath'));
info.path = path(1:end-9);

if nargin
    switch lower(varargin{1})
        case 'version'
            varargout{1} = ...
                sprintf('%s %s',info.version.Version,info.version.Date);
        case 'url'
            varargout{1} = info.url;
        case 'dir'
            varargout{1} = info.path;
        otherwise
    end
elseif nargout
    varargout{1} = info;
else
    fprintf('==========================================================================\n');
    fprintf('\n');
    fprintf(' %s\n',info.name);
    fprintf(' - %s  \n',info.description);
    fprintf('\n');
    fprintf(' Release:         %s %s\n',info.version.Version,info.version.Date);
    fprintf(' Directory:       %s\n',info.path);
    fprintf(' Matlab version:  %s\n',version);
    fprintf(' Platform:        %s\n',platform);
    fprintf('\n');
    fprintf(' Homepage:        %s\n',info.url);
    for k=1:length(info.maintainer)
        fprintf(' Maintainer:      %s, <%s>\n',info.maintainer(k).name,...
            info.maintainer(k).email);
    end
    fprintf('\n');
    fprintf(' Bug tracker:     %s\n',info.bugtracker.url);
    fprintf('\n');
    fprintf('==========================================================================\n');
end

end