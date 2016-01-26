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

% Copyright (c) 2013-2016, Deborah Meyer, Till Biskup
% 2016-01-26

% get config
config = TsimConfigGet('figure');
simlinecolor = config.FigureColorDef.simlinecolor;
explinecolor = config.FigureColorDef.explinecolor;
residuumlinecolor = config.FigureColorDef.residuumlinecolor;

simLineWidth = config.FigureLineWidthDef.simlinewidth;
expLineWidth = config.FigureLineWidthDef.explinewidth;
residuumLineWidth = config.FigureLineWidthDef.residuumlinewidth;

simLineStyle = config.FigureLineStyleDef.simlinestyle;
expLineStyle = config.FigureLineStyleDef.explinestyle;
residuumLineStyle = config.FigureLineStyleDef.residuumlinestyle;

legenddata = config.Legend.data;
legendsim = config.Legend.sim;
legendlocation = config.Legend.location;

zeroLineProperties = struct(...
    'Color', config.FigureColorDef.zerolinecolor,...
    'LineStyle',config.FigureLineStyleDef.zerolinestyle, ...
    'LineWidth',config.FigureLineWidthDef.zerolinewidth ...
    );

% Make Axes for Tsim
if isfield(dataset,'Tsim')
    Magfieldaxis =  linspace(...
        dataset.Tsim.sim.simpar.Range(1),...
        dataset.Tsim.sim.simpar.Range(2),...
        dataset.Tsim.sim.simpar.nPoints);
    
    hasFit = ~isempty(dataset.Tsim.fit.fitpar);
else
    % No Tsim, hence only experimental
    [maximum,idxMax] = max(max(dataset.data));
    Magfieldaxis = dataset.axes.data(2).values;
    
    figure(1);
    plot(Magfieldaxis,dataset.data(:,idxMax),'color',explinecolor, 'LineWidth', expLineWidth);
    
    % Find minimum
    [minimum,~] = min(min(dataset.data));
    
    % Make in total 20% white space on top and on the bottom of plot
    whitespace = (maximum-minimum)*0.1;
    
    % set Y axes nice
    set(gca,'YLim',[minimum-whitespace,maximum+whitespace]);
    set(gca,'XLim',[min(Magfieldaxis),max(Magfieldaxis)]);
    
    % Try to make axis the same size
    set(gca,'Units','centimeters');
    set(gca,'Position',[1.5, 1.5, 14, 9]);
    
    h = gcf;
    return;
end

