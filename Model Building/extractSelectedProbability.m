function [selectedProb] = extractSelectedProbability(probability, stochasticClasses, upScalingCells, mainScale)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

nDataPoints = numel(stochasticClasses);
selectedProb = zeros(nDataPoints, 1);
usedScaling  =    upScalingCells{end-mainScale+1}; % get scale grouping

%# find empty cells
emptyCells = cellfun(@isempty,usedScaling);
usedScaling(emptyCells) = [];

for i = 1:nDataPoints

usedProbablity = probability{i}; % Get PDF of sample
pickedCells = num2cell(repmat(stochasticClasses(i),1,numel(usedScaling)));
pickedIndex1 = cellfun(@ismember, usedScaling, pickedCells,  'UniformOutput', false);
pickedIndex = find(cellfun(@sum,pickedIndex1));

selectedProb(i) =sum(usedProbablity(usedScaling{pickedIndex}));

end

end

