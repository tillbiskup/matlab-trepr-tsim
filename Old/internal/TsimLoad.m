function [expdataset,status] = TsimLoad(filename)
% TSIMDATASET Load experimental data, make some corrections 
% and merge it into TSim structure.
%
%
% Usage
%   dataset = TsimLoad(filename);
%   [dataset,status] = TsimLoad(filename);
%
%   dataset   - struct
%               Full trEPR toolbox dataset including TSim structure
%
%   status    - integer
%               0 everything is fine
%
%   filename  - string 
%               name of Experimental data
%
% See also TSIM...

% Copyright (c) 2013, Deborah Meyer, Till Biskup
% 2013-12-13


% Define return variables
status = 0;

% Create empty dataset
expdataset = TsimDataset();

% Load experimental data using <trEPRload>.
[data] = trEPRload(filename);

% Is there is a problem loading the file
if isempty(data) 
    status = 1;
    return;
end

% Convert Gauss -> mT
data = trEPRconvertUnits(data,'g2mt');


% Some necessary tests of the dataset loaded, such as 1D or 2D,
% preprocessing, and selecting slice (in case of 2D)

% Check whether data are 2D or 1D, and in case of 2D, take maximum
if min(size(data.data)) > 1
    disp(' ');
    disp('2D data detected');
    % For the time being, perform a pretrigger offset compensation on
    % the data... (should be done by the user manually or within the
    % toolbox, respectively.)
    disp(' ');
    disp('Perform pretrigger offset compensation (POC)');
    data.data = trEPRPOC(...
        data.data,data.parameters.transient.triggerPosition);
    % In case of fsc2 data, perform BGC
    if isfield(data,'file') && isfield(data.file,'format') ...
            && strcmpi(data.file.format,'fsc2')
        disp(' ');
        disp('Perform simple background correction (BGC)');
        data.data = trEPRBGC(data.data);
    end
else
    data.data = data.data;
end


% In case we couldn't read a frequency value from the (too old) fsc2
% file, ask user to provide a reasonable value...
if isempty(data.parameters.bridge.MWfrequency.value)
    disp(' ');
    disp('Dataset is missing MW frequency value. Please provide one.');
    MWfreqloop = true;
    MWfreqDefault = 9.70;
    while MWfreqloop
        MWfreq = input(...
            sprintf('MW frequency in GHz [%f]: ',MWfreqDefault),'s');
        if isempty(MWfreq)
            MWfreq = MWfreqDefault;
            data.parameters.bridge.MWfrequency.value = MWfreq;
            data.parameters.bridge.MWfrequency.unit = 'GHz';
            MWfreqloop = false;
        end
        if ~isnan(str2double(MWfreq))
            data.parameters.bridge.MWfrequency.value = ...
                str2double(MWfreq);
            data.parameters.bridge.MWfrequency.unit = 'GHz';
            MWfreqloop = false;
        end
    end
    disp(' ');
end

% If MWfrequency is a vector and not a scalar, average
if ~isscalar(data.parameters.bridge.MWfrequency.value)
    data.parameters.bridge.MWfrequency.value = ...
        mean(data.parameters.bridge.MWfrequency.value);
end


% Merging parameters from experimental dataset.
data.Tsim = expdataset.Tsim;
expdataset = data;
clear data;
end
