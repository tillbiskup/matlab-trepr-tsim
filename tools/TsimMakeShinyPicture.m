function h = TsimMakeShinyPicture(dataset)
% TSIMMAKESHINYPICTURE Make a nice figure of sim and fit.
%
%
% Usage
%   h = TsimMakeShinyPicture(dataset)
%
%   h       - figure handle
%
%   dataset - struct
%             Full trEPR toolbox dataset including Tsim structure
%
% See also TSIM

% Copyright (c) 2013-2015, Deborah Meyer, Till Biskup
% 2015-09-15

% get config
config = TsimConfigGet('figure');
simlinecolor = config.FigureColorDef.simlinecolor;
explinecolor = config.FigureColorDef.explinecolor;
residuumlinecolor = config.FigureColorDef.residuumlinecolor;

zeroLineProperties = struct(...
    'Color', config.FigureColorDef.zerolinecolor,...
    'LineStyle',config.FigureLineStyleDef.zerolinestyle, ...
    'LineWidth',config.FigureLineWidthDef.zerolinewidth ...
    );

% Make Axes for Tsim
if isfield(dataset,'Tsim')
    Magfieldaxis =  linspace(...
        dataset.Tsim(1).sim.simpar.Range(1),...
        dataset.Tsim(1).sim.simpar.Range(2),...
        dataset.Tsim(1).sim.simpar.nPoints);
    
    hasFit = ~isempty(dataset.Tsim(1).fit.fitpar);
else
    % No Tsim, hence only experimental
    [~,idxMax] = max(max(dataset.data));
    Magfieldaxis = dataset.axes.data(2).values;
    
    figure(1);
    plot(Magfieldaxis,dataset.data(:,idxMax),'color',explinecolor);
    legend({'Originaldata'},'Location','SouthEast');

    set(gca,'XLim',[min(Magfieldaxis),max(Magfieldaxis)]);

     h = gcf;
    return;
end

switch hasFit
    case false
        % simulation
        plot(Magfieldaxis,dataset.calculated);
        set(gca,'XLim',[min(Magfieldaxis),max(Magfieldaxis)]);
        if strcmpi(config.SimFigureAppearance.xlabel,'on')
            xlabel(config.FigureAxesLabelDef.xlabel);
        end
        
        if strcmpi(config.SimFigureAppearance.ylabel,'on')
            ylabel(config.FigureAxesLabelDef.ylabel);
        end
        addZeroLines(zeroLineProperties)
        set(gcf,'DefaultAxesColorOrder',simlinecolor);
        
        
        
    case true
        % fit
        % since spectrum is probably weighted calculated it new.
        % Check if 2d or 1d data
        if size(dataset.data) > 1
            inx = interp1(dataset.axes.data(1).values,1:length(dataset.axes.data(1).values),dataset.Tsim(1).fit.spectrum.section,'nearest');
            
            if isscalar(inx)
                dataset.Tsim(1).fit.spectrum.tempSpectrum = dataset.data(:,inx);
            else
                parameters.start.index = inx(1);
                parameters.stop.index = inx(2);
                parameters.dimension = 'x';
                avgData = trEPRAVG(dataset,parameters);
                dataset.Tsim(1).fit.spectrum.tempSpectrum = avgData.data;
            end
        else
            % 1D data
            dataset.Tsim(1).fit.spectrum.tempSpectrum = dataset.data;
            
        end
        
        dataset.Tsim(1).fit.spectrum.tempSpectrum = dataset.Tsim(1).fit.spectrum.tempSpectrum./sum(abs(dataset.Tsim(1).fit.spectrum.tempSpectrum));
        difference = dataset.Tsim.fit.spectrum.tempSpectrum-dataset.calculated;
        
        figure('Name', ['Data from ' dataset.file.name])
        
        set(gcf,'DefaultAxesColorOrder',[explinecolor; simlinecolor]);
        subplot(6,1,[1 5]);
        
        plot(...
            Magfieldaxis,...
            [dataset.Tsim(1).fit.spectrum.tempSpectrum,dataset.calculated],...
            'LineWidth',1);
        if strcmpi(config.SimFigureAppearance.ylabel,'on')
            ylabel(config.FigureAxesLabelDef.ylabel);
        end
        
        
        legend({'Original','Fit'},'Location',config.Legend.location);
        set(gca,'XTickLabel',{})
        addZeroLines(zeroLineProperties)
        set(gca,'XLim',[min(Magfieldaxis),max(Magfieldaxis)]);
        
        subplot(6,1,6);
        plot(Magfieldaxis,difference,'LineWidth',1,'Color',residuumlinecolor);
        if strcmpi(config.SimFigureAppearance.xlabel,'on')
            xlabel(config.FigureAxesLabelDef.xlabel);
        end
        set(gca,'XLim',[min(Magfieldaxis),max(Magfieldaxis)]);
end

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
