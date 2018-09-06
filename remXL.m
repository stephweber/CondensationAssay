function remXL(folderName)

directory = cd;

cd(folderName)

files = dir('**/*.xlsx');

if ~isempty(files)
delete(files.name)
end

cd(directory)