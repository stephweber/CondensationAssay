function plotTimeSeriesData(dataForPlots, time, ind, conditionValues, column)

close all
    
numTimePoints = length(conditionValues{time});
numLines = length(dataForPlots)./numTimePoints;

% initialize temp matrices
tempx = NaN.*ones(numLines, numTimePoints); % to hold x values
tempy = NaN.*ones(numLines, numTimePoints); % to hold y values
tempe = NaN.*ones(numLines, numTimePoints); % to hold error values

ulines = ind(ind(:,time) == 1,1:time-1);  % unique lines
cmap = lines(length(ulines));

figure, hold on

% initialize color index
n = 1;

leg = {};
    
for l = 1:numLines
    
    for t = 1:numTimePoints  
       
        v = all(ind == [ulines(l,:),t],2);
        
        temp = dataForPlots(v).timeSeriesData;
        
        tempx(l,t) = t;
        tempy(l,t) = mean(temp);
        tempe(l,t) = std(temp)./sqrt(length(temp));

    end
    
    leg = [leg; makeLegendEntry(dataForPlots(v).conditions, ~ismember(1:length(conditionValues),time))];
    
    % plot points with vertical errorbars; x value is time, y value is mean
    % of columnb
    errorbar(tempx(l,:), tempy(l,:), tempe(l,:), 'o', 'Color', cmap(n,:));
    
    % increment color index
    n = n+1;
    
end

% add tick marks to x axis
set(gca, 'XTick', 1:numTimePoints);
set(gca, 'XTickLabel',conditionValues(time))
xlabel('Time (min)', 'FontSize', 18)
ylabel(column, 'FontSize', 18)
set(gca, 'FontSize', 18)

% check data type for legend and title
legend(leg)

% save figure
savefig([column, '_v_time'])
