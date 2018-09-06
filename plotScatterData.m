function plotScatterData(dataForPlots, time, ind, conditionValues)

close all

cmap = lines(length(dataForPlots));

numTimePoints = length(conditionValues{time});
numSets = length(dataForPlots)./numTimePoints;

usets = ind(ind(:,time) == 1,1:time-1);  % unique sets

for l = 1:numSets
    
    figure(l), hold on
    
    % initialize color index
    n = 1;

    for t = 1:numTimePoints  
       
        v = all(ind == [usets(l,:),t],2);
        
        plot(dataForPlots(v).scatterData(:,1), dataForPlots(v).scatterData(:,2), '.', 'Color', cmap(n,:));

        % increment color index
        n = n+1;
        
    end

    % add axis label
    xlabel('Cell size (pixels)', 'FontSize', 18)
    ylabel('Total intensity', 'FontSize', 18)
    set(gca, 'FontSize', 18)
    tit = makeLegendEntry(dataForPlots(v).conditions, ~ismember(1:length(conditionValues),time));
    title(tit)
    legend(num2str(conditionValues{time}))

    % save figure
    savefig([tit, '_totalIntensity_v_cellSize'])
    
end


figure(numSets+1), hold on

% initialize color index
n = 1;

leg = {};

for l = 1:numSets
    
    v = all(ind(:,1:time-1) == usets(l,:),2);
    
    temp = vertcat(dataForPlots(v).scatterData);
    
    if ~isempty(temp)
        plot(temp(:,1),temp(:,2), '.', 'Color', cmap(n,:));
    end
    
    % increment color index
    n = n+1;
    
    leg = [leg;makeLegendEntry(dataForPlots(find(v==1,1)).conditions, ~ismember(1:length(conditionValues),time))];
end


% add axis labels and legend
xlabel('Cell size (pixels)', 'FontSize', 18)
ylabel('Total intensity', 'FontSize', 18)
set(gca, 'FontSize', 18)
legend(leg)

% save figure
savefig('totalIntensity_v_cellSize_allTime')
    
