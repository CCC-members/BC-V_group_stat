function [outputArg1,outputArg2] = J3Dsp_function(method_path_fsa,J3Dsp,Indms3D,sub_sample,bin_sample)


load('FSAve_cortex_8k.mat');
load('mycolormap_brain_basic_conn.mat');


% FSAverage results

% saving FSAve files

mkdir(fullfile(method_path_fsa,'Jsp-SubMean'));

JspMean = sum(J3Dsp,3)/sub_sample;
save(fullfile(method_path_fsa,'Jsp-SubMean',strcat('JMean.mat')),'JspMean','-v7.3');


% Compiting J norm Bands and Subjec Mean
mkdir(fullfile(method_path_fsa,'Jsp-BandMean'));
mkdir(fullfile(method_path_fsa,'Jsp-BandMean','BandMean-Figs'));


% non-sp
JspMeanDelta = JspMean(:,1:9);
JspMeanTheta = JspMean(:,10:15);
JspMeanAlpha = JspMean(:,16:29);
JspMeanBeta = JspMean(:,30:63);
JspMeanGamma1 = JspMean(:,64:100);

JspBandMeanDelta = sum(JspMeanDelta,2)/size(JspMeanDelta,2);
JspBandMeanTheta = sum(JspMeanTheta,2)/size(JspMeanTheta,2);
JspBandMeanAlpha = sum(JspMeanAlpha,2)/size(JspMeanAlpha,2);
JspBandMeanBeta = sum(JspMeanBeta,2)/size(JspMeanBeta,2);
JspBandMeanGamma1 = sum(JspMeanGamma1,2)/size(JspMeanGamma1,2);

save(fullfile(method_path_fsa,'Jsp-BandMean',strcat('JspBandMeanDelta.mat')),'JspBandMeanDelta','-v7.3');
save(fullfile(method_path_fsa,'Jsp-BandMean',strcat('JspBandMeanTheta.mat')),'JspBandMeanTheta','-v7.3');
save(fullfile(method_path_fsa,'Jsp-BandMean',strcat('JspBandMeanAlpha.mat')),'JspBandMeanAlpha','-v7.3');
save(fullfile(method_path_fsa,'Jsp-BandMean',strcat('JspBandMeanBeta.mat')),'JspBandMeanBeta','-v7.3');
save(fullfile(method_path_fsa,'Jsp-BandMean',strcat('JspBandMeanGamma1.mat')),'JspBandMeanGamma1','-v7.3');

JspBandMeanDeltaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+SulciMap*0.06+JspBandMeanDelta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J sp Mean Delta','Color','k','FontSize',16);
file_name = strcat('Jsp-BandMeanDelta','.fig');
saveas(JspBandMeanDeltaFig,fullfile(method_path_fsa,'Jsp-BandMean','BandMean-Figs',file_name));
close(JspBandMeanDeltaFig);

JspBandMeanThetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+SulciMap*0.06+JspBandMeanTheta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J sp Mean Theta','Color','k','FontSize',16);
file_name = strcat('Jsp-BandMeanTheta','.fig');
saveas(JspBandMeanThetaFig,fullfile(method_path_fsa,'Jsp-BandMean','BandMean-Figs',file_name));
close(JspBandMeanThetaFig);

JspBandMeanAlphaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+JspBandMeanAlpha,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J sp Mean Alpha','Color','k','FontSize',16);
file_name = strcat('Jsp-BandMeanAlpha','.fig');
saveas(JspBandMeanAlphaFig,fullfile(method_path_fsa,'Jsp-BandMean','BandMean-Figs',file_name));
close(JspBandMeanAlphaFig);

JspBandMeanBetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+JspBandMeanBeta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J sp Mean Beta','Color','k','FontSize',16);
file_name = strcat('Jsp-BandMeanBeta','.fig');
saveas(JspBandMeanBetaFig,fullfile(method_path_fsa,'Jsp-BandMean','BandMean-Figs',file_name));
close(JspBandMeanBetaFig);

