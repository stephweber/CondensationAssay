function [output] = getHistData(data, column, norm)

if norm %if normalized
    [y, edges] = histcounts(data{:,end});
else
    [y, edges] = histcounts(data.(column));
end

% % define bin edges
% if norm %if normalized
%     [y, edges] = histcounts(data{:,end}, [50:10:100]);
% else
%     [y, edges] = histcounts(data.(column), [50:10:100]);
% end

x = (edges(1:end-1) + edges(2:end))/2;

output = [x',y'];