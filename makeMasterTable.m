function masterTable = makeMasterTable(varargin)

%% Either specify a specific directory as input, or excute on current directory

m=0;  %default is include all excel files (i.e. not filter between "data" or "master" files)

    if nargin > 0
        % set directory
        directory = varargin{arrayfun(@(x) isdir(x{1}),varargin)};
        % only use master tables
        if sum(arrayfun(@(x) isequal(x,{'master'}),varargin))
            m = 1;
        end
    else
        directory = cd;
    end
    
    % enter directory
    cd(directory)
    
%% Combine data from all files

% Get names of all excel files
files = dir('**/*.xlsx');

% Remove hidden files
files = files(arrayfun(@(x) ~strcmp(x.name(1),'.'),files));

% Exclude all files that do not contain "master" if 'master' is given as
% input
if m == 1
    files = files(arrayfun(@(x) ~isempty(strfind(x.name,'master')),files));
end
    
% Import data from excel into matlab
masterTable = readtable([files(1).folder,'/',files(1).name]);

% clean master table (i.e. remove missing data and check format of numbers/text)
masterTable = cleanTable(masterTable);

for f = 2:size(files,1)
    
    temp = readtable([files(f).folder,'/',files(f).name]);
    
    % clean temp table (i.e. remove missing data and check format of numbers/text)
    temp = cleanTable(temp);
    
    % Combine data from all files
    masterTable = outerjoin(masterTable, temp, 'MergeKeys', true);
    
end

% Save master table to Excel
filename = [directory, '_master.xlsx'];
if exist(filename,'file') == 2
    delete(filename)
end
writetable(masterTable,filename)


