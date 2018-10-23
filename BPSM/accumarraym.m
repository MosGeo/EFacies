function A = accumarraym(subs, val, sz, fun, fillval, issparse)
% ACCUMARRAYM  Perform columnwise accumarray on a matrix.
%
%   Mustafa Al Ibrahim (Mustafa.Geoscientist@outlook.com) Oct, 2017
%
%   See also ACCUMARRAY.

% Default variables 
if ~exist('sz', 'var')==true; sz=[]; end;
if ~exist('fun', 'var')==true; fun=@sum; end;
if ~exist('fillval', 'var')==true; fillval=0; end;
if ~exist('issparse', 'var')==true; issparse=false; end;

uniqueSubs = unique(subs);

% Preprocess for matrix operations
nCols = size(val,2);
subs = [repmat(subs(:),nCols,1) ...            % Replicate the row indices
        kron(1:nCols,ones(1,numel(subs))).'];  % Create column indices

% Perform accumlation operation
A = accumarray(subs, val(:), sz, fun, fillval, issparse);


A = A(uniqueSubs, :);


end