function [outputArg1,outputArg2] = J3Dnorm_function(method_path_fsa,J3Dnorm,sub_sample)


load('FSAve_cortex_8k.mat');
load('mycolormap_brain_basic_conn.mat');

% FSAverage results

% saving FSAve files

% mkdir(fullfile(method_path_fsa,'Jnorm-SubMean'));

J_cell = {J3Dnorm(:).J2Dnorm};
JnormMean = sum(cat(3,J_cell{:}),3)/sub_sample;
% save(fullfile(method_path_fsa,'Jnorm-SubMean',strcat('JnormMean.mat')),'JnormMean','-v7.3');


% Compiting J norm Bands and Subjec Mean
mkdir(fullfile(method_path_fsa,'Jnorm-Figures'));


JnormMeanDelta = JnormMean(:,1:9);
JnormMeanTheta = JnormMean(:,10:15);
JnormMeanAlpha = JnormMean(:,16:29);
JnormMeanBeta = JnormMean(:,30:63);
JnormMeanGamma1 = JnormMean(:,64:100);

JnormBandMeanDelta = sum(JnormMeanDelta,2)/size(JnormMeanDelta,2);
JnormBandMeanTheta = sum(JnormMeanTheta,2)/size(JnormMeanTheta,2);
JnormBandMeanAlpha = sum(JnormMeanAlpha,2)/size(JnormMeanAlpha,2);
JnormBandMeanBeta = sum(JnormMeanBeta,2)/size(JnormMeanBeta,2);
JnormBandMeanGamma1 = sum(JnormMeanGamma1,2)/size(JnormMeanGamma1,2);

% save(fullfile(method_path_fsa,'Jnorm-Figures',strcat('JnormBandMeanDelta.mat')),'JnormBandMeanDelta','-v7.3');
% save(fullfile(method_path_fsa,'Jnorm-Figures',strcat('JnormBandMeanTheta.mat')),'JnormBandMeanTheta','-v7.3');
% save(fullfile(method_path_fsa,'Jnorm-Figures',strcat('JnormBandMeanAlpha.mat')),'JnormBandMeanAlpha','-v7.3');
% save(fullfile(method_path_fsa,'Jnorm-Figures',strcat('JnormBandMeanBeta.mat')),'JnormBandMeanBeta','-v7.3');
% save(fullfile(method_path_fsa,'Jnorm-Figures',strcat('JnormBandMeanGamma1.mat')),'JnormBandMeanGamma1','-v7.3');

JnormBandMeanDeltaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',JnormBandMeanDelta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm Mean Delta','Color','k','FontSize',16);
file_name = strcat('Jnorm-MeanDeltaBand','.fig');
saveas(JnormBandMeanDeltaFig,fullfile(method_path_fsa,'Jnorm-Figures',file_name));
close(JnormBandMeanDeltaFig);

JnormBandMeanThetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',JnormBandMeanTheta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm Mean Theta','Color','k','FontSize',16);
file_name = strcat('Jnorm-MeanThetaBand','.fig');
saveas(JnormBandMeanThetaFig,fullfile(method_path_fsa,'Jnorm-Figures',file_name));
close(JnormBandMeanThetaFig);

JnormBandMeanAlphaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',JnormBandMeanAlpha,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm Mean Alpha','Color','k','FontSize',16);
file_name = strcat('Jnorm-MeanAlphaBand','.fig');
saveas(JnormBandMeanAlphaFig,fullfile(method_path_fsa,'Jnorm-Figures',file_name));
close(JnormBandMeanAlphaFig);

JnormBandMeanBetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',JnormBandMeanBeta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);    
colormap(gca,cmap);
title('J Norm Mean Beta','Color','k','FontSize',16);
file_name = strcat('Jnorm-MeanBetaBand','.fig');
saveas(JnormBandMeanBetaFig,fullfile(method_path_fsa,'Jnorm-Figures',file_name));
close(JnormBandMeanBetaFig);

