function [selectedData, selectedCurves] = extractCurvesUsed(data, curvesUsed, curvesNames)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

if sum(curvesUsed) == 0
    selectedData = [];
    selectedCurves = [];
  
else

    selectedData = data(:,curvesUsed);

    if exist('curvesUsed', 'var')
        selectedCurves = curvesNames(curvesUsed);
    end

end


end