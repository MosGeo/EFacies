function HCAParameters = createHCAParameters(minnClasses, maxnClasses, linkageMethod, isPlotOptimal, isPlotClustering)


% Default parameters
if exist('minnClasses', 'var')==false;  minnClasses=0; end
if exist('maxnClasses', 'var')==false;  maxnClasses=inf; end
if exist('linkageMethod', 'var')==false;  linkageMethod='ward'; end
if exist('isPlotOptimal', 'var')==false;  isPlotOptimal=false; end
if exist('isPlotClustering', 'var')==false;  isPlotClustering=false; end

% Create the parameter structure
HCAParameters.minnClasses = minnClasses;
HCAParameters.maxnClasses = maxnClasses;
HCAParameters.optimalScaleMethod = 'DaviesBouldin'; %Options: silhouette, gap,DaviesBouldin, CalinskiHarabasz
HCAParameters.clusteringMethod = 'linkage';
HCAParameters.linkageMethod = linkageMethod;
HCAParameters.isPlotOptimal = isPlotOptimal;
HCAParameters.isPlotClustering = isPlotClustering;

end