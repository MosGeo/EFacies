function [nodesHierarchy] = applyLinkageClustering(nodesWeights, linkageMethod, isPlotClustering,E)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here



nodesHierarchy = linkage(nodesWeights, linkageMethod);

if isPlotClustering == true
    D = pdist(nodesWeights);
    leafOrder = optimalleaforder(nodesHierarchy,D);
    figure
    
    if exist('E','var')
        H = dendrogram(nodesHierarchy,0,'Reorder',leafOrder, 'ColorThreshold',nodesHierarchy(end-E.OptimalK+2,3));
    else
        H = dendrogram(nodesHierarchy,0,'Reorder',leafOrder, 'ColorThreshold','default');
    end
    set(H,'LineWidth',2)
    box on
    xlabel('Electrofacies')
    ylabel('Fusion Level')
    set(gcf, 'Color', 'white')
    if size(nodesWeights, 1) >64
        set(gca,'xticklabel',{[]}) 
        set(gca,'xtick',[])
    end
end


end

