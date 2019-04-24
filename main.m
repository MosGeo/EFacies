clear
close all
% ===================================================
% Define input parameters (las file, log numbers in las, logrithmic logs, startDepth, endDepth)
wellFolder = 'Data/Alcor-1';
wellInput = {fullfile(wellFolder, 'Logs.las'), [2 4 6 11 15 20], [11], 10550, 10650};
variablesToPlot = 1:numel(wellInput{2});
% ===================================================
% Load the well and preprocess
[data, lasDepth, lasHeader]  = importLasFile(wellInput{1});
logData = constructLogDataStructure(wellInput, data, lasDepth, lasHeader);
clear curvesNames lasHeader lasDepth data dataMean dataSTD
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