JnormBandMeanGamma1Fig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',JnormBandMeanGamma1,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm Mean Gamma1','Color','k','FontSize',16);
file_name = strcat('Jnorm-MeanGamma1Band','.fig');
saveas(JnormBandMeanGamma1Fig,fullfile(method_path_fsa,'Jnorm-Figures',file_name));
close(JnormBandMeanGamma1Fig);


% standard desviation 

Jnorm_Delta         = J3Dnorm(:,1:9,:);
Jnorm_Delta         = reshape(Jnorm_Delta,size(Jnorm_Delta,1),size(Jnorm_Delta,2)*size(Jnorm_Delta,3));
Jnorm_std_Delta     = std(Jnorm_Delta,[],2);

JnormBandSTDDeltaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Jnorm_std_Delta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm STD Delta','Color','k','FontSize',16);
file_name = strcat('Jnorm-STDDeltaBand','.fig');
saveas(JnormBandSTDDeltaFig,fullfile(method_path_fsa,'Jnorm-Figures',file_name));
close(JnormBandSTDDeltaFig);

Jnorm_Theta         = J3Dnorm(:,10:15,:);
Jnorm_Theta         = reshape(Jnorm_Theta,size(Jnorm_Theta,1),size(Jnorm_Theta,2)*size(Jnorm_Theta,3));
Jnorm_std_Theta     = std(Jnorm_Theta,[],2);

JnormBandSTDThetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Jnorm_std_Theta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm STD Theta','Color','k','FontSize',16);
file_name = strcat('Jnorm-STDThetaBand','.fig');
saveas(JnormBandSTDThetaFig,fullfile(method_path_fsa,'Jnorm-Figures',file_name));
close(JnormBandSTDThetaFig);

Jnorm_Alpha          = J3Dnorm(:,16:29,:);
Jnorm_Alpha         = reshape(Jnorm_Alpha,size(Jnorm_Alpha,1),size(Jnorm_Alpha,2)*size(Jnorm_Alpha,3));
Jnorm_std_Alpha     = std(Jnorm_Alpha,[],2);

JnormBandSTDAlphaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Jnorm_std_Alpha,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm STD Alpha','Color','k','FontSize',16);
file_name = strcat('Jnorm-STDAlphaBand','.fig');
saveas(JnormBandSTDAlphaFig,fullfile(method_path_fsa,'Jnorm-Figures',file_name));
close(JnormBandSTDAlphaFig);

Jnorm_Beta          = J3Dnorm(:,30:63,:);
Jnorm_Beta         = reshape(Jnorm_Beta,size(Jnorm_Beta,1),size(Jnorm_Beta,2)*size(Jnorm_Beta,3));
Jnorm_std_Beta     = std(Jnorm_Beta,[],2);

JnormBandSTDBetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Jnorm_std_Beta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm STD Beta','Color','k','FontSize',16);
file_name = strcat('Jnorm-STDBetaBand','.fig');
saveas(JnormBandSTDBetaFig,fullfile(method_path_fsa,'Jnorm-Figures',file_name));
close(JnormBandSTDBetaFig);

Jnorm_Gamma1        = J3Dnorm(:,64:100,:);
Jnorm_Gamma1         = reshape(Jnorm_Gamma1,size(Jnorm_Gamma1,1),size(Jnorm_Gamma1,2)*size(Jnorm_Gamma1,3));
Jnorm_std_Gamma1     = std(Jnorm_Gamma1,[],2);

JnormBandSTDGamma1Fig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Jnorm_std_Gamma1,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Norm STD Gamma1','Color','k','FontSize',16);
file_name = strcat('Jnorm-STDGamma1Band','.fig');
saveas(JnormBandSTDGamma1Fig,fullfile(method_path_fsa,'Jnorm-Figures',file_name));
close(JnormBandSTDGamma1Fig);

end

