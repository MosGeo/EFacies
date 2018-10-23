function [data] = loaddata(filename, issort, columnheaders, rowheaders)

    % Default values
    if exist('issort', 'var')==false; issort=false; end;

    % Read table
    data = readtable(filename);
    
    % Sort if requested
    if issort == true
        data = sortrows(data,1);
    end
    
    % Insert custom headers
    if exist('columnheaders','var')== true
        data.Properties.VariableNames = columnheaders;
    end
    
    % Insert custom headers
    if exist('rowheaders','var')== true
        data.Properties.RowNames = rowheaders;
    end

    
end
