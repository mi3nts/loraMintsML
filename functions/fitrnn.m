function net = fitrnn(In,Out)

%--------------------------------------------------------------------------
nepochs=250;

%--------------------------------------------------------------------------
% Define a train/validation split to use inside the objective function
cv = cvpartition(numel(Out), 'Holdout', 1/3);

%--------------------------------------------------------------------------
% Define hyperparameters to optimize
vars = [
        optimizableVariable('hiddenLayerSize', [5,100], 'Type', 'integer');
        optimizableVariable('lr', [1e-3 1], 'Transform', 'log');
        ];

%--------------------------------------------------------------------------
% Optimize
MaxObjectiveEvaluations=200;
MaxObjectiveEvaluations=30;
minfn = @(T)kfoldLoss(In', Out', cv, T.hiddenLayerSize, T.lr);
results = bayesopt( ...
    minfn, ...
    vars, ...
    'MaxObjectiveEvaluations',MaxObjectiveEvaluations, ...
    'UseParallel',true, ...
    'IsObjectiveDeterministic', false, ...
    'AcquisitionFunctionName', 'expected-improvement-plus' ...
    );

% Find best results
T = bestPoint(results)

%--------------------------------------------------------------------------
% Train final model on full training set using the best hyperparameters
hiddenLayerSize=T.hiddenLayerSize;
lr=T.lr;
tf='tansig';


% Train the Network
net = train_this_nn(In,Out,hiddenLayerSize,nepochs,lr,tf);

end

%--------------------------------------------------------------------------
function rmse = kfoldLoss(x, y, cv, numHid, lr)

% Train net.
net = feedforwardnet(numHid, 'traingd');
net.trainParam.lr = lr;
net = train(net, x(:,cv.training), y(:,cv.training));

% Evaluate on validation set and compute rmse
ypred = net(x(:, cv.test));
rmse = sqrt(mean((ypred - y(cv.test)).^2));

end