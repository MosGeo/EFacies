% ===================================================
% Start
clear all
rng(842842)

% ===================================================
% Load and prepare XRF
mineralToUse = {'Quartz','Illite1', 'Calcite', 'Pyrite', 'Apatite3'};
elementsToUse = {'Ca', 'Si', 'Al', 'P', 'K', 'Fe'};
wellFolder = 'D:\Users\malibrah\OneDrive\Stanford\Project Cella\Data\Merak-1';
xrfFile = fullfile(wellFolder,'XRF_Clean.xlsx');
chemicalConstantsFile = 'D:\Users\malibrah\OneDrive\Stanford\Project Cella\Papers\Multi-Mineral Inversion of X-Ray Fluorescence Data\Code\ChemicalConstants.xlsx';
[Elements, Minerals] = LoadChemicalConstants(chemicalConstantsFile);
[header,sampleNames, xrfData] = ReadDataFile(xrfFile);
xrfData = FilterData(xrfData,elementsToUse);

% Convert XRF
[Aprime, AprimeTable] = ConstructAprimeMatrix(Minerals, elementsToUse, mineralToUse);
[results, resultsTable] = InvertToMinerals(Aprime, xrfData, mineralToUse, sampleNames);
[resultsVolume, resultsTableVolume] = MassToVolumeFraction(resultsTable, Minerals);
PlotResultsTable(resultsTableVolume,1)

% ===================================================
% TOC
tocfile = fullfile(wellFolder,'Carb.xlsx');
tocdata = loaddata(tocfile);
clear tocfile

% ===================================================
% Define the well used (name, logs, logrithmic, min depth, max depth, wellFolder)
depthUsed = (10729:1:10827)';
depthUsed = (10728:1:10824)';
age = [208, 220]';

wellFolder = 'D:\Users\malibrah\OneDrive\Stanford\Project Cella\Data\Alcor-1';
wellInputAll{1} = {'Alcor 1 LWD+WL TC+BAT.las', [2 4 6 11 15 20], [11], 10550, 10650, wellFolder};
wellFolder = 'D:\Users\malibrah\OneDrive\Stanford\Project Cella\Data\Merak-1';
wellInputAll{1} = {'Merak 1 LWD+Wireline merged.las', [3 7 15 25 33 13], [25], depthUsed(1),  depthUsed(end), wellFolder};
usedWells = [1];
variablesToPlot = 1:numel(wellInputAll{usedWells(1)}{2});
% ===================================================
% Load the well and preprocess
i = 1;
wellInput = wellInputAll{usedWells(i)};
[lasdata, depth, lasHeader]  = importLasFile(wellInput{1});
logData = constructLogDataStructure(wellInput, lasdata, depth, lasHeader);
clear curvesNames lasHeader depth data dataMean dataSTD

% ===================================================
% Build the model
prepParameters  = createPrepParameters(true, true, 100, 0);
clustParameters = createClusteringParameters(1,[5,5]);
hcaParameters   = createHCAParameters(3, 5, 'ward', true, true);
modelData = buildModel(logData, prepParameters, clustParameters, hcaParameters);
clear clustParameters hcaParameters prepParameters

% ===================================================
% Applying the Model
[classData] = applyModel(logData, modelData, variablesToPlot);

% ===================================================
% Classify outside data
%depthUsed = (10575:1:10650)';
%depthUsed = (10575:1:10585)';
%depthUsed = (10554:1:10645)';
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

xrfMeans = accumArrayMatrix(classes, xrf,[] , @nanmean)';
tocMeans = accumarraym(classes, toc,[] , @nanmean);
% ===================================================
% Convert To interval Data
dz = (depthUsed(2) - depthUsed(1))/2;
topInterval = depthUsed(1:end)-dz;
bottomInterval = depthUsed(1:end)+dz;

intervals = [topInterval  bottomInterval classes] ;
d = [diff(classes)~=0; 1];
endings = find(d);
starts = [1; endings(1:end-1)+1];
intervalsCompacted = [topInterval(starts)  bottomInterval(endings) classes(starts)];
thickness = intervalsCompacted(:,2) - intervalsCompacted(:,1);
thicknessProp = thickness/sum(thickness);
dt = thicknessProp*diff(age);
cumsumdt = cumsum(dt);


finalAge = num2cell(age(1) + [0; cumsumdt(1:end-1)]);
name =  cellfun(@(x) ['Shublik_' num2str(x)], num2cell((numel(finalAge):-1:1)'), 'UniformOutput', false);
top = num2cell(topInterval(starts));
thicknessFinal = num2cell(thickness);
layerType = repmat({'Deposition'}, numel(finalAge),1);
erosion = repmat({''}, numel(finalAge),1);
lithology = cellfun(@(x) ['Shublik_' num2str(classesLevel) '_' num2str(x)], num2cell(classes(starts)), 'UniformOutput', false);
pse = repmat({'Source Rock'}, numel(finalAge),1);
kinetics = repmat({'Burnham(1989)_TII'}, numel(finalAge),1);
toc = num2cell(tocMeans(classes(starts)))
hi = repmat({'525'},numel(finalAge),1)


table = [finalAge, name, top, thicknessFinal, layerType, name, erosion, lithology, pse, kinetics, toc, hi]
