function [data2_regressed,B,R2] = linear_regression_freq(data1,data2,method)
%% linear regression of the median
% apply linear regression to the median data2 to fit the median of data1 obtaining for all subjects 
% linearly transformed data2 (data2_regressed), B (intercept and slope),R2 (goodnes of fit)
fspace       = 0.6:0.5:(79*0.5+0.1); % frequency space 99 for full frequencies
ngen         = size(data1,1);
nfreq        = size(data1,2);
nsubj        = size(data1,3);
%%
median_data1 = squeeze(median(median(data1,3),1)); % median MEG
median_data2 = squeeze(median(median(data2,3),1)); % median EEG
figure; plot(fspace,median_data1);
hold on; plot(fspace,median_data2);
xlabel('freq(Hz)');
ylabel('log-spectra');
title([method,' before regression']);
legend('logMEG','logEEG');
Y            = median_data1'; % MEG
X1           = zeros(length(Y),1);
X2           = 1 - 1./(1 + (fspace'/5).^2).^(3/2);
X3           = median_data2'; % EEG
X            = [X1 X2 X3];
B            = pinv(X)*Y;
R2           = 1 - sum((Y - B(1)*X(:,1) - B(2)*X(:,2) - B(3)*X(:,3)).^2)/sum((Y - mean(Y)).^2);
data2_regressed = B(1) + B(2)*repmat(X2',ngen,1,nsubj) + B(3)*data2;
% Y            = median_data1'; % MEG
% X1           = ones(length(Y),1);
% X2           = fspace';
% X3           = median_data2'; % EEG
% X            = [X1 X2 X3];
% B            = pinv(X)*Y;
% R2           = 1 - sum((Y - B(1)*X(:,1) - B(2)*X(:,2) - B(3)*X(:,3)).^2)/sum((Y - mean(Y)).^2);
% data2_regressed = B(1) + B(2)*repmat(X2',ngen,1,nsubj) + B(3)*data2;
%%
%figure
%subplot(1,2,1)
h1 = plot(fspace,squeeze(median(data2,3))','r');
hold on
h2 = plot(fspace,squeeze(median(data1,3))','b');
xlabel('freq(Hz)');
ylabel('log-spectra');
title([method,' MEG/EEG before regression']);
legend([h2(1),h1(1)],'logMEG','logEEG');
hold off;
%subplot(1,2,2)
figure;
h1 = plot(fspace,squeeze(median(data2_regressed,3))','r');
hold on
h2 = plot(fspace,squeeze(median(data1,3))','b');
xlabel('freq(Hz)');
ylabel('log-spectra');
title([method,' MEG/EEG after regression']);
legend([h2(1),h1(1)],'logMEG','logEEG');
hold off;

%
median_data2_regressed = squeeze(median(median(data2_regressed,3),1)); % median EEG
figure; plot(fspace,median_data1);
hold on; plot(fspace,median_data2_regressed);
xlabel('freq(Hz)');
ylabel('log-spectra');
title([method,' after regression',' R2=',num2str(R2)]);
legend('logMEG','logEEG');
end