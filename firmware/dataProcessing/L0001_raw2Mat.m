

clc
clear all
close all
display(newline)
display(newline)
display("---------------------MINTS---------------------")

addpath("../../functions/")

addpath("YAMLMatlab_0.4.3")
mintsDefinitions  = ReadYaml('../mintsDefinitions.yaml')

dataFolder = mintsDefinitions.dataFolder;
gatewayIDs = mintsDefinitions.gatewayIDs;
loraIDs    = mintsDefinitions.loraIDs;
timeSpan   = seconds(mintsDefinitions.timeSpan);

rawFolder          =  dataFolder + "/raw";
rawDotMatsFolder   =  dataFolder + "/rawMats";
loraMatsFolder     =  rawDotMatsFolder  + "/lora";

display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Raw Data Located @: "+ dataFolder)
display("Raw DotMat Data Located @ :"+ rawDotMatsFolder)
display("lora DotMat Data Located @ :"+ loraMatsFolder)
display(newline)

%% Syncing Process 

syncFromCloudLora(gatewayIDs,dataFolder)

% going through the lora IDs
for loraIDIndex = 1:length(loraIDs)

    loraID = loraIDs{loraIDIndex};
    allFiles =  dir(strcat(rawFolder,'/*/*/',loraID,'*.csv'));
    
    if(length(allFiles) >0)
        loraNodeAll = {};
        display(strcat("Gaining LoRa data for Node: ",loraID))
        parfor fileNameIndex = 1: length(allFiles)
            loraNodeAll{fileNameIndex} = loraRead(strcat(allFiles(fileNameIndex).folder,"/",allFiles(fileNameIndex).name),timeSpan);
        end
        
        display(strcat("Concatinating LoRa data for Node: ",loraID));

        concatStr  =  "mintsDataAll = [";

        for fileNameIndex = 1: length(allFiles)
            concatStr = strcat(concatStr,"loraNodeAll{",string(fileNameIndex),"};");
        end    

        concatStr  =  strcat(concatStr,"];");

        display(concatStr);
        eval(concatStr);

        mintsData = unique(mintsDataAll);

        %% Getting Save Name 
        display(strcat("Saving Lora Data for Node: ", loraID));
        saveName  = strcat(loraMatsFolder,'/loraMints_',loraID,'.mat');
        folderCheck(saveName);
        save(saveName,'mintsData');
    else
        
       display(strcat("No Data for Lora Node: ", loraID ))
    end
        
    clearvars -except loraIDs loraIDIndex rawFolder dataFolder rawDotMatsFolder loraMatsFolder timeSpan
    
%loraID
end
