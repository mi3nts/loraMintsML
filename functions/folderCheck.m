 
function [] = folderCheck(fileName)%   Detailed explanation goes here
    
    [filePath,name,ext] = fileparts(fileName);
    
    if ~exist(filePath, 'dir')
        display(strcat("Creating Folder @: '",filePath,"'"));
        mkdir(filePath);
    end
    
end