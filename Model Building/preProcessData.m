function [depthWithoutNaN,smoothedData, nanRow] = preProcessData(rawData, depth, nanValue, smoothSpan)
%preProcessData Summary of this function goes here
%   Detailed explanation goes here

% Remove rows with non-measurments
[nanRow,~] = find(rawData==nanValue);
rawDataWihtoutNan = rawData;
depthWithoutNaN = depth;
rawDataWihtoutNan(unique(nanRow),:) = [];
depthWithoutNaN(unique(nanRow),:) = [];


% SMOOTH IF REQUIRED
smoothedData = rawDataWihtoutNan;

if exist('smoothSpan', 'var') == true
    if smoothSpan >0
        for i =1:size(smoothedData,2)
            smoothedData(:,i) = smooth(rawDataWihtoutNan(:,i), smoothSpan);
        end
    end
end



end

