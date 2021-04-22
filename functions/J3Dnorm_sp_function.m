function [outputArg1,outputArg2] = J3Dnorm_sp_function(method_path_fsa,J3Dnorm_sp,sub_sample)


load('FSAve_cortex_8k.mat');
load('mycolormap_brain_basic_conn.mat');


% FSAverage results

% saving FSAve files

% mkdir(fullfile(method_path_fsa,'Jnorm_sp-SubMean'));


J_cell = {J3Dnorm_sp(:).J2Dnorm_sp};
Jnorm_spMean = sum(cat(3,J_cell{:}),3)/sub_sample;
% save(fullfile(method_path_fsa,'Jnorm_sp-SubMean',strcat('Jnorm_spMean.mat')),'Jnorm_spMean','-v7.3');


% Compiting J norm Bands and Subjec Mean
mkdir(fullfile(method_path_fsa,'Jnorm_sp-Figures'));

% sp
Jnorm_spMeanDelta = Jnorm_spMean(:,1:9);
Jnorm_spMeanTheta = Jnorm_spMean(:,10:15);
Jnorm_spMeanAlpha = Jnorm_spMean(:,16:29);
Jnorm_spMeanBeta = Jnorm_spMean(:,30:63);
Jnorm_spMeanGamma1 = Jnorm_spMean(:,64:100);

Jnorm_spBandMeanDelta = sum(Jnorm_spMeanDelta,2)/size(Jnorm_spMeanDelta,2);
Jnorm_spBandMeanTheta = sum(Jnorm_spMeanTheta,2)/size(Jnorm_spMeanTheta,2);
Jnorm_spBandMeanAlpha = sum(Jnorm_spMeanAlpha,2)/size(Jnorm_spMeanAlpha,2);
Jnorm_spBandMeanBeta = sum(Jnorm_spMeanBeta,2)/size(Jnorm_spMeanBeta,2);
Jnorm_spBandMeanGamma1 = sum(Jnorm_spMeanGamma1,2)/size(Jnorm_spMeanGamma1,2);

% save(fullfile(method_path_fsa,'Jnorm_sp-Figures',strcat('Jnorm_spBandMeanDelta.mat')),'Jnorm_spBandMeanDelta','-v7.3');
% save(fullfile(method_path_fsa,'Jnorm_sp-Figures',strcat('Jnorm_spBandMeanTheta.mat')),'Jnorm_spBandMeanTheta','-v7.3');
% save(fullfile(method_path_fsa,'Jnorm_sp-Figures',strcat('Jnorm_spBandMeanAlpha.mat')),'Jnorm_spBandMeanAlpha','-v7.3');
% save(fullfile(method_path_fsa,'Jnorm_sp-Figures',strcat('Jnorm_spBandMeanBeta.mat')),'Jnorm_spBandMeanBeta','-v7.3');
% save(fullfile(method_path_fsa,'Jnorm_sp-Figures',strcat('Jnorm_spBandMeanGamma1.mat')),'Jnorm_spBandMeanGamma1','-v7.3');

Jnorm_spBandMeanDeltaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Jnorm_spBandMeanDelta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm sp Mean Delta','Color','k','FontSize',16);
file_name = strcat('Jnorm_sp-MeanDeltaBand','.fig');
saveas(Jnorm_spBandMeanDeltaFig,fullfile(method_path_fsa,'Jnorm_sp-Figures',file_name));
close(Jnorm_spBandMeanDeltaFig);

Jnorm_spBandMeanThetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Jnorm_spBandMeanTheta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm sp Mean Theta','Color','k','FontSize',16);
file_name = strcat('Jnorm_sp-MeanThetaBand','.fig');
saveas(Jnorm_spBandMeanThetaFig,fullfile(method_path_fsa,'Jnorm_sp-Figures',file_name));
close(Jnorm_spBandMeanThetaFig);

Jnorm_spBandMeanAlphaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Jnorm_spBandMeanAlpha,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm sp Mean Alpha','Color','k','FontSize',16);
file_name = strcat('Jnorm_sp-MeanAlphaBand','.fig');
saveas(Jnorm_spBandMeanAlphaFig,fullfile(method_path_fsa,'Jnorm_sp-Figures',file_name));
close(Jnorm_spBandMeanAlphaFig);

Jnorm_spBandMeanBetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Jnorm_spBandMeanBeta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm sp Mean Beta','Color','k','FontSize',16);
file_name = strcat('Jnorm_sp-MeanBetaBand','.fig');
saveas(Jnorm_spBandMeanBetaFig,fullfile(method_path_fsa,'Jnorm_sp-Figures',file_name));
close(Jnorm_spBandMeanBetaFig);

