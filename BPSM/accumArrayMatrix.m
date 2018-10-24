function A = accumArrayMatrix(class, data, functionHandle, fillValue, isSparse, outputSize)
% ACCUMARRAYM  Perform columnwise accumarray on a matrix.
%
% class:                   Integer for the different classes
% data:                    Data (each column is a variable)
%
% Note: based on stackoverflow question (I think, I don't remember)
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com
%
%   See also ACCUMARRAY.

%% Preprocessing

% Defaults 
if ~exist('outputSize', 'var'); outputSize=[]; end
if ~exist('functionHandle', 'var'); functionHandle=@sum; end
if ~exist('fillValue', 'var'); fillValue=0; end
if ~exist('isSparse', 'var'); isSparse=false; end

% Assertions
assert(exist('class', 'var')==true, 'class must be provided');
assert(exist('data', 'var')==true, 'data must be provided');
assert(isa(isSparse, 'logical'), 'isSparse must be logical');
assert(isscalar(fillValue) && isnumeric(fillValue), 'fillValue must be scalar numeric');


%% Main

uniqueSubs = unique(class);

% Preprocess for matrix operations
nCols = size(data,2);
class = [repmat(class(:),nCols,1) ...           % Replicate the row indices
        kron(1:nCols,ones(1,numel(class))).'];  % Create column indices

% Perform accumlation operation
A = accumarray(class, data(:), outputSize, functionHandle, fillValue, isSparse);

A = A(uniqueSubs, :);


end