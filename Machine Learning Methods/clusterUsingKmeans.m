function [initialClasses, nodesWeights] = clusterUsingKmeans(x, nNodes)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here


[initialClasses,nodesWeights] = kmeans(x',nNodes) ;


end

