function dataClasses = getClassFromDepth(classData, depth, mainScale)

% Well info
wellClasses = classData.upscaledClasses(:,end-mainScale+1);
wellDepth   = classData.depth;

dataClasses = interp1(wellDepth, wellClasses, depth, 'nearest');

end