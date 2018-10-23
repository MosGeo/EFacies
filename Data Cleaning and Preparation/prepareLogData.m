function [data, dataAll, depth] = prepareLogData(logData)


curvesToUse = logData.curvesToUse;

if isempty(logData.lasHeader) == false
    nanValue = str2double(extractValue('NULL', logData.lasHeader.well));
else
    nanValue = -9999;
end



[dataAll, depth] = extractInterval(logData.data, logData.depth, logData.minDepth, logData.maxDepth);
[data, selectedCurves] = extractCurvesUsed(dataAll, curvesToUse, logData.curvesNames); 
[depth,data, nanRow] = preProcessData(data, depth, nanValue, 0);

dataAll(unique(nanRow),:) = [];


end
