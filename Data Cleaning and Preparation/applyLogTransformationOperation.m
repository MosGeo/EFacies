function [data] = applyLogTransformation(dataPre, logVar, applyOrRemove)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

data = dataPre;
if strcmp(applyOrRemove, 'apply') == true
    data(:, logVar) = log(dataPre(:, logVar));
elseif strcmp(applyOrRemove, 'remove') == true
    data(:, logVar) = 10.^dataPre(:, logVar);
end
    

end

