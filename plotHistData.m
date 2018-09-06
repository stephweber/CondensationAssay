function plotHistData(dataForPlots, index, conditionValues, column)

close all

cmap = lines(length(dataForPlots));

for i = 1:length(conditionValues{index})

    leg = {};
    
    % initialize the color index
    n = 1;
        
    f(i) = figure;
    
    for v = 1:length(dataForPlots)
      
        if isequal(dataForPlots(v).conditions{index}, conditionValues{index}(i))
            
            figure(f(i))
            % subplot #1 (left) is total number of cells (absolute)
            subplot(1,2,1), hold on
            plot(dataForPlots(v).histData(:,1), dataForPlots(v).histData(:,2), 'Color', cmap(n,:))
            % subplot #2 (right) is fraction or percent of cells (relative)
            subplot(1,2,2), hold on
            plot(dataForPlots(v).histData(:,1), dataForPlots(v).histData(:,2)./sum(dataForPlots(v).histData(:,2)), 'Color', cmap(n,:))
            
            leg = [leg; makeLegendEntry(dataForPlots(v).conditions, ~ismember(1:length(conditionValues),index))];
            
            % increment color index
            n = n + 1;
        end
    end
    
        % add axis labels to subplot #1
        figure(f(i)), subplot(1,2,1);
        xlabel(column, 'FontSize', 18)
        ylabel('Number of cells', 'FontSize', 18)
        set(gca, 'FontSize', 18)

        % check data type for legend and title
        legend(leg)
        
        if iscell(conditionValues{index}(i))
            title(conditionValues{index}{i})
        else
            title(num2str(conditionValues{index}(i)))
        end

        % add axis labels to subplot #2
        figure(f(i)), subplot(1,2,2);
        xlabel(column, 'FontSize', 18)
        ylabel('Fraction of cells', 'FontSize', 18)
        set(gca, 'FontSize', 18)

        % check data type for legend and title
        legend(leg)
        
        if iscell(conditionValues{index}(i))
            title(conditionValues{index}{i})
        else
            title(num2str(conditionValues{index}(i)))
        end
        
        % save figure
        if iscell(conditionValues{index}(i))
            savefig([conditionValues{index}{i}, '_', column, '_hist'])
        else
            savefig([num2str(conditionValues{index}(i)), '_', column, '_hist'])
        end
        
end