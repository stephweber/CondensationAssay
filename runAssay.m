function [allFolders, masterTable] = runAssay(varargin)

%% Either specify a specific directory as input, or excute on current directory

    if nargin == 1
        directory = varargin{1};
    else
        directory = cd;
    end

%% Run condensation assay on all files within the directory

    % Get subfolders containing image files
    allFolders = getFolders(directory);

    % Remove old Excel files in all folders
    arrayfun(@(x) remXL(x{1}), allFolders)

    % Run condensation assay, save output in Matlab and Excel
    arrayfun(@(x) condensationAssay(x{1}), allFolders);

%% Pool data from all folders, save in master table
    
    masterTable = makeMasterTable(directory);
   
%% Plot data

    % Plot histograms and timeseries, etc. of the data
    
    % norm variable indicates whether to use non-normalized data in "column" (norm = 0)
    % or normalized data in last column (norm = 1)
    
    % column is the header (in single quotes) of the data column to be plotted
    % ex. for TF assembly metric, column = 'pooled_fractionArea_3'

%     plotCondensationData(masterTable,norm,column,varargin)
    % for example:
    plotCondensationData3(masterTable, 0,'pooled_fractionArea_3','condition_2', 'condition_3', 'condition_4')

