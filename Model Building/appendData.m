function [data, name] = appendData(data, extradata, name, extranames)


% Append data
data = [data extradata];

% Append names
if exist('name', 'var')==true
    name = [name extranames];
end

end