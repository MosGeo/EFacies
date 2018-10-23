function [curveInfoTable, columnName, columnformat, columnEdit, rowName] = constructCurveInfoTable(lasHeader)


variables = lasHeader.curves.variables;
units = lasHeader.curves.units;
descriptions = lasHeader.curves.descriptions;

nCurves= numel(variables);
zerosVector = zeros(nCurves,1);
onesVector = ones(nCurves,1);


discTitle = 'Description';
discWidth = size(char(descriptions),2) - numel(discTitle);
extraSpaces = repmat(' ',1, 2*ceil(discWidth/2)+1);
usedDiscTitle = [extraSpaces discTitle extraSpaces];
        
columnName = {' Plot? ', ' Use? ', ' Logrithmic? ', ' Normalize? ', ' Weight ' '  Unit  ', usedDiscTitle}; 
columnformat = {'logical', 'logical', 'logical', 'logical', 'numeric' 'char', 'char'};
columnEdit = ismember(columnformat,{'logical','numeric'});
rowName = variables;

curveInfoTable = cell(nCurves, 6);
curveInfoTable(:,1) = num2cell(zerosVector == 1);
curveInfoTable(:,2) = num2cell(zerosVector == 1);
curveInfoTable(:,3) = num2cell(zerosVector == 1);
curveInfoTable(:,4) = num2cell(onesVector == 1);
curveInfoTable(:,5) = num2cell(onesVector);
curveInfoTable(:,6) = units;
curveInfoTable(:,7) = descriptions;



end