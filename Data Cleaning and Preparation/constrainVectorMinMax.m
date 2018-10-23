function [vector, index] = constrainVectorMinMax(vector, minval, maxval, isinclusive)

% Default values
if exist('minval', 'var')==false; minval=-inf; end
if exist('maxval', 'var')==false; minval=inf; end
if exist('isinclusive', 'var')==false; isinclusive=true; end

% Find index
if isinclusive==true
    index = vector>=minval & vector<=maxval;
else
    index = vector>=minval & vector<=maxval;
end

% Constrain vector
vector(~index)=[];

end