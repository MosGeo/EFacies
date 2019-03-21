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
PMDirectory = 'C:\Program Files\Schlumberger\PetroMod 2018.2\WIN64\bin';
PMProjectDirectory = 'C:\PetroMod\Shublik';
PM = PetroMod(PMDirectory, PMProjectDirectory);
formationName = 'Shublik';

PM.loadLithology();
PM.restoreProject();

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
mixType = 'V';

outputPrefix = [formationName, '_', num2str(classesLevel)];
groupName = 'BPSM ToolBox';
subGroupName = ['Scale_', num2str(classesLevel)];

mixer = LithoMixerMos(mixType);    % V for layerd and H for homogeneous 

for j = 1:size(mineralMeanTable,1)
     lithoName = [outputPrefix, '_' , num2str(j)];
     PM.Litho.mixLitholgies(sourceLithologies, fractions(j,:), lithoName , mixer);  
     PM.Litho.changeLithologyGroup(lithoName, groupName, subGroupName)
     [~, currentIds{j}]   = PM.Litho.getLithologyId(lithoName);
end

lithoPMIds{i} = currentIds;
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

    %[intervalTable] = point2Interval(class, depth, age,false);
    class = class(1:end-1);
    nRows = size(class,1);
    
    
    PresentDayThickness = num2cell(ones(numel(class),1));
    EndAge = age(1) + range(age) * (0:numel(class)-1)' / numel(class);
    TopAge = num2cell(EndAge);
    PresentDayDepth = num2cell(depth(1:end-1)/3.2808399);
    
    TopID  = num2cell((100:100+nRows-1)');
    %TopAge = num2cell(intervalTable.EndAge);
    TopName = numberString([formationName '_' num2str(classesLevel)], nRows);
    
    %PresentDayDepth = num2cell(intervalTable.StartDepth/3.2808399);
    %PresentDayThickness = num2cell((intervalTable.EndDepth - intervalTable.StartDepth)/3.2808399);
    
    EventType = num2cell(zeros(nRows,1));
    LayerName = TopName;
    LayerType = repmat({'Deposition'}, nRows,1);
    PaleoDifference = num2cell(repmat(99999, nRows,1));
    PaleoBalance = num2cell(repmat(99999, nRows,1));
    LithoUUID = lithoPMIds{i}(class)';
    PSE = num2cell(2*ones(nRows,1));
    KineticUUID = repmat({'03d79ac0-208f-4480-890c-efbcaaba9b0a'}, nRows,1);
    TOC = num2cell(tocMeanTable.TOC(class));
    HI = num2cell(repmat(525, nRows,1));
    ColorLayer = num2cell(repmat(-1, nRows,1));
    ColorFacies = num2cell(repmat(-1, nRows,1));
    ToolUsage   = num2cell(repmat(-1, nRows,1));
    ThrustFromAge = num2cell(repmat(99999, nRows,1));
    Lithology   = num2cell(repmat(-1, nRows,1));

    highResPMTable = [TopID, TopAge, TopName, PresentDayDepth, PresentDayThickness, EventType, LayerName,...
            PaleoDifference, PaleoBalance, LithoUUID, PSE, KineticUUID, TOC, HI, ColorLayer,...
            ColorFacies, ToolUsage, ThrustFromAge, Lithology];

    % Model modification
    templateModel = 'Merak';
    newModel = ['Merak_', num2str(classesLevel)];
    nDim = 1;

    % Load and dublicate the model
    PM = PetroMod(PMDirectory, PMProjectDirectory);
    PM.deleteModel(newModel, nDim);
    PM.duplicateModel(templateModel, newModel, nDim);
    model = Model1D(newModel, PMProjectDirectory);

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

[cmdout] = getAvailableOverlays(newModel, nDim, PM);

overlayNumbers = [8, 22, 111, 84, 158];
data = []; overlayNames = []; units = [];
nDim = 1
for i = 25:-1:1
   classesLevel = i;
   disp(['Reading output for model with scale ' num2str(classesLevel)]);
    newModel = ['Merak_', num2str(classesLevel)];
   [data{i}, overlayNames, units] = loadOutputOverlays(newModel, nDim, PM, overlayNumbers);
end


%% Plotting

meanValues = [];
layerIndecies = [2:numel(overlayNumbers)];
legendText = [];
meanMatrix=[];
scalesToPlot = 1:5:25;

figure('Color', 'White', 'Units','inches', 'Position',[3 3, (numel(layerIndecies)+1)*2.2, 4],'PaperPositionMode','auto');
for i = 1:numel(scalesToPlot)
    scale =  scalesToPlot(i) ; 
    for j =1:numel(layerIndecies)
        layerIndex = layerIndecies(j);
        depthToPlot = data{scale}(:,1);
        dataToPlot  = data{scale}(:,layerIndex);
        indexToKeep = depthToPlot>= 10728/3.2808399 & depthToPlot<= 10824/3.2808399;
        depthToPlot = depthToPlot(indexToKeep);
        dataToPlot  = dataToPlot(indexToKeep);
        
        subplot(1,numel(layerIndecies)+1, j+1)
        stairs(dataToPlot, depthToPlot, 'LineWidth',2); hold on;
        xlabel(units{layerIndex});
        hold on
        meanMatrix(i,j) = mean(dataToPlot);
        legendText{i} = num2str(scalesToPlot(i));
    end
end

for j =1:numel(layerIndecies)
    layerIndex = layerIndecies(j);
    subplot(1,numel(layerIndecies)+1, j+1)
    set(gca, 'yDir', 'reverse')
    title(overlayNames{layerIndex}, 'interpreter', 'none')
    ylabel('Depth (m)')
    set(gca, 'FontUnits','points', 'FontWeight','normal', 'FontSize',12, 'FontName','Times')
    set(gca, 'yticklabel',[])  
    ylabel('')
end

% subplot(1,numel(layerIndecies)+1, 1)    
% plotStrata(strataOrig, true, true);
% %xlabel(['Scale: ', num2str(0)])
% set(gca, 'FontUnits','points', 'FontWeight','normal', 'FontSize',12, 'FontName','Times')
% ylabel('Depth (m)');
    
subplot(1,numel(layerIndecies)+1, numel(layerIndecies)+1)    
legend(legendText, 'Location', 'East', 'Position', [.95 .53, .0, .0])

%% 
overlayNamesMod = overlayNames;
overlayNamesMod = cellfun(@(x) strrep(x,' ','_'), overlayNamesMod, 'UniformOutput', false);
overlayNamesMod = cellfun(@(x) strrep(x,'(',''), overlayNamesMod, 'UniformOutput', false);
overlayNamesMod = cellfun(@(x) strrep(x,')',''), overlayNamesMod, 'UniformOutput', false);

array2table(meanMatrix, 'VariableNames', overlayNamesMod(layerIndecies), 'RowNames', legendText)
figure('Color', 'White', 'Units','inches', 'Position',[3 3, 6, 3.5],'PaperPositionMode','auto');
plot(scalesToModel, meanMatrix(:,1), 'LineWidth', 2);
xlabel('Scale'); ylabel('Average pore pressure')
    set(gca, 'FontUnits','points', 'FontWeight','normal', 'FontSize',12, 'FontName','Times')

