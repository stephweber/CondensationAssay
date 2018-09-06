function [vars,index] = getConditionCombinations(conditions)

% determine number of conditions per category
numCond = cellfun(@length,conditions);

% initialize category index
catIndex = ones(length(numCond),1);

vars = [];
index = [];

while catIndex(end) <= numCond(end)

    comb = cell(1,length(catIndex));
    
    for i = 1:length(catIndex)
        comb{i} = conditions{i}(catIndex(i));
    end
   
%     vars = [vars; comb, {catIndex}];
    vars = [vars; comb];
    index = [index; catIndex'];
    
    for k = 1:length(catIndex)
        
        catIndex(k) = catIndex(k) + 1;
        
        if catIndex(k) == numCond(k) + 1 && k < length(catIndex)
            catIndex(k) = 1;
        else
            break
        end
    end
    
end

   