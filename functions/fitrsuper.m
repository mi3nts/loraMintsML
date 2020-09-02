function Super = fitrsuper(In_Train,Out_Train,In_Validation,Out_Validation,OutDescription)

%--------------------------------------------------------------------------
% set number of optimization steps for each learner
nensemble_optimize_iterations=30;
ngpr_optimize_iterations=30;
ngpr_super_optimize_iterations=20;
ngpr_super_error_optimize_iterations=20;

% Find the correct figure
fig=gcf;
figure(fig.Number)

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Train a hyper-parameter optimized NN model for regression
disp('Train a hyper-parameter optimized NN model for regression')
tic
Super.Mdl_NN=fitrnn(In_Train,Out_Train);
toc

% keep track of the optimization figures so we can close them later
opt_fig_nn=gcf

% Use the fit on the training and validation data
Out_TrainEstimate_Fit_NN = Super.Mdl_NN(In_Train')';
Out_ValidationEstimate_Fit_NN=Super.Mdl_NN(In_Validation')';

% Calculate the mean square error and correlation coeffecient
[mse_Train_Fit_NN,r_Train_Fit_NN] = find_mse_r(Out_TrainEstimate_Fit_NN,Out_Train);
[mse_Validation_Fit_NN,r_Validation_Fit_NN] = find_mse_r(Out_ValidationEstimate_Fit_NN,Out_Validation);

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Train a hyper-parameter optimized GPR model for regression
disp('Train a hyper-parameter optimized GPR model for regression')

% First Optimize all the parameters
disp('First Optimize all the GPR parameters')
tic
Mdl = fitrgp(In_Train,Out_Train,...
    'OptimizeHyperparameters','all',...
    'HyperparameterOptimizationOptions',...
        struct(...
        'AcquisitionFunctionName','expected-improvement-plus',...
        'MaxObjectiveEvaluations',ngpr_optimize_iterations,...
        'UseParallel',true ...
        )...            
    );
toc

% keep track of the optimization figures so we can close them later
opt_fig_gpr=gcf;

% Take a copy of the attributes
disp('Take a copy of the best attributes')
Best_Sigma=Mdl.HyperparameterOptimizationResults.XAtMinEstimatedObjective.Sigma;
Best_BasisFunction=char(Mdl.HyperparameterOptimizationResults.XAtMinEstimatedObjective.BasisFunction);
Best_KernelFunction=char(Mdl.HyperparameterOptimizationResults.XAtMinEstimatedObjective.KernelFunction);
Best_KernelScale=Mdl.HyperparameterOptimizationResults.XAtMinEstimatedObjective.KernelScale;
Best_Standardize=string2boolean(char(Mdl.HyperparameterOptimizationResults.XAtMinEstimatedObjective.Standardize));

% Now use these optimum settings to do an exact GPR fit
disp('Now use these optimum settings to do an exact GPR fit')
tic
Super.Mdl_GPR = compact(fitrgp(In_Train,Out_Train,...
    'Sigma',Best_Sigma,...
    'BasisFunction',Best_BasisFunction,...
    'KernelFunction',Best_KernelFunction,...
    'Standardize',Best_Standardize,...
    'FitMethod','exact',...
    'PredictMethod','exact' ...
    ));
toc                    

% Use the fit on the training and validation data
Out_TrainEstimate_Fit_GPR = predict(Super.Mdl_GPR,In_Train);
Out_ValidationEstimate_Fit_GPR=predict(Super.Mdl_GPR,In_Validation);     

% Calculate the mean square error and correlation coeffecient
[mse_Train_Fit_GPR,r_Train_Fit_GPR] = find_mse_r(Out_TrainEstimate_Fit_GPR,Out_Train);
[mse_Validation_Fit_GPR,r_Validation_Fit_GPR] = find_mse_r(Out_ValidationEstimate_Fit_GPR,Out_Validation);

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Train a hyper-parameter optimized Ensemble of Trees model for regression
disp('Train a hyper-parameter optimized Ensemble of Trees model for regression')

tic
Super.Mdl_Ensemble = compact(fitrensemble(In_Train,Out_Train,...
    'OptimizeHyperparameters','all',...
    'HyperparameterOptimizationOptions',...
        struct(...
        'AcquisitionFunctionName','expected-improvement-plus',...
        'MaxObjectiveEvaluations',nensemble_optimize_iterations,...
        'UseParallel',true ...
        )...
    ));
toc    

% keep track of the optimization figures so we can close them later
opt_fig_ensemble=gcf;

% Use the fit on the training and validation data
Out_TrainEstimate_Fit_Ensemble = predict(Super.Mdl_Ensemble,In_Train);
Out_ValidationEstimate_Fit_Ensemble=predict(Super.Mdl_Ensemble,In_Validation);  

% Calculate the mean square error and correlation coeffecient
[mse_Train_Fit_Ensemble,r_Train_Fit_Ensemble] = find_mse_r(Out_TrainEstimate_Fit_Ensemble,Out_Train);
[mse_Validation_Fit_Ensemble,r_Validation_Fit_Ensemble] = find_mse_r(Out_ValidationEstimate_Fit_Ensemble,Out_Validation);

%--------------------------------------------------------------------------
% Now train the super learner
disp('Train the super learner model for regression')

% The model inputs include each of the individual learners
In_Super_Train=[In_Train Out_TrainEstimate_Fit_NN Out_TrainEstimate_Fit_GPR Out_TrainEstimate_Fit_Ensemble];
In_Super_Validation=[In_Validation Out_ValidationEstimate_Fit_NN Out_ValidationEstimate_Fit_GPR Out_ValidationEstimate_Fit_Ensemble];

tic
Super.Mdl = compact(fitrgp(In_Super_Train,Out_Train,...
    'OptimizeHyperparameters','all',...
    'HyperparameterOptimizationOptions',...
        struct(...
        'AcquisitionFunctionName','expected-improvement-plus',...
        'MaxObjectiveEvaluations',ngpr_super_optimize_iterations,...
        'UseParallel',true ...
        )...            
    ));
toc     

% keep track of the optimization figures so we can close them later
opt_fig_super=gcf;

% Use the fit on the training and validation data
Out_TrainEstimate_Fit_Super = predict(Super.Mdl,In_Super_Train);
Out_ValidationEstimate_Fit_Super=predict(Super.Mdl,In_Super_Validation);     

% Calculate the mean square error and correlation coeffecient
[mse_Train_Fit_Super,r_Train_Fit_Super] = find_mse_r(Out_TrainEstimate_Fit_Super,Out_Train);
[mse_Validation_Fit_Super,r_Validation_Fit_Super] = find_mse_r(Out_ValidationEstimate_Fit_Super,Out_Validation);

%--------------------------------------------------------------------------
% Calculate the error
Error_TrainEstimate_Fit_Super=Out_Train-Out_TrainEstimate_Fit_Super;
Error_ValidationEstimate_Fit_Super=Out_Validation-Out_ValidationEstimate_Fit_Super;

% The model inputs include each of the individual learners
In_Super_Error_Train=[In_Super_Train Out_TrainEstimate_Fit_Super];
In_Super_Error_Validation=[In_Super_Validation Out_ValidationEstimate_Fit_Super];

% Now train the super learner error
disp('Train the super learner error model for regression')

tic
Super.MdlError = compact(fitrgp(In_Super_Error_Train,Error_TrainEstimate_Fit_Super,...
    'OptimizeHyperparameters','all',...
    'HyperparameterOptimizationOptions',...
        struct(...
        'AcquisitionFunctionName','expected-improvement-plus',...
        'MaxObjectiveEvaluations',ngpr_super_error_optimize_iterations,...
        'UseParallel',true ...
        )...            
    )); 
toc    

% keep track of the optimization figures so we can close them later
opt_fig_super_error=gcf;

% Use the error fit on the training and validation data to update the Super
% Learner Estimate
Out_TrainEstimate_Updated_Fit_Super = predict(Super.MdlError,In_Super_Error_Train)+Out_TrainEstimate_Fit_Super;
Out_ValidationEstimate_Updated_Fit_Super=predict(Super.MdlError,In_Super_Error_Validation)+Out_ValidationEstimate_Fit_Super;  

% Calculate the mean square error and correlation coeffecient
[mse_Train_Updated_Fit_Super,r_Train_Updated_Fit_Super] = find_mse_r(Out_TrainEstimate_Updated_Fit_Super,Out_Train);
[mse_Validation_Updated_Fit_Super,r_Validation_Updated_Fit_Super] = find_mse_r(Out_ValidationEstimate_Updated_Fit_Super,Out_Validation);

%--------------------------------------------------------------------------
% Plot the scatter diagram

% Set the correct figure
figure(fig.Number)

alpha=0.55;
markersize=50;

plot(Out_Train,Out_Train,'-b','LineWidth',4)
hold on
grid on
% color palletes from https://avemateiu.com/2019/10/26/20-fall-color-palettes-2019/
MarkerColor='#2b4168';
scatter(Out_Train,Out_TrainEstimate_Fit_NN,markersize,'^','filled','MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha,'MarkerEdgeColor',MarkerColor,'MarkerFaceColor',MarkerColor)
MarkerColor='#553822';
scatter(Out_Train,Out_TrainEstimate_Fit_GPR,markersize,'v','filled','MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha,'MarkerEdgeColor',MarkerColor,'MarkerFaceColor',MarkerColor)
MarkerColor='#deb83b';
scatter(Out_Train,Out_TrainEstimate_Fit_Ensemble,markersize,'s','filled','MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha,'MarkerEdgeColor',MarkerColor,'MarkerFaceColor',MarkerColor)
MarkerColor='#588317';
scatter(Out_Train,Out_TrainEstimate_Updated_Fit_Super,markersize,'o','filled','LineWidth',1,'MarkerEdgeColor',MarkerColor,'MarkerFaceColor',MarkerColor)

MarkerColor='#588317';
scatter(Out_Validation,Out_ValidationEstimate_Fit_NN,markersize,'*','MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha,'LineWidth',1,'MarkerEdgeColor',MarkerColor,'MarkerFaceColor',MarkerColor)
MarkerColor='#3f2021';
scatter(Out_Validation,Out_ValidationEstimate_Fit_GPR,markersize,'+','MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha,'LineWidth',1,'MarkerEdgeColor',MarkerColor,'MarkerFaceColor',MarkerColor)
MarkerColor='#b89d18';
scatter(Out_Validation,Out_ValidationEstimate_Fit_Ensemble,markersize,'x','MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha,'LineWidth',1,'MarkerEdgeColor',MarkerColor,'MarkerFaceColor',MarkerColor)
MarkerColor='#7d2027';
scatter(Out_Validation,Out_ValidationEstimate_Updated_Fit_Super,markersize,'.','LineWidth',1,'MarkerEdgeColor',MarkerColor,'MarkerFaceColor',MarkerColor)
hold off

set(gca,'FontSize',16);
set(gca,'LineWidth',2);  
set(gca,'TickDir','out');

% graph title, axis labels, and legend
legend_text={...
    ['1:1'],...
    ['Training NN (R ' num2str(r_Train_Fit_NN,2) ',# ' num2str(length(Out_Train)) ')'],...
    ['Training GPR (R ' num2str(r_Train_Fit_GPR,2) ',# ' num2str(length(Out_Train)) ')'],...
    ['Training Ensemble (R ' num2str(r_Train_Fit_Ensemble,2) ',# ' num2str(length(Out_Train)) ')'],...
    ['Training Super (R ' num2str(r_Train_Updated_Fit_Super,2) ',# ' num2str(length(Out_Train)) ')'],...
    ['Validation NN (R ' num2str(r_Validation_Fit_NN,2) ',# ' num2str(length(Out_Validation)) ')']...
    ['Validation GPR (R ' num2str(r_Validation_Fit_GPR,2) ',# ' num2str(length(Out_Validation)) ')']...
    ['Validation Ensemble (R ' num2str(r_Validation_Fit_Ensemble,2) ',# ' num2str(length(Out_Validation)) ')']...
    ['Validation Super (R ' num2str(r_Validation_Updated_Fit_Super,2) ',# ' num2str(length(Out_Validation)) ')']...
    };
legend(legend_text,'Location','northwest','fontsize',13);
xlabel(['Actual ' OutDescription],'fontsize',20);
ylabel(['Estimated ' OutDescription],'fontsize',20);
xl=xlim;
ylim(xl)
title({...
    ['Super Learner ' OutDescription ' Scatter Diagram'],...
    [''] ...
    },...
    'fontsize',15 ...
);

%--------------------------------------------------------------------------
% Make sure we leave the function with the correct figure active
figure(fig.Number)

