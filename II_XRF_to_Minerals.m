% Load and prepare XRF

selectedMineralsNames = {'Quartz','Illite_K_Rich', 'Calcite', 'Pyrite', 'Apatite_F_Rich'};
elementsToUse = {'Ca', 'Si', 'Al', 'P', 'K', 'Fe'};
xrfFile = fullfile(wellFolder,'XRF_Clean.xlsx');

elementsFileName      = 'C:\Users\malibrah\Documents\GitHub\Madini\Source code\Elements.csv';
mineralFileName = 'C:\Users\malibrah\Documents\GitHub\Madini\Source code\Minerals.csv';
[Elements, Minerals] = LoadChemicalConstants(elementsFileName, mineralFileName);
Minerals = AnalyzeMinerals(Elements, Minerals);

Data = readtable(xrfFile, 'ReadRowNames',true);


% Convert XRF
availableElements = Data.Properties.VariableNames(2:end);
[ selectedMinerals ] = selectMineralsByName( Minerals, selectedMineralsNames)
[~, possibleElements] = getPossibleMinerals(selectedMinerals, availableElements)

[Aprime, AprimeTable] = ConstructAprimeMatrix(Minerals, elementsToUse, selectedMineralsNames);
dataToUse = FilterData(Data,elementsToUse);
[resultsTable, inputTable] = InvertToMinerals(Aprime, dataToUse, selectedMineralsNames);
[resultsTableVolume] = MassToVolumeFraction(resultsTable, Minerals);


selectedMineralsNames = {'Quartz','Illite_K_Rich', 'Calcite'};

resultsTableVolume = FilterData(resultsTableVolume, selectedMineralsNames)
xrf     = interp1(tableDepth(resultsTableVolume),table2array(resultsTableVolume), depth);
