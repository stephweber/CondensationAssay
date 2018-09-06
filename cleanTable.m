function tab = cleanTable(tab)


%% clean up table

% remove all rows that are missing data
% tab = rmmissing(tab);

% change text to numbers if necessary
columns = tab.Properties.VariableNames;

for i = 1:length(columns)
   if iscell(tab.(columns{i}))
       temp = tab.(columns{i}){1};
       if ~isnan(str2double(temp))
           tab.(columns{i}) = str2double(tab.(columns{i})(:));
       end
   end
end