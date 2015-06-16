function h = TsimMakeShinyPicture(dataset)
% TSIMMAKESHINYPICTURE Make a nice figure of fitresult.
%
%
% Usage
%   h = TsimMakeShinyPicture(dataset)
%
%   h       - figure handle
%
%   dataset - struct
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2013-2015, Deborah Meyer, Till Biskup
% 2015-06-16

% colordefinitions for picture
simlinecolor = [0 0.6 0];
explinecolor = [0 0 0];
zerolinecolor = [0.5 0.5 0.5];
residuumlinecolor = [0 0 1];

Magfieldaxis =  linspace(...
    dataset.TSim.sim.simpar.Range(1),...
    dataset.TSim.sim.simpar.Range(2),...
    dataset.TSim.sim.simpar.nPoints);

% Figure
% Calculate difference between fit and signal
% since spectrum is probably weighted calculated it new.

% Check if 2d or 1d data
if size(dataset.data) > 1
    inx = interp1(dataset.axes.data(1).values,1:length(dataset.axes.data(1).values),dataset.TSim.fit.spectrum.section,'nearest');
    
    if isscalar(inx)
        dataset.TSim.fit.spectrum.tempSpectrum = dataset.data(:,inx);
    else
        parameters.start.index = inx(1);
        parameters.stop.index = inx(2);
        parameters.dimension = 'x';
        avgData = trEPRAVG(dataset,parameters);
        dataset.TSim.fit.spectrum.tempSpectrum = avgData.data;
    end
else
    % 1D data
    dataset.TSim.fit.spectrum.tempSpectrum = dataset.data;
    
end

dataset.TSim.fit.spectrum.tempSpectrum = dataset.TSim.fit.spectrum.tempSpectrum./sum(abs(dataset.TSim.fit.spectrum.tempSpectrum));

difference = dataset.TSim.fit.spectrum.tempSpectrum-dataset.calculated;

figure('Name', ['Data from ' dataset.file.name])

set(gcf,'DefaultAxesColorOrder',[explinecolor; simlinecolor]);
subplot(6,1,[1 5]);
plot(...
    Magfieldaxis,...
    [dataset.TSim.fit.spectrum.tempSpectrum,dataset.calculated],...
    'LineWidth',1);
set(gca,'XLim',[min(Magfieldaxis),max(Magfieldaxis)]);
legend({'Original','Fit'},'Location','SouthEast');
set(gca,'XTickLabel',{})


zeroLineProperties = struct(...
    'Color',zerolinecolor,...
    'LineStyle','--', ...
    'LineWidth',1 ...
    );


addZeroLines(zeroLineProperties)
subplot(6,1,6);
plot(Magfieldaxis,difference,'LineWidth',1,'Color',residuumlinecolor);
xlabel('{\it magnetic field} / mT');
set(gca,'XLim',[min(Magfieldaxis),max(Magfieldaxis)]);
addZeroLines(zeroLineProperties)
subplot(6,1,[1 5]);
set(gcf,'DefaultAxesColorOrder',[explinecolor; simlinecolor]);

h = gcf;


end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function addZeroLines(lineProperties)

xLimits = get(gca,'XLim');
yLimits = get(gca,'YLim');

hLine = [];

if prod(xLimits) <= 0
    hold on
    hLine(end+1) = line([0 0],yLimits);
    hold off
end

if prod(yLimits) <= 0
    hold on
    hLine(end+1) = line(xLimits,[0 0]);
    hold off
end

% Set line properties
for lHandle = 1:length(hLine)
    set(hLine(lHandle),lineProperties);
end

end
