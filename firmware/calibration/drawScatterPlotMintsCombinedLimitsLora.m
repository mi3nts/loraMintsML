function [] = drawScatterPlotMintsCombinedLimitsLora(...
                                    dataXTrain,...
                                    dataYTrain,...
                                    dataXValid,...
                                    dataYValid,...
                                    limitLow,...
                                    limitHigh,...
                                    nodeID,...
                                    estimator,...
                                    xInstrument,...
                                    yInstrument,...
                                    units,...
                                    saveNameFig,...
                                    stringIn,...
                                    stringIn2)
%GETMINTSDATAFILES Summary of this function goes here
%   Detailed explanation goes here
% As Is Graphs 

    % Initially draw y=t plot

    
    figure_1= figure('Tag','SCATTER_PLOT',...
        'NumberTitle','off',...
        'units','pixels','OuterPosition',[0 0 900 675],...
        'Name','Regression',...
        'Visible','on'...
    );

    %% Plot 1 : 1:1
    plot1=plot([limitLow: limitHigh],[limitLow: limitHigh]);
    set(plot1,'DisplayName','Y = T','LineStyle',':','Color',[0 0 0]);
    hold on 

    %% Plot 2 : Training Fit 
    % Fit model to data.
    % Set up fittype and options. 
    ft = fittype( 'poly2' ); 
    opts = fitoptions( 'Method', 'LinearLeastSquares' ); 
    opts.Lower = [0.6 -Inf];
    opts.Upper = [1.4 Inf];
   
    [fitresult, gof] = fit(...
       dataXTrain,...
       dataYTrain,...
       ft);
   
    rmseTrain     = rms(dataXTrain-dataYTrain);
    r = corrcoef(dataXTrain,dataYTrain);
    rSquaredTrain=r(1,2)^2;
%     rSquared = gof.rsquare;

    % %The_Fit_Equation_Training(runs,ts)=fitresult
    % p1_Training_and_Validation_f=fitresult.p1;
    % p2_Training_and_Validation_f=fitresult.p2;

    plot2 = plot(fitresult);
    set(plot2,'DisplayName','Training Fit','LineWidth',2,'Color',[0 0 .7]);  
    
    %% Plot 3 Traning Data 
    % Create plot
    plot3 = plot(...
         dataXTrain,...
         dataYTrain)
    set(plot3,'DisplayName','Data','Marker','o',...
        'LineStyle','none','Color',[0 0 1]);
    
    %% Plot 4 : Testing Fit 
    % Fit model to data.
    % Set up fittype and options. 
    ft = fittype( 'poly1' ); 
    opts = fitoptions( 'Method', 'LinearLeastSquares' ); 
    opts.Lower = [0.6 -Inf];
    opts.Upper = [1.4 Inf];
   
    [fitresult, gof] = fit(...
       dataXValid,...
       dataYValid,...
       ft);
   
    rmseValid     = rms(dataXValid-dataYValid);
    r = corrcoef(dataXValid,dataYValid);
    rSquaredValid=r(1,2)^2;
%     rSquared = gof.rsquare;

    % %The_Fit_Equation_Training(runs,ts)=fitresult
    % p1_Training_and_Validation_f=fitresult.p1;
    % p2_Training_and_Validation_f=fitresult.p2;

    plot4 = plot(fitresult)
    set(plot4,'DisplayName','Testing Fit','LineWidth',2,'Color',[1 0 0]);  
    
    %% Plot 5 Validating Data 
    % Create plot
    plot5 = plot(...
         dataXValid,...
         dataYValid);
    set(plot5,'DisplayName','Testing Data','Marker','o',...
        'LineStyle','none','Color',[1 0 0]);
    
     %% Plot 6 : Combined Fit 
    % Fit model to data.
    % Set up fittype and options. 
    ft = fittype( 'poly1' ); 
    opts = fitoptions( 'Method', 'LinearLeastSquares' ); 
    opts.Lower = [0.6 -Inf];
    opts.Upper = [1.4 Inf];
    dataXAll = [dataXTrain;dataXValid];
    dataYAll = [dataYTrain;dataYValid];
    
    [fitresult, gof] = fit(...
       dataXAll,...
       dataYAll,...
       ft);
   
    rmse     = rms(dataXAll-dataYAll);
    r = corrcoef(dataXAll,dataYAll);
    rSquared=r(1,2)^2;

    plot6 = plot(fitresult)
    set(plot6,'DisplayName','Combined Fit','LineWidth',2,'Color',[0 0 0]);  
    
   
    %% Labels 
   
    yl=strcat(yInstrument,'~=',string(fitresult.p1),'*',xInstrument,'+',string(fitresult.p2)," (",units,")");
    ylabel(yl,'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel(strcat(xInstrument,' (',units,')'),'FontWeight','bold','FontSize',12);

    
    %% Create title
    
    Top_Title=strcat(estimator," - Node " +string(nodeID)," - " ,stringIn);

    %% Start Now 
    Middle_Title = strcat("Training: R^2 = ", string(rSquaredTrain),...
                                  ", RMSE = ",string(rmseTrain),...
                                   ", N = ",string(length(dataXTrain)));
    Middle2nd_Title = strcat("Validating: R^2 = ", string(rSquaredValid),...
                                  ", RMSE = ",string(rmseValid),...
                                   ", N = ",string(length(dataXValid)));                               
                               
    Bottom_Title=strcat("Combined: R^2 = ", string(rSquared),...
                                  ", RMSE = ",string(rmse),...
                                   ", N = ",string(length(dataXAll))); 
    title({Top_Title;Middle_Title;Middle2nd_Title;Bottom_Title;stringIn2},'FontWeight','bold');

    % Uncomment the following line to preserve the X-limits of the axes
    xlim([limitLow, limitHigh]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim([limitLow, limitHigh]);
    box('on');
    axis('square');

    % Create legend
    legend1 = legend('show');
    set(legend1,'Location','northwest');
   
    saveas(figure_1,char(saveNameFig));
   
    Fig_name =strrep(saveNameFig,'.png','.fig');
    saveas(figure_1,char(Fig_name));

end