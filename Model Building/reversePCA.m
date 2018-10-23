function [data] = reversePCA(coeffUsed, nodesWeights, latentUsed)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


scoreUsedLatentRemoved = (nodesWeights ./ repmat(latentUsed',size(nodesWeights,1), 1));

data = (coeffUsed*scoreUsedLatentRemoved')';


end

