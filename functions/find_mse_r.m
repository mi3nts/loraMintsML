function [mse,r] = find_mse_r(Estimate,Actual)

%--------------------------------------------------------------------------
% calculate the mean square error (MSE)
mse=sum((Estimate-Actual).^2)/length(Actual);

%--------------------------------------------------------------------------
% calculate the correlation coefficients
R=corrcoef(Estimate,Actual);
r=R(1,2);