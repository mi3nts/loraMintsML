function [] = drawTimeSeriesWithSaveLoraCheck(mintsData,nodeID,lat,long,titleIn,saveFolder)
%,titleIn,saveFolder)

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
    
    %% PPD Sensor              
    subplot(2,2,1)             
    % Create plot
    plot1 = plot(...
         mintsData.dateTime,...
         mintsData.P1_ratio);
     
    hold on 
   
    plot2 = plot(...
         mintsData.dateTime,...
         mintsData.P2_ratio)
 
    %      hold off 
    set(plot1,'DisplayName','LPO 1 Ratio','Marker','.',...
        'color','b','LineStyle','none');
    
    set(plot2,'DisplayName','LPO 2 Ratio','Marker','.',...
        'color','r','LineStyle','none');
    
    ylabel("Low Pulse Occupancy",'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel("Date Time",'FontWeight','bold','FontSize',10);


    title("PPDS42NS")

    legend1 = legend('show');
    set(legend1,'Location','northwest');
    
    %% CO2 Sensor              
    
    subplot(2,2,3)             
    
    % Create plot
    plot1 = plot(...
         mintsData.dateTime,...
         mintsData.CO2);
     
    hold on 
   

    %      hold off 
    set(plot1,'DisplayName','CO_{2}','Marker','.',...
        'color','b','LineStyle','none');
    
%     set(plot2,'DisplayName','LPO 2 Ratio','Marker','.',...
%         'color','r','LineStyle','none');
    
    ylabel("CO_{2} (ppm)",'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel("Date Time",'FontWeight','bold','FontSize',10);
   
    title("SCD 30")

    legend1 = legend('show');
    set(legend1,'Location','northwest');
    
    
        %% CO2 Sensor              
    
    subplot(2,2,2)             
    
    % Create plot
    plot1 = plot(...
         mintsData.dateTime,...
         mintsData.Temperature);
     
    hold on 
   

    %      hold off 
    set(plot1,'DisplayName','Temperature','Marker','.',...
        'color','b','LineStyle','none');
    
%     set(plot2,'DisplayName','LPO 2 Ratio','Marker','.',...
%         'color','r','LineStyle','none');
    
    ylabel("Temperature (C^{o})",'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel("Date Time",'FontWeight','bold','FontSize',10);
   
    title("BME 280")

    legend1 = legend('show');
    set(legend1,'Location','northwest');

          %% GAS Sensor              
    
    subplot(2,2,4)             
    
    % Create plot
    plot1 = plot(...
         mintsData.dateTime,...
         mintsData.NO2);
     
    hold on 
   

    %      hold off 
    set(plot1,'DisplayName','NO_{2}','Marker','.',...
        'color','b','LineStyle','none');
    
%     set(plot2,'DisplayName','LPO 2 Ratio','Marker','.',...
%         'color','r','LineStyle','none');
    
    ylabel("NO_{2} (ppm)",'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel("Date Time",'FontWeight','bold','FontSize',10);
   
    title("MGS")

    legend1 = legend('show');
    set(legend1,'Location','northwest');  
    
    
    %%
    Bottom_Title = strcat("Node " +string(nodeID)," ",titleIn);

    if(isnan(lat)||isnan(long))    
        Third_Title= strcat("GPS Coordinates not recorded");
    else
        Third_Title= strcat("(",string(lat),",",string(long),")");  
    end
    
    suptitle({Bottom_Title;Third_Title})%,'FontWeight','bold');

    Fig_name = strcat(saveFolder,"/",titleIn, "/loraMints_",nodeID,"_",titleIn,'.png');
    folderCheck(fileparts(Fig_name));
    saveas(figure_1,char(Fig_name));


    close all 

end

