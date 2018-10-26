function class = renumberClass(class)
%% renumberClass       Renumber categories to start from 1 to max
%
% class:                   Integer for the different classes
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Assertions
assert(exist('class', 'var')==true, 'class must be provided');
assert(isvector(class) && isnumeric(class), 'class must be a numeric vector');

%% Main

uniqueclasses = unique(class);
classesOrig = class;
for i = 1:numel(uniqueclasses)
   class(classesOrig==uniqueclasses(i)) = i;
end

end