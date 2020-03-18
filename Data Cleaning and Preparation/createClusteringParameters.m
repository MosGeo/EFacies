function clustParameters = createClusteringParameters(method, parameters)

switch method
    case 1
        clustParameters.method = 1;
        clustParameters.methodname = 'SOM';
        clustParameters.somWidth = parameters(1);
        clustParameters.somHeight = parameters(2);
        clustParameters.somEpochs = 5000;
        clustParameters.initNeighbor = 3;
        clustParameters.topologyFcn = 'hextop';
        clustParameters.coverSteps = 100;
        clustParameters.distanceFcn = 'linkdist';
        clustParameters.nNodes = clustParameters.somWidth*clustParameters.somHeight;
    case 2
         clustParameters.method = 2;
         clustParameters.methodname = 'K-means';
         clustParameters.nclusters = parameters(1);
    
    case 3
         clustParameters.method = 3;
         clustParameters.methodname = 'none';
    case 4
        
end



end