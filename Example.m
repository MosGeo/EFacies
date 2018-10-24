% Define the well used (name, logs, logrithmic, min depth, max depth)
depthUsed = (10728:1:10824)';
age = [208, 220]';

wellFolder = 'Data/Alcor-1';
wellInputAll{1} = {fullfile(wellFolder, 'Logs.las'), [2 4 6 11 15 20], [11], 10550, 10650, wellFolder};

wellFolder = 'Data/Merak-1';
wellInputAll{2} = {fullfile(wellFolder, 'Logs.las'), [3 7 15 25 33 13], [25], 10728,  10824, wellFolder};

usedWell = 2;
wellInput = wellInputAll{usedWell};
variablesToPlot = 1:numel(wellInputAll{usedWell}{2});

wellFolder = wellInput{end};

%%

% Well log classification
I_Well_Log_Classification

% XRF to Minerals
II_XRF_to_Minerals

% TOC
III_TOC

%%

classesLevel = 10;
xrf     = interp1(tableDepth(resultsTableVolume),table2array(resultsTableVolume), depthUsed);
toc     = interp1(tocdata.Depth, tocdata.TOCPerc, depthUsed);

classes = getClassFromDepth(classData{1}, depthUsed, classesLevel);
uniqueclasses = unique(classes);

classesOrig = classes;
for i = 1:classesLevel
   classes(classesOrig==uniqueclasses(i)) = i;
end

mineralMeanTable = classMean(classes, xrf, selectedMineralsNames);
tocMeanTable     = classMean(classes, toc, {'TOC'});