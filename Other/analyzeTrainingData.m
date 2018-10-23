function [] = analyzeTrainingData(logData, classData, scaleToView, studyCurves, colorMap)


nWells = numel(logData)

for i  = 1:nWells
    logDataSelected = logData{i};
    classDataSelected = classData{i};
    [data, dataAll, depth] = prepareLogData(logDataSelected);
    trainingData = dataAll(:,[17 18]) .* repmat(dataAll(:,2)*1000, 1,2);
    originalClass = classDataSelected.upscaledClasses(:,end-scaleToView+1);
    %unique(originalClass)
    
    % Discrimenent Analysis
    [classHat, err, pp] = classify(trainingData,trainingData,originalClass);

    % NaiveBayes
    %nb = fitcnb(trainingData, originalClass);
     nb = NaiveBayes.fit(trainingData, originalClass)
     classHat = predict(nb,trainingData);

    
    [C, order] = confusionmat(originalClass,classHat);
    Cnormalized = C ./ repmat(sum(C,2),1,size(C,2))
end



end

