function [folders, children_folders] = getFolders(directory)

% Get all (terminal) subfolders in a directory

p = genpath(directory);
folders = regexp(p,':','split')';
folders = folders(1:end-1); %// remove last element (it's empty)
valid = false(size(folders));
for n = 1:numel(folders)
    valid(n) = numel(strmatch(folders(n),folders))==1; %// 1 means the folder is 
    %// only a prefix of itself
end
children_folders = folders(valid);


% listing = dir;
% allFolders = listing([listing.isdir]);
% allFolders = allFolders(arrayfun(@(x) ~strcmp(x.name(1),'.'),allFolders));  %remove hidden files

