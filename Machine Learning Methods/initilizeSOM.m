function [net] = initilizeSOM(somWidth, somHeight , coverSteps, initNeighbor, topologyFcn, distanceFcn)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

dimensions = [somWidth somHeight];
net = selforgmap(dimensions , coverSteps, initNeighbor, topologyFcn, distanceFcn);
net = init(net);

end

