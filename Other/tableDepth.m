function depth = tableDepth(t)
depth = cellfun(@(x) str2double(x), t.Properties.RowNames);
end