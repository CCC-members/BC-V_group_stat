function fig_scattergram = plot_age_sens(data,age)
n_sens                   = size(data,1);
n_freq                   = size(data,2);
n_age                    = length(age);
f_space                   = 0:0.5:((n_freq-1)*0.5);
X                        = [ones(n_age,1) age];
age_corr                 = zeros(n_sens,n_freq);
data_regressed           = data;
fig_scattergram          = figure;
for freq = 1:n_freq
    for sens = 1:n_sens
%         scatter3(repmat(fspace(freq),n_age,1),age,squeeze(data(sens,freq,:)));
%         hold on
        Y                                = squeeze(data(sens,freq,:));
        age_corr(sens,freq)              = corr(squeeze(data(sens,freq,:)),age); 
        B                                = X\Y;
        data_regressed(sens,freq,:)      = B(1)*X(:,1) + B(2)*X(:,2);       
%         plot3(repmat(fspace(freq),n_age,1),age,squeeze(Y(sens,freq,:)));
%         hold on
    end
end
figure; 
imagesc(age_corr);
ax            = gca;
max_val       = max(abs(age_corr(:)));
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
end

