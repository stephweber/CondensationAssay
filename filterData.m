function data = filterData(allData, combo, tableIndices)

%% Find all rows that correspond to variable combinations

j = zeros(size(allData,1),size(combo,2));

for i = 1:length(combo)
    j(:,i) = tableIndices{i}{combo(i)};
end

data = allData(all(j,2),:);
