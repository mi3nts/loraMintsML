clear;clc;close all

%--------------------------------------------------------------------------
% load example data
load example_training_data.mat
whos

%--------------------------------------------------------------------------
% Fit a hyper-parameter optimized super learner consisting of:
% 1. Hyper-parameter optimized NN
% 2. Hyper-parameter optimized Gaussian Process Regression
% 3. Hyper-parameter optimized ensemble of trees
tic
% Text description of estimated variable as a character string
OutDescription='Example';
Mdl = fitrsuper(In_Train,Out_Train,In_Validation,Out_Validation,OutDescription);
toc

%--------------------------------------------------------------------------
% Use the hyper-parameter optimized NN fit
Out_TrainEstimate_Fit_Super     =predictrsuper(Mdl,In_Train);
Out_ValidationEstimate_Fit_Super=predictrsuper(Mdl,In_Validation);

%--------------------------------------------------------------------------
% Calculate the mean square error and correlation coeffecient
[mse_Train_Fit_Super,r_Train_Fit_Super] = find_mse_r(Out_TrainEstimate_Fit_Super,Out_Train);
[mse_Validation_Fit_Super,r_Validation_Fit_Super] = find_mse_r(Out_ValidationEstimate_Fit_Super,Out_Validation);

%--------------------------------------------------------------------------
% Plot the scatter diagram
figure
alpha=0.55;markersize=50;

plot(Out_Train,Out_Train,'-b','LineWidth',4)
hold on
grid on
MarkerColor='#588317';
scatter(Out_Train,Out_TrainEstimate_Fit_Super,markersize,'^','filled','MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha,'MarkerEdgeColor',MarkerColor,'MarkerFaceColor',MarkerColor)

MarkerColor='#7d2027';
scatter(Out_Validation,Out_ValidationEstimate_Fit_Super,markersize,'+','MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha,'LineWidth',1,'MarkerEdgeColor',MarkerColor,'MarkerFaceColor',MarkerColor)
hold off

set(gca,'FontSize',16);
set(gca,'LineWidth',2);  
set(gca,'TickDir','out');

% graph title, axis labels, and legend
legend_text={...
    ['1:1'],...
    ['Training Super (R ' num2str(r_Train_Fit_Super,2) ',# ' num2str(length(Out_Train)) ')'],...
    ['Validation Super (R ' num2str(r_Validation_Fit_Super,2) ',# ' num2str(length(Out_Validation)) ')']...
    };
legend(legend_text,'Location','northwest','fontsize',13);
xlabel('Actual','fontsize',25);
ylabel('Estimated','fontsize',25);
xl=xlim;
ylim(xl)

title('Scatter Diagram','fontsize',30);