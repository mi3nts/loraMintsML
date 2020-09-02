function Out = predictrsuper(Super,In)

%--------------------------------------------------------------------------
% Use the hyper-parameter optimized NN model for regression
disp('Use the hyper-parameter optimized NN model for regression')
tic
Out_NN = Super.Mdl_NN(In')';
toc

%--------------------------------------------------------------------------
% Use the hyper-parameter optimized GPR model for regression
disp('Use the hyper-parameter optimized GPR model for regression')
tic
Out_GPR = predict(Super.Mdl_GPR,In);
toc

%--------------------------------------------------------------------------
% Use the hyper-parameter optimized Ensemble of Trees model for regression
disp('Use the hyper-parameter optimized Ensemble of Trees model for regression')
tic
Out_Ensemble = predict(Super.Mdl_Ensemble,In);
toc

%--------------------------------------------------------------------------
% Now train the super learner
disp('Use the super learner model for regression')

% The model inputs include each of the individual learners
In_Super_Train=[In Out_NN Out_GPR Out_Ensemble];

% Use the fit on the training and validation data
tic
Out_Super = predict(Super.Mdl,In_Super_Train);
toc

%--------------------------------------------------------------------------
% Find the estimated error
disp('Use the error estimate to update the Super Learner Estimate')

% The model inputs include each of the individual learners
In_Super_Error_Train=[In_Super_Train Out_Super];

% Use the error estimate to update the Super Learner Estimate
tic
Out = predict(Super.MdlError,In_Super_Error_Train)+Out_Super;
toc
