function [uniqueClasses, meansMatrix, means] = performMeanAnalysis(modelData, mainScale)

% Mean Analysis
if modelData.isPCA == true
    [reversedDataNormalized]    = reversePCA(modelData.coeffUsed, modelData.nodesWeights, modelData.latentUsed);
else
    reversedDataNormalized      = nodesWeights;
end
[dataLogNormalizedWeighted] = applyWeightOperation(reversedDataNormalized, modelData.weights, 'remove');
[ReversedDataLog]           = reverseNormalization(dataLogNormalizedWeighted, modelData.dataMean, modelData.dataSTD);
[ReversedData]              = applyLogTransformationOperation(ReversedDataLog, modelData.logVar,'remove');
[means, uniqueClasses]      = calculateAverages(ReversedData, modelData.nodeClasses, mainScale);

meansType = 1;
meansMatrix = cell2mat(means(:,meansType));

end
