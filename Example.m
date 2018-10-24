% Define the well used (name, logs, logrithmic, min depth, max depth)
depthUsed = (10729:1:10827)';
depthUsed = (10728:1:10824)';
age = [208, 220]';

wellFolder = 'Data/Alcor-1';
wellInputAll{1} = {fullfile(wellFolder, 'Logs.las'), [2 4 6 11 15 20], [11], 10550, 10650, wellFolder};
wellFolder = 'Data/Merak-1';
wellInputAll{2} = {fullfile(wellFolder, 'Logs.las'), [3 7 15 25 33 13], [25], depthUsed(1),  depthUsed(end), wellFolder};

usedWell = 1;
wellInput = wellInputAll{usedWell};
variablesToPlot = 1:numel(wellInputAll{usedWell}{2});


%%

% Well log classification
I_Well_Log_Classification

% XRF to Minerals
II_XRF_to_Minerals
