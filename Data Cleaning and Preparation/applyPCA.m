function [scoreUsed, coeffUsed, x] = applyPCA(dataNormalizedWeighted, coeff, nPrincipleComponents, latent)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


score = (inv(coeff)*dataNormalizedWeighted')';


scoreUsed = score(:,1:nPrincipleComponents);
latentUsed = latent(1:nPrincipleComponents);
coeffUsed = coeff(:,1:nPrincipleComponents);

x = (scoreUsed.*repmat(latentUsed',size(scoreUsed,1), 1))';

end

