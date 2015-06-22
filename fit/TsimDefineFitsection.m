function [dataset, quit] = TsimDefineFitsection(dataset)
% TSIMDEFINEFITSECTION Define fit section for 2d data and create normalized
% spectrum
%
% Usage
%   dataset = TsimDefineFitsection(dataset)
%
%
%   dataset -  struct
%              Full trEPR toolbox dataset including TSim structure
%
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-22



quit = false;

if ~isempty(dataset.TSim.fit.spectrum.tempSpectrum)
    return
end

option= {...
    'm','max';...
    'i','min';...
    'e','something else';...
    'q','Quit'};

if ~isempty(dataset.TSim.fit.spectrum.section)
    option(end+1,:) = option(end,:);
    section = strtrim(sprintf('%e ',dataset.TSim.fit.spectrum.section));
    option(end-1,:) = {'s',sprintf('same as before [%s]',section)};
    default = 's';
else
    default = 'm';
end

spectrumloop = true;
while spectrumloop
    
    answer = cliMenu(option,...
        'title','Please chose where you want to fit',...
        'default',default);
    
    disp(' ');
    
    switch lower(answer)
        case 'q'
            % Quit
            quit = true;
            return;
        case 's'
            % same as before
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
            spectrumloop = false;
        case 'm'
            [~,idxMax] = max(max(dataset.data));
            dataset.TSim.fit.spectrum.tempSpectrum = dataset.data(:,idxMax);
            dataset.TSim.fit.spectrum.section = dataset.axes.data(1).values(idxMax);
            spectrumloop = false;
        case 'i'
            [~,idxMin] = min(min(dataset.data));
            dataset.TSim.fit.spectrum.tempSpectrum = dataset.data(:,idxMin);
            dataset.TSim.fit.spectrum.section = dataset.axes.data(1).values(idxMin);
            spectrumloop = false;
        case 'e'
            ChooseSpectrumLoop = true;
            while ChooseSpectrumLoop
                
                prompt = 'Please enter time for slice or two values for averaging. Hit enter for return';
                answerstr = cliInput(prompt);
                
                if  isempty(answerstr)
                    spectrumloop = true;
                    ChooseSpectrumLoop = false;
                    
                else
                    dataset.TSim.fit.spectrum.section = str2num(answerstr);
                    inx = interp1(dataset.axes.data(1).values,1:length(dataset.axes.data(1).values),dataset.TSim.fit.spectrum.section,'nearest');
                    if isscalar(inx)
                        dataset.TSim.fit.spectrum.tempSpectrum = dataset.data(:,inx);
                        ChooseSpectrumLoop = false;
                        spectrumloop = false;
                    else
                        try
                            parameters.start.index = inx(1);
                            parameters.stop.index = inx(2);
                            parameters.dimension = 'x';
                            avgData = trEPRAVG(dataset,parameters);
                            dataset.TSim.fit.spectrum.tempSpectrum = avgData.data;
                            ChooseSpectrumLoop = false;
                            spectrumloop = false;
                        catch %#ok<CTCH>
                            ChooseSpectrumLoop = true;
                        end
                    end
                    
                end
            end % ChooseSpetrumloop
        otherwise
            % Shall never happen
            disp('Moron!');
    end
    
end % sprectrumloop
% normalize spectrum
if isfield(dataset.TSim.fit.spectrum,'tempSpectrum')
    dataset.TSim.fit.spectrum.tempSpectrum = dataset.TSim.fit.spectrum.tempSpectrum./sum(abs(dataset.TSim.fit.spectrum.tempSpectrum));
end

end