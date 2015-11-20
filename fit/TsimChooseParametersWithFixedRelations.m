function Multidataset = TsimChooseParametersWithFixedRelations(Multidataset)
% TSIMCHOOSEPARAMETERSWITHFIXEDREALATIONS makes a full Multidatasets with
% user defied fixed realtion parameters.
%
% Usage
%   Mulitdataset =TsimChooseParametersWithFixedRelations(Multidataset)
%
%
%   Multidataset - cell of struct
%                  stucts are full trEPR toolbox dataset including Tsim structure
%
%
% See also TSIM

% Copyright (c) 2015, Deborah Meyer, Till Biskup
% 2015-11-19


 % Find simulationparameters user has in simpar
 
  SimulationParameters = fieldnames(Multidataset{1}.Tsim.sim.simpar);

        option = [ ...
            strtrim(cellstr(num2str((1:length(SimulationParameters))')))...
            (SimulationParameters) ...
            ];
        
        answer = cliMenu(option,...
            'title','Please chose simulation parameter(s) with fixed realations to each other',...
            'multiple',true);
         
        FixedRelationParameters = SimulationParameters(str2double(answer));
      % offset(FixesRealtionParameter,numberOfDatasets)
        offset(1,1) = 0;
        
        for HowManyFixedRealtionParameters = 1:length(FixedRelationParameters)
            for numberOfDatasets = 2:length(Multidataset)
                disp('')
                disp(['Give the offsets for ', FixedRelationParameters(HowManyFixedRealtionParameters)] )
                disp('')
                prompt = ['from the ', num2str(numberOfDatasets-1), '. to the ', num2str(numberOfDatasets), '. dataset'];
                offset(HowManyFixedRealtionParameters,numberOfDatasets) = cliInput(prompt,'numeric',true);
            end
        end

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % sum up offsets correctly
        
        
        for k=1:size(offset,1)
            for j =1:size(offset,2)
                sumoffset(k,j) = sum(offset(k,1:j));
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Put all Parameters into Multidatasets, including offsets and
        % names of fixed ralation parameters (FixedRelationParameters, new)
        
        Master = Multidataset;
        
        for numberOfDatasets = 1:length(Multidataset)
            
            tempSpectrum = Master{numberOfDatasets}.Tsim.fit.spectrum.tempSpectrum;
            section = Master{numberOfDatasets}.Tsim.fit.spectrum.section;
            
            Multidataset{numberOfDatasets}.Tsim = Master{1}.Tsim;
            Multidataset{numberOfDatasets}.Tsim.fit.spectrum.tempSpectrum =tempSpectrum;
            Multidataset{numberOfDatasets}.Tsim.fit.spectrum.section = section;
           Multidataset{numberOfDatasets}.Tsim.fit.globally.fixedRealtionParameters = FixedRelationParameters;
           Multidataset{numberOfDatasets}.Tsim.fit.globally.offset = sumoffset(:,numberOfDatasets);
            
             for HowManyFixedRealtionParameters = 1:length(FixedRelationParameters) 
                                  
                 Multidataset{numberOfDatasets}.Tsim.sim.simpar.(char(FixedRelationParameters(HowManyFixedRealtionParameters))) ...
                     = Multidataset{1}.Tsim.sim.simpar.(char(FixedRelationParameters(HowManyFixedRealtionParameters))) + sumoffset(HowManyFixedRealtionParameters,numberOfDatasets) ;  
             end
        end
  
end
