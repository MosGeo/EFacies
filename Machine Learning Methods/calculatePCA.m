function [scoreUsed, latentUsed, coeffUsed, x, coeff, latent, nPrincipleComponents] = calculatePCA(dataNormalized, pcaVarExplainedThresh)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


[coeff,score,latent,tsquared,explained,mu] = pca(dataNormalized);
varExplianedCom = cumsum(explained);
nPrincipleComponents = find(pcaVarExplainedThresh <= varExplianedCom,1,'first');

if isempty(nPrincipleComponents) == true
  nPrincipleComponents = numel(varExplianedCom);
end
    

scoreUsed = score(:,1:nPrincipleComponents);
latentUsed = latent(1:nPrincipleComponents);
coeffUsed = coeff(:,1:nPrincipleComponents);

x = (scoreUsed.*repmat(latentUsed',size(scoreUsed,1), 1))';



end

