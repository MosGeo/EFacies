% ===================================================
% Define the well used (name, logs, logrithmic, min depth, max depth)
depthUsed = (10729:1:10827)';
depthUsed = (10728:1:10824)';
age = [208, 220]';

wellFolder = 'D:\Users\malibrah\OneDrive\Stanford\Project Cella\Data\Alcor-1';
wellInputAll{1} = {'Alcor 1 LWD+WL TC+BAT.las', [2 4 6 11 15 20], [11], 10550, 10650};
wellFolder = 'D:\Users\malibrah\OneDrive\Stanford\Project Cella\Data\Merak-1';
wellInputAll{1} = {'Merak 1 LWD+Wireline merged.las', [3 7 15 25 33 13], [25], depthUsed(1),  depthUsed(end)};

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