switch hasFit
    case false
        % simulation
        
        plot(Magfieldaxis,dataset.calculated,'color',simlinecolor, 'LineWidth', simLineWidth);
        set(gca,'XLim',[min(Magfieldaxis),max(Magfieldaxis)]);
        
        if strcmpi(config.SimFigureAppearance.xlabel,'on')
            xlabel(config.FigureAxesLabelDef.xlabel);
        end
        
        if strcmpi(config.SimFigureAppearance.ylabel,'on')
            ylabel(config.FigureAxesLabelDef.ylabel);
        end
        
        maximum = max(dataset.calculated);
        % Find minimum
        minimum = min(dataset.calculated);
        
        % Make in total 20% white space on top and on the bottom of plot
        whitespace = (maximum-minimum)*0.1;
        
        % set Y axes nice
        set(gca,'YLim',[minimum-whitespace,maximum+whitespace]);
        
        if strcmpi(config.SimFigureAppearance.xticks,'off')
            set(gca,'XTick',[]);
        end
        
        if strcmpi(config.SimFigureAppearance.yticks,'off')
            set(gca,'YTick',[]);
        end
        
        addZeroLines(zeroLineProperties)
          
        % Try to make axis the same size
        set(gca,'Units','centimeters');
        set(gca,'Position',[1.5, 1.5, 14, 9]);
        
    case true
        % fit
        % since spectrum is probably weighted calculated it new.
        % Check if 2d or 1d data
        if size(dataset.data) > 1
            inx = interp1(dataset.axes.data(1).values,1:length(dataset.axes.data(1).values),dataset.Tsim.fit.spectrum.section,'nearest');
            
            if isscalar(inx)
                dataset.Tsim.fit.spectrum.tempSpectrum = dataset.data(:,inx);
            else
                parameters.start.index = inx(1);
                parameters.stop.index = inx(2);
                parameters.dimension = 'x';
                avgData = trEPRAVG(dataset,parameters);
                dataset.Tsim.fit.spectrum.tempSpectrum = avgData.data;
            end
        else
            % 1D data
            dataset.Tsim.fit.spectrum.tempSpectrum = dataset.data;
            
        end
        
        dataset.Tsim.fit.spectrum.tempSpectrum = dataset.Tsim.fit.spectrum.tempSpectrum./sum(abs(dataset.Tsim.fit.spectrum.tempSpectrum));
        difference = dataset.Tsim.fit.spectrum.tempSpectrum-dataset.calculated;
        
        figure('Name', ['Data from ' dataset.file.name])
        
        
        if strcmpi(config.FitFigureAppearance.residuum,'on')
            subplot(6,1,[1 5]);
        end
        
        plot(Magfieldaxis,dataset.Tsim.fit.spectrum.tempSpectrum, 'color',explinecolor, 'LineWidth', expLineWidth, 'LineStyle', expLineStyle);
        
        hold on
        
        plot(Magfieldaxis,dataset.calculated, 'color',simlinecolor, 'LineWidth', simLineWidth, 'LineStyle', simLineStyle);
        
        hold off
        
        % y axis
        if strcmpi(config.FitFigureAppearance.ylabel,'on')
            ylabel(config.FigureAxesLabelDef.ylabel);
        end
        
        if strcmpi(config.FitFigureAppearance.yticks,'off')
            set(gca,'YTick',[]);
        end
        
        %find maximum
        maximumExp = max(dataset.Tsim.fit.spectrum.tempSpectrum);
        maximumSim =  max(dataset.calculated);
        % Find minimum
        minimumExp = min(dataset.Tsim.fit.spectrum.tempSpectrum);
        minimumSim =  min(dataset.calculated);
        
        if maximumExp > maximumSim
            maximum = maximumExp;
        else
            maximum = maximumSim;
        end
        
        
        if minimumExp < minimumSim
            minimum = minimumExp;
        else
            minimum = minimumSim;
        end
        
        % Make in total 20% white space on top and on the bottom of plot
        whitespace = (maximum-minimum)*0.1;
        
        % set Y axes nice
        set(gca,'YLim',[minimum-whitespace,maximum+whitespace]);
        
        
        % x axis
        if strcmpi(config.FitFigureAppearance.xticks,'off')
            set(gca,'XTick',[]);
        end
        
        % legend
        if strcmpi(config.Legend.legend,'on')
            legend({legenddata,legendsim},'Location',legendlocation);
        end
        
        addZeroLines(zeroLineProperties)
        set(gca,'XLim',[min(Magfieldaxis),max(Magfieldaxis)]);
        
        % Residuum
        if strcmpi(config.FitFigureAppearance.residuum,'on')
            if strcmpi(config.FitFigureAppearance.residuumxticks,'on')
                set(gca,'XTickLabel',{})
            end
            subplot(6,1,6);
            plot(Magfieldaxis,difference,'LineWidth',residuumLineWidth,'Color',residuumlinecolor, 'LineStyle', residuumLineStyle);
            set(gca,'XLim',[min(Magfieldaxis),max(Magfieldaxis)]);
            
            % x axis residuum
            if strcmpi(config.FitFigureAppearance.residuumxticks,'off')
                set(gca,'XTick',[]);
            end
            % y axis residuum
            if strcmpi(config.FitFigureAppearance.residuumyticks,'off')
                set(gca,'YTick',[]);
            end
            
        end
        
        % x axis
        if strcmpi(config.SimFigureAppearance.xlabel,'on')
            xlabel(config.FigureAxesLabelDef.xlabel);
        end
        
        set(gca,'XLim',[min(Magfieldaxis),max(Magfieldaxis)]);
        
        % Try to make axis the same size
        set(gca,'Units','centimeters');
        set(gca,'Position',[1.5, 1.5, 14, 9]);
end

h = gcf;

end % function



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
