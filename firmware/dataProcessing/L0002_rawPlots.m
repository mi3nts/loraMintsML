

clc
clear all
close all

display("------ MINTS ------")

addpath("../../functions/")

addpath("YAMLMatlab_0.4.3")
mintsDefinitions  = ReadYaml('../mintsDefinitions.yaml')

dataFolder = mintsDefinitions.dataFolder;
gatewayIDs = mintsDefinitions.gatewayIDs;
loraIDs    = mintsDefinitions.loraIDs;

rawFolder          =  dataFolder + "/raw";
rawDotMatsFolder   =  dataFolder + "/rawMats";
loraMatsFolder     =  rawDotMatsFolder  + "/lora";
plotsFolder        =  dataFolder + "/visualAnalysis/lora";

display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Raw Data Located @: "+ dataFolder)
display("Raw DotMat Data Located @ :"+ rawDotMatsFolder)
display("Plots Located @ :"+ plotsFolder)

display(newline)

% going through the lora IDs
for loraIDIndex = 50:length(loraIDs)

    loraID = loraIDs{loraIDIndex};
    display(strcat("Loading Lora Data for Node: ", loraID));
    loadName  = strcat(loraMatsFolder,'/loraMints_',loraID,'.mat');
    
    
    if isfile(loadName)
        load(loadName)
        
        
        display(strcat("Lora Data Imported for Node: ", loraID));
        mintsDataAll  = mintsData;
        mintsData(mintsData.dateTime<datetime('now','timeZone','utc')-7,:) = [];
        
        
        %% Latest Data  
        
        latitudePre  = rmmissing(mintsData.Latitude);
        longitudePre = rmmissing(mintsData.Longitude);
        
        
        if length(latitudePre)>0
            latitude     = latitudePre(end);     
        else 
            latitude = NaN;
        end 
        
        
        if length(longitudePre)>0
             longitude    = longitudePre(end)   ;
        else 
           longitude    = NaN;
        end
        
        drawTimeSeriesWithSaveLoraCheck(mintsData,loraID,latitude,longitude,"latest",plotsFolder);
        
        %% For Spanned Data 
        latitudePre  = rmmissing(mintsDataAll.Latitude);
        longitudePre = rmmissing(mintsDataAll.Longitude);
        
        
        if length(latitudePre)>0
            latitude     = latitudePre(end);     
        else 
            latitude = NaN;
        end 
        
        
        if length(longitudePre)>0
             longitude    = longitudePre(end)   ;
        else 
           longitude    = NaN;
        end
        
        
        drawTimeSeriesWithSaveLoraCheck(mintsDataAll,loraID,latitude,longitude,"spanned",plotsFolder);

        display(strcat("PLOTTING DONE"));
        
    else
        display(strcat("No Data Recorded for Node:",loraID));
    end

    
    clearvars -except loraIDs loraIDIndex rawFolder dataFolder rawDotMatsFolder loraMatsFolder plotsFolder
%     
%loraID
end




function [] = drawTimeSeriesWithSaveLoraRaw(dataX1,dataY1,dataX2,dataY2,nodeID,xLabel,yLabel,titleIn,numOfRows,lat,long,saveFolder)

%GETMINTSDATAFILES Summary of this function goes here
%   Detailed explanation goes here
% As Is Graphs  

