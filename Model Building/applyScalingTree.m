function [upscaledClasses] = applyScalingTree(upscalingTree, classes)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

upscaledClasses = classes;
for i = 1:size(upscalingTree,1)
    currentClasses = upscaledClasses(:,i);
    firstClass = upscalingTree(i,1);
    secondClass =  upscalingTree(i,2);

    winIndex = upscalingTree(i,3);
    loseIndex = 2-upscalingTree(i,3)+1;
    winningClass = upscalingTree(i, winIndex);
    losingClass = upscalingTree(i,loseIndex);
     
    currentClasses(currentClasses == losingClass) = winningClass;
    
    upscaledClasses(:,i+1) = currentClasses;
end

end

