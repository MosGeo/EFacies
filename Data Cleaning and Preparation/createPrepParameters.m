function prepParameters = createPrepParameters(isnormalized, ispca, pcaVarExplainedThresh, smoothspan)


    % Default values
    if exist('isnormalized','var')==false; isnormalized=true; end
    if exist('ispca','var')==false; ispca=true; end
    if exist('pcaVarExplainedThresh','var')==false; pcavarexplainedThresh=1; end
    if exist('smoothspan','var')==false; smoothspan=0; end

    % Construct the parameter structure
    prepParameters =[];
    prepParameters.ispca = ispca;
    prepParameters.pcaVarExplainedThresh = pcaVarExplainedThresh;
    prepParameters.smoothspan = smoothspan;
    prepParameters.isnormalized = isnormalized;
    
end