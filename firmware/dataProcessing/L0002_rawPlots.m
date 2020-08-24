

clc
clear all
close all

display("------ MINTS ------")

addpath("../../functions/")

loraIDs= {...
            "475a5fe3002e0023",...
            "475a5fe3002a0019",...
            "475a5fe3003e0023",...
            "475a5fe30031001b",...
            "475a5fe300320019",...
            "475a5fe300380019",...
            "477b41f200290024",...
            "475a5fe3002e001f",...
            "477b41f20047002e",...
            "475a5fe30021002d",...
            "475a5fe30031001f",...
            "475a5fe30028001f",...
            "478b5fe30040004b",...
            "472b544e00250037",...
            "47eb5580003c001a",...
            "47db5580001e0039",...
            "479b558000380033",...
            "472b544e00230033",...
            "478b558000330027",...
            "475a5fe30035001b",...
            "472b544e0024004b",...
            "470a55800048003e",...
            "475a5fe3002a001a",...
            "47cb5580003a001c",...
            "475a5fe300300019",...
            "475a5fe3002e0018",...
            "472b544e0018003d",...
            "476a5fe300220022",...
            "472b544e001b003c",...
            "47bb558000280041",...
            "47db5580002d0043",...
            "477b41f20048001f",...
            "47fb558000450044",...
            "475b41f20037001e",...
            "478b5fe30040004b",...
            "475a5fe30039002a",...
            "479b5580001a0031",...
            "475a5fe3002f001b",...
            "47cb5580002e004a",...
            "471a55800038004e"...
                 };

dataFolder         =  "/media/teamlary/Team_Lary_2/air930/mintsData"
rawFolder          =  dataFolder + "/raw";
rawDotMatsFolder   =  dataFolder + "/rawMats";
loraMatsFolder     =  rawDotMatsFolder  + "/lora";
plotsFolder        =  dataFolder + "/visualAnalysis/lora";

display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Raw Data Located @: "+ dataFolder)
display("Raw DotMat Data Located @ :"+ rawDotMatsFolder)
display(newline)

% going through the lora IDs
for loraIDIndex = 1:length(loraIDs)

    loraID = loraIDs{loraIDIndex};
    display(strcat("Loading Lora Data for Node: ", loraID));
    loadName  = strcat(loraMatsFolder,'/loraMints_',loraID,'.mat');
    
    
    if isfile(loadName)
        load(loadName)
        display(strcat("Lora Data Imported for Node: ", loraID));
        
        
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
        
        
        drawTimeSeriesWithSaveLoraRaw(mintsData.dateTime,mintsData.P1_conc,...
                                      mintsData.dateTime,mintsData.P2_conc,...
                                      loraID,"Date Time","LPO Concentration",....
                                    "Lora Mints",height(mintsData),latitude,longitude,...
                                       plotsFolder)
                                   
        drawTimeSeriesWithSaveLoraRawLPO1(mintsData.dateTime,mintsData.P1_conc,...
                                    loraID,"Date Time","LPO 1 Concentration",....
                                    "Lora Mints",height(mintsData),latitude,longitude,...
                                       plotsFolder)                          
        
        drawTimeSeriesWithSaveLoraRawLPO2(mintsData.dateTime,mintsData.P2_conc,...
                                    loraID,"Date Time","LPO 2 Concentration",....
                                    "Lora Mints",height(mintsData),latitude,longitude,...
                                       plotsFolder)                                   
           
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
























