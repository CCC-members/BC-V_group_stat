function [data_g1_regressed,data_g2_regressed,data_g3_regressed] = linear_regression_sens(data_g1,age_g1,data_g2,age_g2,data_g3,age_g3)
%% linear regression of age, obtain regresion coefficients and correction of data_g1 
n_sens             = size(data_g1,1);
n_freq             = size(data_g1,2);
B_g1               = zeros(2,n_sens,n_freq);
age_corr_g1        = zeros(n_sens,n_freq);
n_age_g1           = size(data_g1,3);
X                  = [ones(n_age_g1,1) age_g1];
data_g1_regressed  = data_g1;
for sens = 1:n_sens
    for freq = 1:n_freq
        Y                              = squeeze(data_g1(sens,freq,:));
        B_g1(:,sens,freq)              = X\Y;
        age_corr_g1(sens,freq)         = corr(Y,age_g1);
        data_g1_regressed(sens,freq,:) = Y - squeeze(B_g1(1,sens,freq))*X(:,1) - squeeze(B_g1(2,sens,freq))*X(:,2);
    end
end
figure;
imagesc(age_corr_g1);
ax            = gca;
max_val       = max(abs(age_corr_g1(:)));
ax.CLim       = [-max_val max_val];
ax.XTick      = [1:10:101];
ax.XTickLabel = {'0', '5', '10', '15', '20', '25', '30', '35', '40', '45', '50'};
ax.YTick      = [1:1:19];
ax.YTickLabel = {'Fp1','Fp2','F3','F4','C3','C4','P3','P4','O1','O2','F7','F8','T3','T4','T5','T6','Cz','Fz','Pz'};
colormap(bipolar(201, 0.3))
colorbar
xlabel('frequency (Hz)')
ylabel('sensors 10-20 system')
title('CHBMP age-correlation');

%% correction of data_g2 
age_corr_g2        = zeros(n_sens,n_freq);
n_age_g2           = size(data_g2,3);
X                  = [ones(n_age_g2,1) age_g2];
data_g2_regressed  = data_g2;
for sens = 1:n_sens
    for freq = 1:n_freq
        Y                              = squeeze(data_g2(sens,freq,:));
        age_corr_g2(sens,freq)         = corr(Y,age_g2);
        data_g2_regressed(sens,freq,:) = Y - squeeze(B_g1(1,sens,freq))*X(:,1) - squeeze(B_g1(2,sens,freq))*X(:,2);  
    end
end
figure; 
imagesc(age_corr_g2);
ax            = gca;
max_val       = max(abs(age_corr_g2(:)));
ax.CLim       = [-max_val max_val];
ax.XTick      = [1:10:101];
ax.XTickLabel = {'0', '5', '10', '15', '20', '25', '30', '35', '40', '45', '50'};
ax.YTick      = [1:1:19];
ax.YTickLabel = {'Fp1','Fp2','F3','F4','C3','C4','P3','P4','O1','O2','F7','F8','T3','T4','T5','T6','Cz','Fz','Pz'};
colormap(bipolar(201, 0.3))
colorbar
xlabel('frequency (Hz)')
ylabel('sensors 10-20 system')
title('Control age-correlation');

%% correction of data_g3 
age_corr_g3        = zeros(n_sens,n_freq);
n_age_g3           = size(data_g3,3);
X                  = [ones(n_age_g3,1) age_g3];
data_g3_regressed  = data_g3;
for sens = 1:n_sens
    for freq = 1:n_freq
        Y                              = squeeze(data_g3(sens,freq,:));
        age_corr_g3(sens,freq)         = corr(Y,age_g3);
        data_g3_regressed(sens,freq,:) = Y - squeeze(B_g3(1,sens,freq))*X(:,1) - squeeze(B_g1(2,sens,freq))*X(:,2);  
    end
end
figure; 
imagesc(age_corr_g3);
ax            = gca;
max_val       = max(abs(age_corr_g3(:)));
ax.CLim       = [-max_val max_val];
ax.XTick      = [1:10:101];
ax.XTickLabel = {'0', '5', '10', '15', '20', '25', '30', '35', '40', '45', '50'};
ax.YTick      = [1:1:19];
ax.YTickLabel = {'Fp1','Fp2','F3','F4','C3','C4','P3','P4','O1','O2','F7','F8','T3','T4','T5','T6','Cz','Fz','Pz'};
colormap(bipolar(201, 0.3))
colorbar
xlabel('frequency (Hz)')
ylabel('sensors 10-20 system')
title('Covid age-correlation');

end