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

%% Run workflows

% Well log classification
I_Well_Log_Classification

% XRF to Minerals
II_XRF_to_Minerals

% TOC
III_TOC

%% Upscale to desiered Scale

% Set up the model
PMDirectory = 'C:\Program Files\Schlumberger\PetroMod 2017.1\WIN64\bin';
PMProjectDirectory = 'C:\EFacies BPSM\BPSM 2017';
PM = PetroMod(PMDirectory, PMProjectDirectory);
formationName = 'Shublik';

PM.loadLithology();

for i = 25:-1:1

classesLevel =  i ;
class = getClassFromDepth(classData{1}, depth, classesLevel);
class = renumberClass(class);

mineralMeanTable = classMean(class, xrf, selectedMineralsNames);
tocMeanTable     = classMean(class, toc, {'TOC'});

[intervalTable] = point2Interval(class, depth, age,true);

% Create lithologies
% 
fractions = mineralMeanTable{:,:};
sourceLithologies = {'Sandstone (typical)', 'Shale (typical)', 'Limestone (organic rich - 1-2% TOC)'};
mixerType = 'V';
outputPrefix = [formationName, '_', num2str(classesLevel)];
groupName = 'BPSM ToolBox';
subGroupName = ['Scale_', num2str(classesLevel)];

[petroModIds] = patchMixer(fractions, sourceLithologies, PM, mixerType, outputPrefix, groupName, subGroupName);

lithoPMIds{i} = petroModIds;
%PM.restoreProject();

end
PM.saveLithology();


%% Create Models

% Create PetroMod Table
for i = 25:-1:1
classesLevel =  i ;
class = getClassFromDepth(classData{1}, depth, classesLevel);
class = renumberClass(class);

mineralMeanTable = classMean(class, xrf, selectedMineralsNames);
tocMeanTable     = classMean(class, toc, {'TOC'});

[intervalTable] = point2Interval(class, depth, age,false);


nRows = size(intervalTable,1);

TopID  = num2cell((100:100+nRows-1)');
TopAge = num2cell(intervalTable.EndAge);
TopName = numberString([formationName '_' num2str(classesLevel)], nRows);
PresentDayDepth = num2cell(intervalTable.StartDepth/3.2808399);
PresentDayThickness = num2cell((intervalTable.EndDepth - intervalTable.StartDepth)/3.2808399);
EventType = num2cell(zeros(nRows,1));
LayerName = TopName;
LayerType = repmat({'Deposition'}, nRows,1);
PaleoDifference = num2cell(repmat(99999, nRows,1));
PaleoBalance = num2cell(repmat(99999, nRows,1));
Lithology = num2cell(cellfun(@eval, lithoPMIds{i}(intervalTable.Class)));
PSE = num2cell(2*ones(nRows,1));
KineticUUID = repmat({'03d79ac0-208f-4480-890c-efbcaaba9b0a'}, nRows,1);
TOC = num2cell(tocMeanTable.TOC(intervalTable.Class));
HI = num2cell(repmat(525, nRows,1));
ColorLayer = num2cell(repmat(-1, nRows,1));
ColorFacies = num2cell(repmat(-1, nRows,1));
ToolUsage   = num2cell(repmat(-1, nRows,1));
ThrustFromAge = num2cell(repmat(99999, nRows,1));

highResPMTable = [TopID, TopAge, TopName, PresentDayDepth, PresentDayThickness, EventType, LayerName,...
    PaleoDifference, PaleoBalance, Lithology, PSE, KineticUUID, TOC, HI, ColorLayer,...
    ColorFacies, ToolUsage, ThrustFromAge];

% Model modification

templateModel = 'Merak';
newModel = ['Merak_', num2str(classesLevel)];
nDim = 1;

% Load and dublicate the model
PM = PetroMod(PMDirectory, PMProjectDirectory);
PM.deleteModel(newModel, nDim);
PM.dublicateModel(templateModel, newModel, nDim);
model = Model1D(newModel, PMProjectDirectory);

% Update the number of runs (needed to be high for high resolution modeling
% in order for the results to converge.
% model.printTable('Simulation')
model.updateData('Simulation', 8, 'Ooru');
model.updateData('Simulation', 2, 'Omig1');

% Find the Shublik Formation
%model.printTable('Main');

mainData = model.getData('Main');
formationIndex = find(ismember(mainData(:,3), 'Shublik'));
mainData(formationIndex,:)=[];

% Inserting the new rows
highResPMTable = insertRow(mainData, highResPMTable, formationIndex);
model.updateData('Main', highResPMTable);
model.updateModel();

end

%% Simulate Models

for i = 25:-1:1
    
    classesLevel =  i ;
    newModel = ['Merak_', num2str(classesLevel)];
    nDim = 1;
    [output] = PM.simModel(newModel, nDim, true);

end

%% Run scripts

layerNumbers = [3, 7, 103, 18, 97];
layerNames   = {'Layer', 'Depth', 'Porosity', 'PorePressure', 'TR'};
for i = 25:-1:1
   
    classesLevel =  i
    newModel = ['Merak_', num2str(classesLevel)];
    
    data{classesLevel} = []; 
    for iLayer = 1:numel(layerNumbers)
        [cmdout, status] = PM.runScript(newModel, 1, 'demo_opensim_output_3rd_party_format', num2str(layerNumbers(iLayer)), false); 
        [id, value, layer, unit] = readDemoScriptOutput('demo_1.txt');
        data{classesLevel} = [data{classesLevel}, value];
    end
end

delete('demo_1.txt')


%% Plotting
qs = Qias();

meanValues = [];
figure('Color', 'White')
layerIndex = 3
for i = 25:-3:1
    classesLevel =  i ;
    
    depthToPlot = [data{classesLevel}(2:end,2); 14.6304];
    [depthToPlot] = (qs.convert(depthToPlot, 'm', 'ft', 'Distance'));
    dataToPlot = data{classesLevel}(:,layerIndex);
    
    indexToKeep = depthToPlot>= min(depth) & depthToPlot<= max(depth);
    depthToPlot = depthToPlot(indexToKeep);
    dataToPlot  = dataToPlot(indexToKeep);
    
    plot(dataToPlot, depth);
    hold on
    meanValues(i) = mean(dataToPlot);
end

set(gca, 'yDir', 'reverse')

