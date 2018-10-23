function [E, mainScale] = estimateOptimalClusters(data,clusteringMethod, optimalScaleMethod, minnClasses, maxnClasses, isPlotOptimal)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


E = evalclusters(data,clusteringMethod,optimalScaleMethod,'klist',[minnClasses:maxnClasses]);
mainScale = E.OptimalK;


if isPlotOptimal == true
figure
plot(E); 
set(gcf, 'Color', 'white')
end


end

