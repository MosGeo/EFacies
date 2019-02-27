function [intervalTable] = point2Interval(class, depth, age, isLump)
%% point2Interval   Convert a point dataset into an interval dataset
%
% class:                    Integer for the different classes
% depth:                    Depth for each class point
% age:                      Start and end age of interval
% isLump:                   Group neighboring intervals with similar class?
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Defaults
if ~exist('age', 'var')   ; age = [0 1]; end
if ~exist('isLump', 'var'); isLump = true; end

% Assertions
assert(exist('class', 'var') && isvector(class), 'class must be a vector');
assert(numel(age) == 1 || numel(age) == 2, 'age must be one or two elements in length');
assert(isnumeric(age), 'age must be numeric');

% Defaults 2
if ~exist('depth', 'var'); depth=1:numel(class); end
if numel(age) == 1; age = [0 age]; end

% Assertions 2
assert(exist('depth', 'var')==true && all(size(class)== size(depth)), 'depth must be a vector with elements equal to class');


%% Main

% Make sure the data is column formatted
class = class(:);
depth = depth(:);

% Get the start and end of each interval
if isLump == true
    d = [diff(class)~=0; 1];
else
    d = ones(size(class));
end

endings = find(d);
starts = [1; endings(1:end-1)+1];

% Figure out the classes
classes = class(starts);

% Figure out the depths
dzStart = [0; diff(depth)]/2;
dzEnd = [diff(depth); 0]/2;
startDepths = depth(starts)-dzStart(starts);
endDepths = (depth(endings)+dzEnd(endings));

% Calculate age
thickness = endDepths - startDepths;
thicknessPercentage = thickness/sum(thickness);
dt = thicknessPercentage*diff(age);
agesAll = cumsum([0; dt])+ age(1);
endAges = agesAll(1:end-1);
startAges = agesAll(2:end);

% Construct table
interval = [startDepths,  endDepths, classes, endAges, startAges];
variableNames = {'StartDepth', 'EndDepth', 'Class', 'EndAge', 'StartAge'};
intervalTable = array2table(interval, 'VariableNames', variableNames);

end