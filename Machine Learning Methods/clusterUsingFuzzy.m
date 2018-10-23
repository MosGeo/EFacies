function [initialClasses, nodesWeights] = clusterUsingFuzzy(x, nNodes)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

[nodesWeights,initialClasses,obj_fcn] = fcm(x',nNodes);
[M,initialClasses] =max(initialClasses);

end

