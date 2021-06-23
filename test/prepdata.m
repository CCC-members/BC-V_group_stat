function [data] = prepdata(data_path,method)
% load data tensors
load([data_path,'FSAverage\MEG\',method,'\','J3D_interp.mat']);
data1 = abs(J3D).^(1/6); % cubic transformation of highly skewed data
load([data_path,'FSAverage\EEG\',method,'\','J3D.mat']);
data2 = abs(J3D).^(1/6); % cubic transformation of highly skewed data

% keep good cases
load([data_path,'goodIndEEG.mat']); % good indices EEG
data1 = data1(:,:,[1:45]); % keep 45 cases (45 good cases for EEG)
data2 = data2(:,:,goodind); % keep good cases

%% log transformation
data1 = log(data1);
data2 = log(data2);
[data2_regressed] = linear_regression(data1,data2);

%% save data
data.data1   = reshape(data1,size(data1,1)*size(data1,2),size(data1,3))';
data.data2   = reshape(data2,size(data2,1)*size(data2,2),size(data2,3))';

%% linear regression
data.data2_regressed  = reshape(data2_regressed,size(data2_regressed,1)*size(data2_regressed,2),size(data2_regressed,3))';

end