function [rawData, depth] = extractInterval(rawData, depth, minDepth, maxDepth)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

[depth, index] = constrainVectorMinMax(depth, minDepth, maxDepth);
rawData(~index,:) = [];

end

