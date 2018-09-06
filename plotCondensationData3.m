function plotCondensationData3(masterTable,norm,column,varargin)

close all

% norm variable indicates whether to use non-normalized data in "column" (norm = 0) 
% or normalized data in last column (norm = 1)

% column is the header (in single quotes) of the data column to be plotted
% ex. for TF assembly metric, column = 'pooled_fractionArea_3'


%% Find unique conditions (i.e. media, time, concentration, etc.)

% looks in the columns of masterTable, indicated by input variables,
% and finds unique entires (ex. 'LB', 'M9' or '0', '60', etc.)
for i = 1:length(varargin)
    conditionValues{i,1} = unique(masterTable.(varargin{i}));
end

% count the number of values in each condition
cond = cellfun(@length,conditionValues);


%% Get table indices for each condition

%preallocate space
tableIndices = cell(size(conditionValues));
for i = 1:length(varargin)
    tableIndices{i} = cell(cond(i),1);
end

% finds which rows in the masterTable correspond to each condition
for i = 1:size(conditionValues,1) 

    for j = 1:size(conditionValues{i},1)

        % need to check data type because text (ex. 'LB') is stored in cell 
        % array, while numbers (ex. '120') are stored in matrix 
        if ~iscell(conditionValues{i})
            tableIndices{i}{j} = masterTable.(varargin{i}) == conditionValues{i}(j);
        else
            tableIndices{i}{j} = cellfun(@(x) isequal(x,conditionValues{i}{j}), masterTable.(varargin{i}));
        end

    end

end

%% Get index for time

time = find(cellfun(@(x) ~iscell(x), conditionValues)==1);


%% Get all combinations of condition values
[vars, ind] = getConditionCombinations(conditionValues);

dataForPlots = struct;

for v = 1:length(vars)
    filteredTable = filterData(masterTable, ind(v,:), tableIndices);
    dataForPlots(v).conditions = vars(v,:);
    dataForPlots(v).histData = getHistData(filteredTable, column, norm);   
    dataForPlots(v).timeSeriesData = getTimeSeriesData(filteredTable, column, norm);
    dataForPlots(v).scatterData = getScatterData(filteredTable);
end

%% Make plots

% create folder to hold figures
if ~exist('figs', 'dir')
    mkdir('figs')
end
cd('figs')


for i = 1:length(conditionValues)
    plotHistData(dataForPlots, i, conditionValues, column)
end

plotTimeSeriesData(dataForPlots, time, ind, conditionValues, column)

plotScatterData(dataForPlots, time, ind, conditionValues)

close all
