function [dataClasses, nodeClasses, upScalingCells, Znew] = createUpscalingTree(nodesHierarchy, dataClasses, nNodes)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here


Znew = nodesHierarchy(:,1:2);
Znew = [Znew zeros(size(Znew,1),1)];
upScalingCells{1}= num2cell(1:nNodes);

nodeClasses = (1:nNodes)';

for i = 1:size(nodesHierarchy,1)
    
    currentClasses = dataClasses(:,i);
    currentNodeClasses = nodeClasses(:,i);
    currentUpScalingCells = upScalingCells{i};
    
    firstClass = Znew(i,1);
    firstClassCount = sum(currentClasses == firstClass);
    
    secondClass =  Znew(i,2);
    secondClassCount = sum(currentClasses == secondClass);

        if firstClassCount >= secondClassCount
            winningClass = firstClass;
            Znew(i,3) = 1;
            losingClass = secondClass;
           %disp([num2str(winningClass) ' wins over ' num2str(losingClass) ' by ' num2str(firstClassCount) ' to ' num2str(secondClassCount)])

        else
            winningClass = secondClass;
            losingClass = firstClass;
            Znew(i,3) = 2;
            %disp([num2str(winningClass) 'wins over' num2str(losingClass) ' by ' num2str(secondClassCount) ' to ' num2str(firstClassCount)])
        end
        

    Znew(Znew == nNodes+i) = winningClass;
    
    currentClasses(currentClasses == losingClass) = winningClass;
    currentNodeClasses(currentNodeClasses == losingClass)  =  winningClass;
    
    dataClasses(:,i+1) = currentClasses;
    nodeClasses(:,i+1) = currentNodeClasses;
    
    loserCells = num2cell(repmat(losingClass,1,nNodes));
    loserIndex1 = cellfun(@ismember, currentUpScalingCells, loserCells,  'UniformOutput', false);
    loserIndex = find(cellfun(@sum,loserIndex1));
    
    winnerCells = num2cell(repmat(winningClass,1,nNodes));
    winnerIndex1 = cellfun(@ismember, currentUpScalingCells, winnerCells,  'UniformOutput', false);
    winnerIndex = find(cellfun(@sum,winnerIndex1));
    
    newUpscalingClass = currentUpScalingCells;
    newUpscalingClass{winnerIndex} = [newUpscalingClass{winnerIndex}  newUpscalingClass{loserIndex}] ;
    newUpscalingClass{loserIndex} = [];
    upScalingCells{i+1} = newUpscalingClass;
    
end

upScaledClasses = dataClasses;


end

