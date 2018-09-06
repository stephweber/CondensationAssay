function leg = makeLegendEntry(conditions, index)

leg = [];

for i = 1:length(index)
    
    if index(i)
        if iscell(conditions{1,i})
            
            if isempty(leg)
                leg = [conditions{1,i}{1}];
            else
                leg = [leg, ', ', conditions{1,i}{1}];
            end
        else
            if isempty(leg)
                leg = [num2str(conditions{1,i}(1))];
            else
                leg = [leg, ', ', num2str(conditions{1,i}(1))];
            end
            
        end
    end
    
end