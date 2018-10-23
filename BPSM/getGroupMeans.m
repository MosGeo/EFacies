function [GroupMeans] = getGroupMeans(classes, data)
% ADDME  Add two values together.
%   C = ADDME(A) adds A to itself.
%   C = ADDME(A,B) adds A and B together.
%
%   See also SUM, PLUS.

    upscaledClasses = classData{1}.upscaledClasses(:,8)
    data = classData{1}.data
    
    classes = unique(upscaledClasses)
    nClasses = numel(classes)
    
    A = accumarraym(upscaledClasses,data, [], @mean)

end