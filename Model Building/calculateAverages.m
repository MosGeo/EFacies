function [means, uniqueClasses] = calculateAverages(nodesWeights, nodeClasses, mainScale)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

usedClasses = nodeClasses(:,end-mainScale+1);
uniqueClasses = unique(usedClasses);


means = cell(numel(uniqueClasses), 3);
for i = 1:numel(uniqueClasses)

    selectedClass = uniqueClasses(i);
    selectedIndexes = usedClasses == selectedClass;
    selectedData = nodesWeights(selectedIndexes,:);
     
    arithmaticMean = mean(selectedData,1);    
    harmmeanMean = harmmean(selectedData,1);
    
    if sum(sum(selectedData<0))>0
        geometricMean = nan;
    else
        geometricMean =  geomean(selectedData,1);
    end
    
    means{i,1} = arithmaticMean;
    means{i,2} = geometricMean;
    means{i,3} = harmmeanMean;

end

end
