function [data_g1_regressed,data_g2_regressed,data_g3_regressed] = linear_regression(data_g1,age_g1,data_g2,age_g2,data_g3,age_g3,Sc,cmap)
%% linear regression of age
bands = {'delta','theta','alpha','beta','gamma'};
%% obtain regresion coefficients and correction of data_g1 
X1                = ones(length(age_g1),1);
X2                = age_g1;
X                 = [X1 X2];
ngen              = size(data_g1,1);
nbands            = size(data_g1,2);
nsubj_g1          = size(data_g1,3);
data_g1_regressed = data_g1;
for gen = 1:ngen
    for band = 1:nbands
        Y                             = squeeze(data_g1(gen,band,:));
        hold on
        B(:,gen,band)                 = X\Y;
        R2(gen,band)                  = 1 - sum((Y - squeeze(B(1,gen,band))*X(:,1) - squeeze(B(2,gen,band))*X(:,2)).^2)/sum((Y - mean(Y)).^2);
        corr_age(gen,band)            = corr(Y,age_g1);
        data_g1_regressed(gen,band,:) = Y - squeeze(B(1,gen,band))*X(:,1) - squeeze(B(2,gen,band))*X(:,2);     
    end
end
%% correction of data_g2 
X1                = ones(length(age_g2),1);
X2                = age_g2;
X                 = [X1 X2];
data_g2_regressed = data_g2;
for gen = 1:ngen
    for band = 1:nbands
        Y             = squeeze(data_g2(gen,band,:));
        data_g2_regressed(gen,band,:) = Y - squeeze(B(1,gen,band))*X(:,1) - squeeze(B(2,gen,band))*X(:,2);
    end
end

%% correction of data_g3 
X1                = ones(length(age_g3),1);
X2                = age_g3;
X                 = [X1 X2];
data_g3_regressed = data_g3;
for gen = 1:ngen
    for band = 1:nbands
        Y             = squeeze(data_g3(gen,band,:));
        data_g3_regressed(gen,band,:) = Y - squeeze(B(1,gen,band))*X(:,1) - squeeze(B(2,gen,band))*X(:,2);
    end
end
%%
% figure; 
% plot(reshape(B(1,:,:),ngen*nbands,1));
% hold on
% plot(reshape(B(2,:,:),ngen*nbands,1));
% xlabel('generators/band');
% ylabel('linear coefficients');
% title('spatial regression factors');
% legend('scale difference','exponential contraction');
% 
% %% R2 coefficents
% figure; plot(R2);
% xlabel('genrator/band');
% ylabel('R2');
% title('R2 linear regression');
% legend('delta','theta','alpha','beta','gamma');
% for band = 1:length(bands)
%     figure
% %     subplot(1,length(bands),band);
%     patch('Faces',Sc.Faces,'Vertices',Sc.Vertices,'FaceVertexCData',...
%         R2(:,band),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
% %     set(gca,'xcolor','k','ycolor','k','zcolor','k');
% %     patch('Faces',Sc.Faces,'Vertices',Sc.Vertices,'FaceVertexCData',Sc.SulciMap*0.06 + 0.06 +...
% %         R2(:,band),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
%     set(gca,'xcolor','k','ycolor','k','zcolor','k');
%     az = 90; el = 270;
%     view(az,el);
%     colorbar
% %     colormap(gca,cmap);
%     title(['cortex-R2 ',bands{band}]);
% end
% 
% %% linear correlations
% figure; plot(corr_age);
% xlabel('genrator/band');
% ylabel('corr');
% title('linear correlation');
% legend('delta','theta','alpha','beta','gamma');
% for band = 1:length(bands)
%     figure
% %     subplot(1,length(bands),band);
%     patch('Faces',Sc.Faces,'Vertices',Sc.Vertices,'FaceVertexCData',...
%         corr_age(:,band),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
% %     set(gca,'xcolor','k','ycolor','k','zcolor','k');
% %     patch('Faces',Sc.Faces,'Vertices',Sc.Vertices,'FaceVertexCData',Sc.SulciMap*0.06 + 0.06 +...
% %         R2(:,band),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
%     set(gca,'xcolor','k','ycolor','k','zcolor','k');
%     az = 90; el = 270;
%     view(az,el);
%     colorbar
% %     colormap(gca,cmap);
%     title(['cortex-correlation ',bands{band}]);
% end
end