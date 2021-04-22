function [outputArg1,outputArg2] = J3D_function(method_path_fsa,J3D,sub_sample)


load('FSAve_cortex_8k.mat');
load('mycolormap_brain_basic_conn.mat');


% FSAverage results

% saving FSAve files

mkdir(fullfile(method_path_fsa,'J-SubMean'));

J_cell = {J3D(:).J2D};
JMean = sum(cat(3,J_cell{:}),3)/sub_sample;
save(fullfile(method_path_fsa,'J-SubMean',strcat('JMean.mat')),'JMean','-v7.3');


% Compiting J norm Bands and Subjec Mean
mkdir(fullfile(method_path_fsa,'J-BandMean'));
mkdir(fullfile(method_path_fsa,'J-BandMean','BandMean-Figs'));



% non-sp
JMeanDelta = JMean(:,1:9);
JMeanTheta = JMean(:,10:15);
JMeanAlpha = JMean(:,16:29);
JMeanBeta = JMean(:,30:63);
JMeanGamma1 = JMean(:,64:100);

JBandMeanDelta = sum(JMeanDelta,2)/size(JMeanDelta,2);
JBandMeanTheta = sum(JMeanTheta,2)/size(JMeanTheta,2);
JBandMeanAlpha = sum(JMeanAlpha,2)/size(JMeanAlpha,2);
JBandMeanBeta = sum(JMeanBeta,2)/size(JMeanBeta,2);
JBandMeanGamma1 = sum(JMeanGamma1,2)/size(JMeanGamma1,2);

save(fullfile(method_path_fsa,'J-BandMean',strcat('JBandMeanDelta.mat')),'JBandMeanDelta','-v7.3');
save(fullfile(method_path_fsa,'J-BandMean',strcat('JBandMeanTheta.mat')),'JBandMeanTheta','-v7.3');
save(fullfile(method_path_fsa,'J-BandMean',strcat('JBandMeanAlpha.mat')),'JBandMeanAlpha','-v7.3');
save(fullfile(method_path_fsa,'J-BandMean',strcat('JBandMeanBeta.mat')),'JBandMeanBeta','-v7.3');
save(fullfile(method_path_fsa,'J-BandMean',strcat('JBandMeanGamma1.mat')),'JBandMeanGamma1','-v7.3');

JBandMeanDeltaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+JBandMeanDelta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Mean Delta','Color','k','FontSize',16);
file_name = strcat('J-BandMeanDelta','.fig');
saveas(JBandMeanDeltaFig,fullfile(method_path_fsa,'J-BandMean','BandMean-Figs',file_name));
close(JBandMeanDeltaFig);

JBandMeanThetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+JBandMeanTheta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Mean Theta','Color','k','FontSize',16);
file_name = strcat('J-BandMeanTheta','.fig');
saveas(JBandMeanThetaFig,fullfile(method_path_fsa,'J-BandMean','BandMean-Figs',file_name));
close(JBandMeanThetaFig);

JBandMeanAlphaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+JBandMeanAlpha,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Mean Alpha','Color','k','FontSize',16);
file_name = strcat('J-BandMeanAlpha','.fig');
saveas(JBandMeanAlphaFig,fullfile(method_path_fsa,'J-BandMean','BandMean-Figs',file_name));
close(JBandMeanAlphaFig);

JBandMeanBetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+JBandMeanBeta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Mean Beta','Color','k','FontSize',16);
file_name = strcat('J-BandMeanBeta','.fig');
saveas(JBandMeanBetaFig,fullfile(method_path_fsa,'J-BandMean','BandMean-Figs',file_name));
close(JBandMeanBetaFig);

JBandMeanGamma1Fig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+JBandMeanGamma1,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J Mean Gamma1','Color','k','FontSize',16);
file_name = strcat('J-BandMeanGamma1','.fig');
saveas(JBandMeanGamma1Fig,fullfile(method_path_fsa,'J-BandMean','BandMean-Figs',file_name));
close(JBandMeanGamma1Fig);


% standard desviation 
mkdir(fullfile(method_path_fsa,'J-BandMean','STD-Figs'));

J_Delta         = J3D(:,1:9,:);
J_Delta         = sum(J_Delta,2)/sub_sample;
J_Delta         = permute(J_Delta,[1 3 2]);
J_std_Delta     = std(J_Delta,0,2);

JBandSTDDeltaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+J_std_Delta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J STD Delta','Color','k','FontSize',16);
file_name = strcat('J-BandMeanDelta','.fig');
saveas(JBandSTDDeltaFig,fullfile(method_path_fsa,'J-BandMean','STD-Figs',file_name));
close(JBandSTDDeltaFig);

J_Theta         = J3D(:,10:15,:);
J_Theta         = sum(J_Theta,2)/sub_sample;
J_Theta         = permute(J_Theta,[1 3 2]);
J_std_Theta     = std(J_Theta,0,2);

JBandSTDThetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+J_std_Theta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J STD Theta','Color','k','FontSize',16);
file_name = strcat('J-BandMeanTheta','.fig');
saveas(JBandSTDThetaFig,fullfile(method_path_fsa,'J-BandMean','STD-Figs',file_name));
close(JBandSTDThetaFig);

J_Alph          = J3D(:,16:29,:);
J_Alph          = sum(J_Alph,2)/sub_sample;
J_Alph          = permute(J_Alph,[1 3 2]);
J_std_Alpha     = std(J_Alph,0,2);

JBandSTDAlphaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+J_std_Alpha,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J STD Alpha','Color','k','FontSize',16);
file_name = strcat('J-BandMeanAlpha','.fig');
saveas(JBandSTDAlphaFig,fullfile(method_path_fsa,'J-BandMean','STD-Figs',file_name));
close(JBandSTDAlphaFig);

J_Beta          = J3D(:,30:63,:);
J_Beta          = sum(J_Beta,2)/sub_sample;
J_Beta          = permute(J_Beta,[1 3 2]);
J_std_Beta      = std(J_Beta,0,2);

JBandSTDBetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+J_std_Beta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J STD Beta','Color','k','FontSize',16);
file_name = strcat('J-BandMeanBeta','.fig');
saveas(JBandSTDBetaFig,fullfile(method_path_fsa,'J-BandMean','STD-Figs',file_name));
close(JBandSTDBetaFig);

J_Gamma1        = J3D(:,64:100,:);
J_Gamma1        = sum(J_Gamma1,2);
J_Gamma1        = permute(J_Gamma1,[1 3 2]);
J_std_Gamma1    = std(J_Gamma1,0,2);

JBandSTDGamma1Fig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+J_std_Gamma1,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J STD Gamma1','Color','k','FontSize',16);
file_name = strcat('J-BandMeanGamma1','.fig');
saveas(JBandSTDGamma1Fig,fullfile(method_path_fsa,'J-BandMean','STD-Figs',file_name));
close(JBandSTDGamma1Fig);


end

