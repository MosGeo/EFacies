
function modelData = buildModel(logData, prepParameters,  clustParameters , hcaParameters)

if class(logData)== 'struct'
    logData1 = logData;
    logData = [ ];
    logData{1} = logData1; 
end

dataLogAll = [];
for wellNumber = 1: numel(logData)
    
    % Choose the well
    logDataSelected = logData{wellNumber};
    curvesToUse = logDataSelected.curvesToUse;
    logVar = logDataSelected.logVar(curvesToUse) == 1;
    normVar = logDataSelected.normVar(curvesToUse) == 1;
    weights = logDataSelected.weights(curvesToUse);
    
    % Find the null value
    if isempty(logDataSelected.lasHeader) == false
        nanValue = str2double(extractValue('NULL', logDataSelected.lasHeader.well));
    else
        nanValue = -9999;
    end
    
    % Extract Data
    [selectedData, selectedDepth] = extractInterval(logDataSelected.data, logDataSelected.depth, logDataSelected.minDepth, logDataSelected.maxDepth);
    [selectedData, selectedCurves] = extractCurvesUsed(selectedData, curvesToUse, logDataSelected.curvesNames); 

    % Preprocess Data
    [~,dataPre] = preProcessData(selectedData, selectedDepth, nanValue, prepParameters.smoothspan);
    dataLog = applyLogTransformationOperation(dataPre, logVar,'apply');
    dataLogAll = [dataLogAll; dataLog];
end

% Normalization
if prepParameters.isnormalized == true 
    [dataLogAll, dataMean, dataSTD] = normalizeData(dataLogAll, normVar);
else
    dataMean = zeros(size(dataLogAll,2));
    dataSTD = ones(size(dataLogAll,2));
end

% Weights
[dataLogNormalizedWeighted] = applyWeightOperation(dataLogAll, weights, 'apply');

% PCA
if prepParameters.ispca == true
    [scoreUsed, latentUsed, coeffUsed, x, coeff, latent, nPrincipleComponents] = calculatePCA(dataLogNormalizedWeighted, prepParameters.pcaVarExplainedThresh);
else
    x = dataLogNormalizedWeighted';
    coeff=[]; coeffUsed=[];
    latent=[]; latentUsed=[];
    nPrincipleComponents=[]; scoreUsed=[];
end

% Clustering
switch clustParameters.method
    case 1
    [nodesWeights, net, initialClasses] = clusterUsingSOM(clustParameters.somWidth, clustParameters.somHeight, clustParameters.coverSteps, clustParameters.initNeighbor, clustParameters.topologyFcn, clustParameters.distanceFcn,   x, clustParameters.somEpochs);
end

% Hierarchal Clustersing
[E, mainScale] = estimateOptimalClusters(nodesWeights, hcaParameters.clusteringMethod, hcaParameters.optimalScaleMethod, hcaParameters.minnClasses, hcaParameters.maxnClasses, hcaParameters.isPlotOptimal);
[nodesHierarchy] = applyLinkageClustering(nodesWeights, hcaParameters.linkageMethod, hcaParameters.isPlotClustering, E);

mainScale = 4;
% Create Upscaling Tree
nNodes = size(nodesWeights, 1);
[upScaledClassesInitial, nodeClasses, upScalingCells, upscalingTree] = createUpscalingTree(nodesHierarchy, initialClasses, nNodes);

% Save Results
modelData = [];
modelData.coeffUsed = coeffUsed;
modelData.latentUsed = latentUsed;
modelData.scoreUsed = scoreUsed;
modelData.coeff = coeff;
modelData.weights = weights;
modelData.nodesWeights  = nodesWeights;
modelData.nodeClasses = nodeClasses;
modelData.mainScale = mainScale;
modelData.upscalingTree = upscalingTree;
modelData.upScalingCells = upScalingCells;
modelData.somWidth = clustParameters.somWidth;
modelData.somHeight = clustParameters.somHeight;
modelData.nNodes  = clustParameters.nNodes;
modelData.nPrincipleComponents = nPrincipleComponents;
modelData.latent = latent;
modelData.dataMean = dataMean;
modelData.dataSTD = dataSTD;
modelData.curveNames = selectedCurves;
modelData.isPCA  = prepParameters.ispca;
modelData.normVar = normVar;
modelData.logVar = logVar;
modelData.smoothSpan = prepParameters.smoothspan;
modelData.nodesHierarchy = nodesHierarchy;
modelData.colorMap = hsv(modelData.somWidth * modelData.somHeight);



end