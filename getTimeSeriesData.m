function [output] = getTimeSeriesData(data, column, norm)

if norm %if normalized
    output = data{:,end};
else
    output = data.(column);
end

% % store data for each condition in second input ("condition 2")
% % x = unique();
% y = mean(temp);
% e = std(temp)./sqrt(length(temp));
%         
% % output = [x, y, e];
% output = [y, e];