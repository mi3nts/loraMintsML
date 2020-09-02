clear;clc;close all

%--------------------------------------------------------------------------
% load example data
load example_training_data.mat
whos

%--------------------------------------------------------------------------
% Fit an hyper-parameter optimized NN
tic
Mdl = fitrnn(In_Train,Out_Train);
toc

%--------------------------------------------------------------------------
% Use the hyper-parameter optimized NN fit
Out_TrainEstimate_Fit_NN=predictrnn(Mdl,In_Train);
Out_ValidationEstimate_Fit_NN=predictrnn(Mdl,In_Validation);

%--------------------------------------------------------------------------
% Calculate the mean square error and correlation coeffecient
[mse_Train_Fit_NN,r_Train_Fit_NN] = find_mse_r(Out_TrainEstimate_Fit_NN,Out_Train);
[mse_Validation_Fit_NN,r_Validation_Fit_NN] = find_mse_r(Out_ValidationEstimate_Fit_NN,Out_Validation);

%--------------------------------------------------------------------------
% Plot the scatter diagram
figure
alpha=0.55;markersize=50;

plot(Out_Train,Out_Train,'-b','LineWidth',4)
hold on
grid on
MarkerColor='#588317';
scatter(Out_Train,Out_TrainEstimate_Fit_NN,markersize,'^','filled','MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha,'MarkerEdgeColor',MarkerColor,'MarkerFaceColor',MarkerColor)

MarkerColor='#7d2027';
scatter(Out_Validation,Out_ValidationEstimate_Fit_NN,markersize,'+','MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha,'LineWidth',1,'MarkerEdgeColor',MarkerColor,'MarkerFaceColor',MarkerColor)
hold off

set(gca,'FontSize',16);
set(gca,'LineWidth',2);  
set(gca,'TickDir','out');

% graph title, axis labels, and legend
legend_text={...
    ['1:1'],...
    ['Training NN (R ' num2str(r_Train_Fit_NN,2) ',# ' num2str(length(Out_Train)) ')'],...
    ['Validation NN (R ' num2str(r_Validation_Fit_NN,2) ',# ' num2str(length(Out_Validation)) ')']...
    };
legend(legend_text,'Location','northwest','fontsize',13);
xlabel('Actual','fontsize',25);
ylabel('Estimated','fontsize',25);
xl=xlim;
ylim(xl)

title('Scatter Diagram','fontsize',30);