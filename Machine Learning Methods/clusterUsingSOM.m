function [nodesWeights, net, initialClasses] = clusterUsingSOM(somWidth, somHeight, coverSteps, initNeighbor, topologyFcn, distanceFcn,   x, somEpochs)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

% SOM Map
[net] = initilizeSOM(somWidth, somHeight , coverSteps, initNeighbor, topologyFcn, distanceFcn);


% Train SOM
[net, tr] = trainSOM(net, x, somEpochs);

nodesWeights = net.IW{1};
%[somFigure] = plotSOMPlanes(net);

% Visualize Training
%[output_args] = showSomTraining(net, x, somEpochs, 500);
%[output_args] = showSomTraining(net, x, 1, 100);

% Classify Nodes
[initialClasses] = classifySOM(net, x);


end

