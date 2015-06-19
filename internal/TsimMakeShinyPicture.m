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
%             Full trEPR toolbox dataset including TSim structure
%
% See also TSIM

% Copyright (c) 2013-2015, Deborah Meyer, Till Biskup
% 2015-06-18

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

Magfieldaxis =  linspace(...
    dataset.TSim.sim.simpar.Range(1),...
    dataset.TSim.sim.simpar.Range(2),...
    dataset.TSim.sim.simpar.nPoints);

tester = isempty(dataset.TSim.fit.spectrum.tempSpectrum);

switch tester
    case true
        % simulation     
    plot(Magfieldaxis,dataset.calculated);
    set(gca,'XLim',[min(Magfieldaxis),max(Magfieldaxis)]);
    if strcmpi(config.SimFigureAppearance.xlabel,'on')
    xlabel(config.FigureAxesLabelDef.xlabel);
    end
    
    if strcmpi(config.SimFigureAppearance.ylabel,'on')
        ylabel(config.FigureAxesLabelDef.ylabel);
    end
    set(gcf,'DefaultAxesColorOrder',simlinecolor);
    addZeroLines(zeroLineProperties)
    
    
    case false
        % fit
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
        if strcmpi(config.SimFigureAppearance.ylabel,'on')
            ylabel(config.FigureAxesLabelDef.ylabel);
        end
        
        set(gca,'XLim',[min(Magfieldaxis),max(Magfieldaxis)]);
        legend({'Original','Fit'},'Location',config.Legend.location);
        set(gca,'XTickLabel',{})
      
        
        addZeroLines(zeroLineProperties)
        subplot(6,1,6);
        plot(Magfieldaxis,difference,'LineWidth',1,'Color',residuumlinecolor);
        set(gca,'XLim',[min(Magfieldaxis),max(Magfieldaxis)]);
        if strcmpi(config.SimFigureAppearance.xlabel,'on')
            xlabel(config.FigureAxesLabelDef.xlabel);
        end
        
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
