% Set up the model
PMDirectory = 'C:\Program Files\Schlumberger\PetroMod 2017.1\WIN64\bin';
PMProjectDirectory = 'C:\EFacies BPSM\Tests';
PM = PetroMod(PMDirectory, PMProjectDirectory);

PM.loadLithology();

mixer = LithoMixer('V');
rockName = 'SandShale5050V';

fractionsUsed = [.5 .5];
sourceLithologies = {'Sandstone (typical)', 'Shale (typical)'};

PM.Litho.mixLitholgies(sourceLithologies, fractionsUsed, rockName , mixer);
PM.Litho.changeLithologyGroup(rockName, 'BPSM', 'SandShale')
[PetroModId, id]   = PM.Litho.getLithologyId(rockName);
PetroModId = eval(PetroModId);
PM.saveLithology();

templateModel = 'CompactionInitial';
newModel = 'CompactionMatlab';
nDim = 1;

% Load and dublicate the model
PM = PetroMod(PMDirectory, PMProjectDirectory);
PM.deleteModel(newModel, nDim);
PM.dublicateModel(templateModel, newModel, nDim);
model = Model1D(newModel, PMProjectDirectory);


model.printTable('Main');
mainData = model.getData('Main');

mainData(2:3, 10) = {PetroModId, PetroModId};
model.updateData('Main', mainData);
model.updateModel();
    [output] = PM.simModel(newModel, nDim, true);

layerNumbers = [7, 93];
data = []
for iLayer = 1:numel(layerNumbers)
    [cmdout, status] = PM.runScript(newModel, 1, 'demo_opensim_output_3rd_party_format', num2str(layerNumbers(iLayer)), true); 
    [id, value, layer, unit] = readDemoScriptOutput('demo_1.txt');
    data = [data, value];
end