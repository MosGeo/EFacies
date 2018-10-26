% Define the well used (name, logs, logrithmic, min depth, max depth)
clear all
depth = (10728:1:10824)';
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
class = getClassFromDepth(classData{1}, depth, classesLevel);
class = renumberClass(class);

mineralMeanTable = classMean(class, xrf, selectedMineralsNames);
tocMeanTable     = classMean(class, toc, {'TOC'});

[intervalTable] = point2Interval(class, depth, age,true);

%% Model building

finalAge = intervalTable.EndAge
topInterval = intervalTable.StartDepth

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