%     print(titleIn)
    figure_1= figure('Tag','SCATTER_PLOT',...
        'NumberTitle','off',...
        'units','pixels','OuterPosition',[0 0 900 675],...
        'Name','TimeSeries',...
        'Visible','off'...
    );

    % Create plot
    plot1 = plot(...
         dataX1,...
         dataY1);

     hold on 
    
     plot2 = plot(...
         dataX2,...
         dataY2);
     
     hold off 
     
    set(plot1,'DisplayName','LPO 1','Marker','.',...
        'color','b','LineStyle','none');
    
         
    set(plot2,'DisplayName','LPO 2','Marker','.',...
        'color','r','LineStyle','none');
    

    ylabel(yLabel,'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel(xLabel,'FontWeight','bold','FontSize',10);

%     % Create title
    Top_Title=strcat(titleIn);

    Bottom_Title = strcat("Node " +string(nodeID));

    if(isnan(lat)||isnan(long))    
        Third_Title= strcat(" # ", string(numOfRows),', GPS Coordinates not recorded');
    else
        Third_Title= strcat(" # ", string(numOfRows),", (",string(lat),",",string(long),")");  
    end
    
    title({" ";Top_Title;Bottom_Title;Third_Title},'FontWeight','bold');
    legend1 = legend('show');
    set(legend1,'Location','northwest');
    
%     ylim([0  limit;
    
%     grid on
%     if(autoScaleOn)
%         ylim([0  limit]);
%         
%     end    

%     outFigNamePre    = strcat(calibratedFolder,"/",nodeID,"/",...
%                                                      num2str(year(givenDate),'%04d'),"/",...
%                                                      num2str(month(givenDate),'%02d'),"/",...
%                                                      num2str(day(givenDate),'%02d'),"/",...
%                                                      "MINTS_",...
%                                                      nodeID,...
%                                                      "_",stringIn,"_",...
%                                                      num2str(year(givenDate),'%02d'),"_",...
%                                                      num2str(month(givenDate),'%02d'),"_",...
%                                                      num2str(day(givenDate),'%02d')...
%                                                  );  
%     
%     
%     

    Fig_name = strcat(saveFolder,"/",nodeID,"/loraMints_",nodeID, '.png');
        mkdir(fileparts(Fig_name));
    saveas(figure_1,char(Fig_name));




end


function [] = drawTimeSeriesWithSaveLoraRawLPO1(dataX1,dataY1,nodeID,xLabel,yLabel,titleIn,numOfRows,lat,long,saveFolder)

%GETMINTSDATAFILES Summary of this function goes here
%   Detailed explanation goes here
% As Is Graphs  

%     print(titleIn)
    figure_1= figure('Tag','SCATTER_PLOT',...
        'NumberTitle','off',...
        'units','pixels','OuterPosition',[0 0 900 675],...
        'Name','TimeSeries',...
        'Visible','off'...
    );

    % Create plot
    plot1 = plot(...
         dataX1,...
         dataY1);
% 
%      hold on 
%     
%      plot2 = plot(...
%          dataX2,...
%          dataY2)
%      
%      hold off 
     
    set(plot1,'DisplayName','LPO 1','Marker','.',...
        'color','b','LineStyle','none');
    
%          
%     set(plot2,'DisplayName','LPO 2','Marker','.',...
%         'color','r','LineStyle','none');
    

    ylabel(yLabel,'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel(xLabel,'FontWeight','bold','FontSize',10);

%     % Create title
    Top_Title=strcat(titleIn);

    Bottom_Title = strcat("Node " +string(nodeID));

    if(isnan(lat)||isnan(long))    
        Third_Title= strcat(" # ", string(numOfRows),', GPS Coordinates not recorded');
    else
        Third_Title= strcat(" # ", string(numOfRows),", (",string(lat),",",string(long),")");  
    end
    
    title({" ";Top_Title;Bottom_Title;Third_Title},'FontWeight','bold');
    legend1 = legend('show');
    set(legend1,'Location','northwest');
    
%     ylim([0  limit;
    
%     grid on
%     if(autoScaleOn)
%         ylim([0  limit]);
%         
%     end    

%     outFigNamePre    = strcat(calibratedFolder,"/",nodeID,"/",...
%                                                      num2str(year(givenDate),'%04d'),"/",...
%                                                      num2str(month(givenDate),'%02d'),"/",...
%                                                      num2str(day(givenDate),'%02d'),"/",...
%                                                      "MINTS_",...
%                                                      nodeID,...
%                                                      "_",stringIn,"_",...
%                                                      num2str(year(givenDate),'%02d'),"_",...
%                                                      num2str(month(givenDate),'%02d'),"_",...
%                                                      num2str(day(givenDate),'%02d')...
%                                                  );  
%     
%     
%     

    Fig_name = strcat(saveFolder,"/",nodeID, "/loraMints_LPO1_",nodeID, '.png');
        mkdir(fileparts(Fig_name));
    saveas(figure_1,char(Fig_name));




end


function [] = drawTimeSeriesWithSaveLoraRawLPO2(dataX1,dataY1,nodeID,xLabel,yLabel,titleIn,numOfRows,lat,long,saveFolder)

%GETMINTSDATAFILES Summary of this function goes here
%   Detailed explanation goes here
% As Is Graphs  

%     print(titleIn)
    figure_1= figure('Tag','SCATTER_PLOT',...
        'NumberTitle','off',...
        'units','pixels','OuterPosition',[0 0 900 675],...
        'Name','TimeSeries',...
        'Visible','off'...
    );

    % Create plot
    plot1 = plot(...
         dataX1,...
         dataY1);
% 
%      hold on 
%     
%      plot2 = plot(...
%          dataX2,...
%          dataY2)
%      
%      hold off 
     
    set(plot1,'DisplayName','LPO 2','Marker','.',...
        'color','b','LineStyle','none');
    
%          
%     set(plot2,'DisplayName','LPO 2','Marker','.',...
%         'color','r','LineStyle','none');
    

    ylabel(yLabel,'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel(xLabel,'FontWeight','bold','FontSize',10);

%     % Create title
    Top_Title=strcat(titleIn);

    Bottom_Title = strcat("Node " +string(nodeID));

    if(isnan(lat)||isnan(long))    
        Third_Title= strcat(" # ", string(numOfRows),', GPS Coordinates not recorded');
    else
        Third_Title= strcat(" # ", string(numOfRows),", (",string(lat),",",string(long),")");  
    end
    
    title({" ";Top_Title;Bottom_Title;Third_Title},'FontWeight','bold');
    legend1 = legend('show');
    set(legend1,'Location','northwest');
    
%     ylim([0  limit;
    
%     grid on
%     if(autoScaleOn)
%         ylim([0  limit]);
%         
%     end    

%     outFigNamePre    = strcat(calibratedFolder,"/",nodeID,"/",...
%                                                      num2str(year(givenDate),'%04d'),"/",...
%                                                      num2str(month(givenDate),'%02d'),"/",...
%                                                      num2str(day(givenDate),'%02d'),"/",...
%                                                      "MINTS_",...
%                                                      nodeID,...
%                                                      "_",stringIn,"_",...
%                                                      num2str(year(givenDate),'%02d'),"_",...
%                                                      num2str(month(givenDate),'%02d'),"_",...
%                                                      num2str(day(givenDate),'%02d')...
%                                                  );  
%     
%     
%     

    Fig_name = strcat(saveFolder,"/",nodeID, "/loraMints_LPO2_",nodeID, '.png');
        mkdir(fileparts(Fig_name));
    saveas(figure_1,char(Fig_name));




end
























