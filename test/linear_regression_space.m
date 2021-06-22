function [data2_regressed,B,R2] = linear_regression_space(data1,data2,method)
%% linear regression of the median
% apply linear regression to the median data2 to fit the median of data1 obtaining for all subjects 
% linearly transformed data2 (data2_regressed), B (intercept and slope),R2 (goodnes of fit)
fspace          = 0.6:0.5:(79*0.5+0.1); % frequency space 99 for full frequencies
ngen            = size(data1,1);
nfreq           = size(data1,2);
nsubj           = size(data1,3);
median_data1    = squeeze(median(data1,3)); % median MEG
median_data2    = squeeze(median(data2,3)); % median EEG
for freq = 1:nfreq
    Y         = squeeze(median_data1(:,freq)); % MEG
    X2        = squeeze(median_data2(:,freq)); % EEG
    X         = [ones(length(X2),1) X2];
    B(:,freq) = pinv(X)*Y;
    R2(freq)  = 1 - sum((Y - B(1,freq)*X(:,1) - B(2,freq)*X(:,2)).^2)/sum((Y - mean(Y)).^2);
    for subj = 1:nsubj
        X2                           = squeeze(data2(:,freq,subj)); % EEG
        X                            = [ones(length(X2),1) X2];
        data2_regressed(:,freq,subj) = X*B(:,freq);
    end  
end
figure; plot(fspace,B');
xlabel('freq(Hz)');
ylabel('linear coefficients');
title([method,' spatial regression factors']);
legend('scale difference','exponential contraction');
figure; plot(fspace,R2);
xlabel('freq(Hz)');
ylabel('R2 coefficient');
title([method,' R2 linear regression']);

% figure;
% h2 = plot(fspace,squeeze(median(data2,3))','r');
% hold on
% h1 = plot(fspace,squeeze(median(data1,3))','b');
% xlabel('freq(Hz)');
% ylabel('log-spectra');
% title([method,' MEG/EEG before regression']);
% legend([h1(1),h2(1)],'logMEG','logEEG');
% hold off;
% %subplot(1,2,2)
% figure;
% h2 = plot(fspace,squeeze(median(data1,3))','b');
% hold on
% h1 = plot(fspace,squeeze(median(data2_regressed,3))','r');
% xlabel('freq(Hz)');
% ylabel('log-spectra');
% title([method,' MEG/EEG after regression']);
% legend([h2(1),h1(1)],'logMEG','logEEG');
% hold off;
end