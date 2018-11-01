function numberedStrings = numberString(prefix, numbers, delimiter)
%% numberString   Returns a cell string array with numbered strings 
%
% prefix:                   Prefix string
% numbers:                  Numbers (vector) or maximum number (scalar)
% delimiter:                Delimiter between prefix and number
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Defaults
if ~exist('delimiter', 'var'); delimiter = '_'; end

% Assertions
assert(exist('prefix', 'var')== true, 'prefix must be provided');
assert(exist('numbers', 'var')== true, 'numbers must be provided');
assert(ischar(prefix), 'prefix must be char');
assert(isnumeric(numbers) && isvector(numbers), 'numbers must be number (vector or scalar)');
assert(ischar(delimiter), 'delimiter must be char');

%% Main

if isscalar(numbers)
   numbers = 1:numbers; 
end

numbers = numbers(:);
numberedStrings = cellfun(@(x) [prefix delimiter num2str(x)], num2cell(numbers), 'UniformOutput', false);


end