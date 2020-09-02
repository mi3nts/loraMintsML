function net = train_this_nn_optimize(In_Train,Out_Train,hiddenLayerSize,nepochs)

% itf - optimize transfer function
itf=0;

% Transfer function choices.
% transfer={'compet','elliotsig',...
%     'hardlim',...
%     'hardlims',...
%     'logsig',...
%     'netinv',...
%     'poslin',...
%     'purelin',...
%     'radbas',...
%     'radbasn',...
%     'satlin',...
%     'satlins',...
%     'softmax',...
%     'tansig',...
%     'tribas'...
%     };

% Define a train/validation split to use inside the objective function
cv = cvpartition(numel(Out_Train), 'Holdout', 1/3);

% Check if we are including the transfer function in the optimization
if itf==1
    
    % Define hyperparameters to optimize
    vars = [
            optimizableVariable('hiddenLayerSize', [1,100], 'Type', 'integer');
            optimizableVariable('lr', [1e-3 1], 'Transform', 'log');
            optimizableVariable('tf', {'tansig','logsig','elliotsig','elliot2sig','hardlim','hardlims','poslin','purelin','satlin','satlins'},'Type','categorical');
            ];
        
    % Optimize
    MaxObjectiveEvaluations=300;
    minfn = @(T)kfoldLossTF(In_Train', Out_Train', cv, T.hiddenLayerSize, T.lr, T.tf);
    results = bayesopt( ...
        minfn, ...
        vars, ...
        'MaxObjectiveEvaluations',MaxObjectiveEvaluations, ...
        'UseParallel',true, ...
        'IsObjectiveDeterministic', false, ...
        'AcquisitionFunctionName', 'expected-improvement-plus' ...
        );

    T = bestPoint(results)

    % Train final model on full training set using the best hyperparameters
    clear net
    hiddenLayerSize=T.hiddenLayerSize;
    lr=T.lr;
    tf=char(T.tf);

    % Train the Network
    net = train_this_nn(In_Train,Out_Train,hiddenLayerSize,nepochs,lr,tf)
    
    
else
    
    % Define hyperparameters to optimize
    vars = [
            optimizableVariable('hiddenLayerSize', [1,100], 'Type', 'integer');
            optimizableVariable('lr', [1e-3 1], 'Transform', 'log');
            ];
        
    % Optimize
    MaxObjectiveEvaluations=200;
    minfn = @(T)kfoldLoss(In_Train', Out_Train', cv, T.hiddenLayerSize, T.lr);
    results = bayesopt( ...
        minfn, ...
        vars, ...
        'MaxObjectiveEvaluations',MaxObjectiveEvaluations, ...
        'UseParallel',true, ...
        'IsObjectiveDeterministic', false, ...
        'AcquisitionFunctionName', 'expected-improvement-plus' ...
        );

    T = bestPoint(results)

    % Train final model on full training set using the best hyperparameters
    clear net
    hiddenLayerSize=T.hiddenLayerSize;
    lr=T.lr;
    tf='tansig';

    % Train the Network
    net = train_this_nn(In_Train,Out_Train,hiddenLayerSize,nepochs,lr,tf)
        
end
    

end


function rmse = kfoldLossTF(x, y, cv, numHid, lr, tf)

% Train net.
net = feedforwardnet(numHid, 'traingd');
net.trainParam.lr = lr;
net.layers{1}.transferFcn=char(tf);
net = train(net, x(:,cv.training), y(:,cv.training));

% Evaluate on validation set and compute rmse
ypred = net(x(:, cv.test));
rmse = sqrt(mean((ypred - y(cv.test)).^2));

end


function rmse = kfoldLoss(x, y, cv, numHid, lr)

% Train net.
net = feedforwardnet(numHid, 'traingd');
net.trainParam.lr = lr;
net = train(net, x(:,cv.training), y(:,cv.training));

% Evaluate on validation set and compute rmse
ypred = net(x(:, cv.test));
rmse = sqrt(mean((ypred - y(cv.test)).^2));

end