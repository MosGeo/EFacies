function [stochasticClasses, probability, maxClasses] = classifyStochastically(nodesWeights, x, isMax, distanceExpo)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here


nDataPoints =  size(x,2);
nNodes = size(nodesWeights,1);

A = transpose(nodesWeights);
stochasticClasses = zeros(nDataPoints,1);
maxClasses = zeros(nDataPoints,1);


p = randperm(nDataPoints);

for k = 1: nDataPoints
    
i = p(k);

D = pdist([x(:,i)' ; A'],'euclidean');
dist2 = squareform(D);
dist2 = dist2(1, 2:end);
prop1 = (1./(dist2+.0000000000000000000001)).^distanceExpo;

prop1 = exp(-dist2.^2/(min(dist2) + .0000000000000000000001));

prop = prop1/sum(prop1);

%stochasticClasses(i) = randsample(1:nNodes, 1, true, abs(prop));
[maxValue,   maxClasses(i)] = max(prop);

probability{i} = prop;

end

if isMax == true
    stochasticClasses = maxClasses;
end


end