JspBandMeanGamma1Fig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+JspBandMeanGamma1,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J sp Mean Gamma1','Color','k','FontSize',16);
file_name = strcat('Jsp-BandMeanGamma1','.fig');
saveas(JspBandMeanGamma1Fig,fullfile(method_path_fsa,'Jsp-BandMean','BandMean-Figs',file_name));
close(JspBandMeanGamma1Fig);

% standard desviation 
mkdir(fullfile(method_path_fsa,'Jsp-BandMean','STD-Figs'));

Jsp_Delta         = J3Dsp(:,1:9,:);
Jsp_Delta         = sum(Jsp_Delta,2)/sub_sample;
Jsp_Delta         = permute(Jsp_Delta,[1 3 2]);
Jsp_std_Delta     = std(Jsp_Delta,0,2);

JspBandSTDDeltaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+Jsp_std_Delta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J sp STD Delta','Color','k','FontSize',16);
file_name = strcat('Jsp-BandMeanDelta','.fig');
saveas(JspBandSTDDeltaFig,fullfile(method_path_fsa,'Jsp-BandMean','STD-Figs',file_name));
close(JspBandSTDDeltaFig);

Jsp_Theta         = J3Dsp(:,10:15,:);
Jsp_Theta         = sum(Jsp_Theta,2)/sub_sample;
Jsp_Theta         = permute(Jsp_Theta,[1 3 2]);
Jsp_std_Theta     = std(Jsp_Theta,0,2);

JspBandSTDThetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+Jsp_std_Theta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J sp STD Theta','Color','k','FontSize',16);
file_name = strcat('Jsp-BandMeanTheta','.fig');
saveas(JspBandSTDThetaFig,fullfile(method_path_fsa,'Jsp-BandMean','STD-Figs',file_name));
close(JspBandSTDThetaFig);

Jsp_Alph          = J3Dsp(:,16:29,:);
Jsp_Alph          = sum(Jsp_Alph,2)/sub_sample;
Jsp_Alph          = permute(Jsp_Alph,[1 3 2]);
Jsp_std_Alpha     = std(Jsp_Alph,0,2);

JspBandSTDAlphaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+Jsp_std_Alpha,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J sp STD Alpha','Color','k','FontSize',16);
file_name = strcat('Jsp-BandMeanAlpha','.fig');
saveas(JspBandSTDAlphaFig,fullfile(method_path_fsa,'Jsp-BandMean','STD-Figs',file_name));
close(JspBandSTDAlphaFig);

Jsp_Beta          = J3Dsp(:,30:63,:);
Jsp_Beta          = sum(Jsp_Beta,2)/sub_sample;
Jsp_Beta          = permute(Jsp_Beta,[1 3 2]);
Jsp_std_Beta      = std(Jsp_Beta,0,2);

JspBandSTDBetaFig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+Jsp_std_Beta,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J sp STD Beta','Color','k','FontSize',16);
file_name = strcat('Jsp-BandMeanBeta','.fig');
saveas(JspBandSTDBetaFig,fullfile(method_path_fsa,'Jsp-BandMean','STD-Figs',file_name));
close(JspBandSTDBetaFig);

Jsp_Gamma1        = J3Dsp(:,64:100,:);
Jsp_Gamma1        = sum(Jsp_Gamma1,2);
Jsp_Gamma1        = permute(Jsp_Gamma1,[1 3 2]);
Jsp_std_Gamma1    = std(Jsp_Gamma1,0,2);

JspBandSTDGamma1Fig = figure;
patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+Jsp_std_Gamma1,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
set(gca,'xcolor','k','ycolor','k','zcolor','k');
az = 0; el = 0;
view(az,el);
colormap(gca,cmap);
title('J sp STD Gamma1','Color','k','FontSize',16);
file_name = strcat('Jsp-BandMeanGamma1','.fig');
saveas(JspBandSTDGamma1Fig,fullfile(method_path_fsa,'Jsp-BandMean','STD-Figs',file_name));
close(JspBandSTDGamma1Fig);



end