Jnorm_spBandMeanGamma1Fig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Jnorm_spBandMeanGamma1,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm sp Mean Gamma1','Color','k','FontSize',16);
file_name = strcat('Jnorm_sp-MeanGamma1Band','.fig');
saveas(Jnorm_spBandMeanGamma1Fig,fullfile(method_path_fsa,'Jnorm_sp-Figures',file_name));
close(Jnorm_spBandMeanGamma1Fig);


% standard desviation 


Jnorm_sp_Delta         = J3Dnorm_sp(:,1:9,:);
Jnorm_sp_Delta         = reshape(Jnorm_sp_Delta,size(Jnorm_sp_Delta,1),size(Jnorm_sp_Delta,2)*size(Jnorm_sp_Delta,3));
Jnorm_sp_std_Delta     = std(Jnorm_sp_Delta,[],2);

Jnorm_spBandSTDDeltaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Jnorm_sp_std_Delta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm sp STD Delta','Color','k','FontSize',16);
file_name = strcat('Jnorm_sp-STDDeltaBand','.fig');
saveas(Jnorm_spBandSTDDeltaFig,fullfile(method_path_fsa,'Jnorm_sp-Figures',file_name));
close(Jnorm_spBandSTDDeltaFig);

Jnorm_sp_Theta         = J3Dnorm_sp(:,10:15,:);
Jnorm_sp_Theta         = reshape(Jnorm_sp_Theta,size(Jnorm_sp_Theta,1),size(Jnorm_sp_Theta,2)*size(Jnorm_sp_Theta,3));
Jnorm_sp_std_Theta     = std(Jnorm_sp_Theta,[],2);

Jnorm_spBandSTDThetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Jnorm_sp_std_Theta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm sp STD Theta','Color','k','FontSize',16);
file_name = strcat('Jnorm_sp-STDThetaBand','.fig');
saveas(Jnorm_spBandSTDThetaFig,fullfile(method_path_fsa,'Jnorm_sp-Figures',file_name));
close(Jnorm_spBandSTDThetaFig);

Jnorm_sp_Alpha          = J3Dnorm_sp(:,16:29,:);
Jnorm_sp_Alpha         = reshape(Jnorm_sp_Alpha,size(Jnorm_sp_Alpha,1),size(Jnorm_sp_Alpha,2)*size(Jnorm_sp_Alpha,3));
Jnorm_sp_std_Alpha     = std(Jnorm_sp_Alpha,[],2);

Jnorm_spBandSTDAlphaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Jnorm_sp_std_Alpha,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm sp STD Alpha','Color','k','FontSize',16);
file_name = strcat('Jnorm_sp-STDAlphaBand','.fig');
saveas(Jnorm_spBandSTDAlphaFig,fullfile(method_path_fsa,'Jnorm_sp-Figures',file_name));
close(Jnorm_spBandSTDAlphaFig);

Jnorm_sp_Beta          = J3Dnorm_sp(:,30:63,:);
Jnorm_sp_Beta         = reshape(Jnorm_sp_Beta,size(Jnorm_sp_Beta,1),size(Jnorm_sp_Beta,2)*size(Jnorm_sp_Beta,3));
Jnorm_sp_std_Beta     = std(Jnorm_sp_Beta,[],2);

Jnorm_spBandSTDBetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Jnorm_sp_std_Beta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm sp STD Beta','Color','k','FontSize',16);
file_name = strcat('Jnorm_sp-STDBetaBand','.fig');
saveas(Jnorm_spBandSTDBetaFig,fullfile(method_path_fsa,'Jnorm_sp-Figures',file_name));
close(Jnorm_spBandSTDBetaFig);

Jnorm_sp_Gamma1        = J3Dnorm_sp(:,64:100,:);
Jnorm_sp_Gamma1         = reshape(Jnorm_sp_Gamma1,size(Jnorm_sp_Gamma1,1),size(Jnorm_sp_Gamma1,2)*size(Jnorm_sp_Gamma1,3));
Jnorm_sp_std_Gamma1     = std(Jnorm_sp_Gamma1,[],2);

Jnorm_spBandSTDGamma1Fig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Jnorm_sp_std_Gamma1,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm sp STD Gamma1','Color','k','FontSize',16);
file_name = strcat('Jnorm_sp-STDGamma1Band','.fig');
saveas(Jnorm_spBandSTDGamma1Fig,fullfile(method_path_fsa,'Jnorm_sp-Figures',file_name));
close(Jnorm_spBandSTDGamma1Fig);


end

