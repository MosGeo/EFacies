function logData = constructLogDataStructure(wellInput, data, depth, lasHeader)
    
    logData = [];

    if exist('lasHeader', 'var')==true
        logData.lasHeader  = lasHeader;
    else
        logData.lasHeader = [];
    end
    
    nCurves = size(data,2);

    if isa(data,'table')
        logData.data = table2array(data);
        if isempty(data.Properties.VariableNames) == false
            curvesNames = data.Properties.VariableNames;
        else
            varFunction = @(x)  ['Var ', num2str(x)];
            curvesNames = cellfun(varFunction, num2cell(1:nCurves), 'UniformOutput', false);
        end
    else
        logData.data = data;
        varFunction = @(x)  ['Var ', num2str(x)];
        curvesNames = cellfun(varFunction, num2cell(1:nCurves), 'UniformOutput', false);
    end

    
    logData.nCurves = nCurves;
    logData.curvesNames  = curvesNames;
    
    logData.depth  = depth;
    logData.selectedDepth = depth;
    
    logData.normVar = ones(nCurves,1) == 1;
    logData.weights = ones(nCurves,1);
    
    
    logData.logVar = zeros(nCurves, 1);
    logData.logVar(wellInput{3}) = true;
    
    logData.curvesToUse = wellInput{2};
    
    logData.minDepth = wellInput{4};
    logData.maxDepth = wellInput{5};
    logData.absMinMaxDepth = [logData.minDepth logData.maxDepth];

    logData.wellName = wellInput{1};
    
    missingCurves = isnan(wellInput{2});
    logData.usedLogNames(~missingCurves) = curvesNames(wellInput{2}(~missingCurves));
end