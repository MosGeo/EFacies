% ===================================================
% Load the well and preprocess
[data, depth, lasHeader]  = importLasFile(wellInput{1});
logData = constructLogDataStructure(wellInput, data, depth, lasHeader);
clear curvesNames lasHeader depth data dataMean dataSTD
% ===================================================
% Build the model
prepParameters  = createPrepParameters(true, true, 100, 0);
clustParameters = createClusteringParameters(1,[5,5]);
hcaParameters   = createHCAParameters(3, 5, 'ward', true, true);
modelData = buildModel(logData, prepParameters, clustParameters, hcaParameters);
clear clustParameters hcaParameters prepParameters
% ===================================================
% Applying the Model
[classData] = applyModel(logData, modelData, variablesToPlot);
% ===================================================
