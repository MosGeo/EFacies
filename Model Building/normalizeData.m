function [dataNormalized, dataMean, dataSTD] = normalizeData(data, normVar, dataMean, dataSTD)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

nSamples = size(data,1);

if exist('normVar', 'var') == false
    normVar = ones(size(data,2), 1);
end

if exist('dataMean', 'var') == false
    dataMean = mean(data);
end

if exist('dataSTD', 'var') == false
    dataSTD = std(data);
end


dataMeanVector = repmat(dataMean, [nSamples, 1]);
dataSTDVector = repmat(dataSTD, [nSamples, 1]);

dataNormalized = data;

dataNormalized(:,normVar) = (data(:, normVar) - dataMeanVector (:, normVar))./dataSTDVector (:, normVar);



end

