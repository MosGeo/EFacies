function [net, tr] = trainSOM(net, trainingData, somEpochs)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

net.trainParam.epochs = somEpochs;
net.trainParam.showWindow = false;
net.trainParam.showCommandLine = true;
[net, tr] = train(net,trainingData);

class(net)


end

