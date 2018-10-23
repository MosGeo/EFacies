function [ReversedData] = reverseNormalization(dataNormalized, dataMean, dataSTD)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


nSamples = size(dataNormalized,1);
dataMeanVector = repmat(dataMean, [nSamples, 1]);
dataSTDVector = repmat(dataSTD, [nSamples, 1]);


ReversedData = (dataNormalized .* dataSTDVector)+ dataMeanVector;


end

