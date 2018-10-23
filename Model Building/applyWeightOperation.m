function [tranformedData] = applyWeightOperation(dataNormalized, curvesWeights, applyOrRemove)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



if strcmp(applyOrRemove, 'apply') == true
    tranformedData =  dataNormalized .* repmat(curvesWeights',size(dataNormalized,1),1);
elseif strcmp(applyOrRemove, 'remove') == true
    tranformedData =  dataNormalized ./ repmat(curvesWeights',size(dataNormalized,1),1);
else
    tranformedData = dataNormalized;
end



end

