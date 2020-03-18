function [classDataAll] = applyModel(logDataAll, modelData, variablesToPlot, colormap)


%% Preprocessing

if ~exist('colormap', 'var'); colormap = modelData.colorMap; end

%% Main
if class(logDataAll)== 'struct'
    logData1 = logDataAll;
    logDataAll = [ ];
    logDataAll{1} = logData1; 
end


for wellNumber = 1:numel(logDataAll)
    logData = logDataAll{wellNumber};
    distanceExpo =1;
    maxnClasses = size(modelData.nodesWeights,1);
    minnClasses = 1;

    curvesToUse = logData.curvesToUse;
    logVar = logData.logVar(curvesToUse) == 1;
    normVar = logData.normVar(curvesToUse) == 1;
    weights = logData.weights(curvesToUse);
    
    if isempty(logData.lasHeader) == false
        nanValue = str2double(extractValue('NULL', logData.lasHeader.well));
    else
        nanValue = -9999;
    end

    % Extract Data
    [selectedData, selectedDepth] = extractInterval(logData.data, logData.depth, logData.minDepth, logData.maxDepth);
    [selectedData, selectedCurves] = extractCurvesUsed(selectedData, curvesToUse, logData.curvesNames); 

    % Preprocess
    [depth,dataPre] = preProcessData(selectedData, selectedDepth, nanValue, modelData.smoothSpan);
    dataLog = applyLogTransformationOperation(dataPre, logVar,'apply');
    [dataLogNormalized, dataMean, dataSTD] = normalizeData(dataLog, normVar, modelData.dataMean, modelData.dataSTD);
    [dataLogNormalizedWeighted] = applyWeightOperation(dataLogNormalized, weights, 'apply');

    % PCA
    if modelData.isPCA == true
       [scoreUsed, coeffUsed, x] = applyPCA(dataLogNormalizedWeighted, modelData.coeff, modelData.nPrincipleComponents, modelData.latent);
    else
        x = dataLogNormalizedWeighted';
    end

    isMax = true;
    [stochasticClasses, probability, maxClasses] = classifyStochastically(modelData.nodesWeights, x, isMax, distanceExpo);

    [selectedProb] = extractSelectedProbability(probability, stochasticClasses, modelData.upScalingCells, modelData.mainScale);
    [maxProb] = extractSelectedProbability(probability, maxClasses, modelData.upScalingCells, modelData.mainScale);

    % Upscale
    [upscaledClasses] = applyScalingTree(modelData.upscalingTree, stochasticClasses);

    % Plotting
    isDrawLines = true;
    colorMapIndex = sort(unique(upscaledClasses(:)));
    colorMapUsed = colormap(colorMapIndex,:);
    resultsFigure = plotElectrofacies(logData.curvesToUse, logData.logVar, dataPre, depth, logData.lasHeader, logData.curvesNames, upscaledClasses , maxnClasses, minnClasses, maxProb, selectedProb, modelData.mainScale, isDrawLines, colorMapUsed, variablesToPlot);
    % 
    classData.upscaledClassesOriginal = upscaledClasses;

    %classDataAll{wellNumber} = unique(classData.upscaledClasses', 'rows')';
    clear n
    for i = 1:size(upscaledClasses,2)
       n(i) = numel(unique(upscaledClasses(:,i)));
    end
    [~,uniqueIndexs,~] = unique(n);
    upscaledClassesUnique = fliplr(upscaledClasses(:,uniqueIndexs));
    
    classData.upscaledClassesContracted = upscaledClassesUnique;


    classDataAll{wellNumber}.upscaledClasses = classData.upscaledClassesContracted;
    classDataAll{wellNumber}.depth = depth;
    classDataAll{wellNumber}.data = dataPre;
end



end