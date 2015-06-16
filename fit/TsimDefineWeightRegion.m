function dataset = TsimDefineWeightRegion(dataset)
% TSIMDEFINEWEIGHTINGREGION define region and factor for weighting your
% sprectrum for a weighted fit. 
%
% Usage
%   dataset = TsimDefineWeightRegion(dataset)
%
%
%   dataset -  struct
%              Full trEPR toolbox dataset including TSim structure
% 
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-06-16



weightloop = true;
while weightloop
      
    option= {...
        'c','clear regions; everything is weighted the same';...
        'w','chose one ore more regions';};
    
    answer = cliMenu(option,...
        'title','Please choose',...
        'default','c');
    
    disp(' ');
    
    switch lower(answer)
        case 'c'
            % Clear weighting
            dataset.TSim.fit.weighting.weightingArea = [];
            dataset.TSim.fit.weighting.weightingFactor = [];
            weightloop = false;
        case 'w'
            ChooseRegionLoop = true;
            while ChooseRegionLoop
                
                prompt = 'Please enter two or more magnetic field values for weighting this/these region(s). Hit enter for return';
                answerstr = cliInput(prompt);
                
                if  isempty(answerstr)
                    weightloop = true;
                    ChooseRegionLoop = false;
                    
                else
                    dataset.TSim.fit.weighting.weightingArea = str2num(answerstr);
                   
                    prompt = 'Please enter the weighting factor(s) for your region(s)';
                    answerstr = cliInput(prompt);
                    
                    dataset.TSim.fit.weighting.weightingFactor = str2num(answerstr);
                    weightloop = false;
                    ChooseRegionLoop = false;
                end
                
            end % ChooseRegionLoop
            
        otherwise
            % Shall never happen
            disp('Moron!');
    end    
end % weightloop


end

