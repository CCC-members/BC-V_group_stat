%% Get BC-VARETA Outputs
clc;
clear all;
close all;

addpath('external');
addpath('functions');
addpath('templates');
addpath('make_reports');
disp("-->> Starting process");

load('mycolormap_brain_basic_conn.mat');

output_path = fullfile(pwd,'Report');
surf        = load('Z:\data3_260T\data\CCLAB_DATASETS\Covid\Corrected\BC-V_Structure\Controls_manual_&_auto\CU COVID 003\surf\surf.mat');
Sc          = surf.Sc(surf.iCortex);
Vertices    = Sc.Vertices;
VertConn    = Sc.VertConn;
SulciMap    = Sc.SulciMap;
smoothValue = 0.66;
SurfSmoothI = 10;
Vertices    = tess_smooth(Vertices, smoothValue, SurfSmoothI,VertConn, 1);
Faces       = Sc.Faces;

disp("--------->> Processing Controls <<---------");
disp("-------------------------------------------------");
disp("-->> Finding completed files");
root_pathCtrl = "Z:\data3_260T\data\CCLAB_DATASETS\Covid\Corrected\BC-V_Output\Controls_manual_&_auto";
subjects = dir(fullfile(root_pathCtrl,'**','BC_V_info.mat'));
disp("-------------------------------------------------");

% Creating a report
f_report('New');
% Add a title to the report
f_report('Header','Surface plot','Covid dataset: Controls subjects');


% Add sub-topics to the report
f_report('Sub-Index','Process description');

% Add a info to the report
f_report('Info','Transformations applied to the data'); % a line information
% Add multielements info to the report
line_1 = 'Filtering the data at 0Hz and 50Hz.';
line_2 = 'Import channel info.';
line_3 = 'Selecting good segments from marks';
line_4 = 'Apply clean_rawdata() to reject bad channels and correct continuous data using Artifact Subspace Reconstruction (ASR).';
line_5 = 'Interpolate all the removed channels.';
f_report('Info',{line_1,line_2,line_3,line_4,line_5}); % multiline information cell array

activ3DCtrl = zeros(8002,6,length(subjects));
for i=1:length(subjects)
    subject                 = subjects(i);
    load(fullfile(subject.folder,subject.name));
    subID                   = BC_V_info.subjectID;
    disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
    % Add a title to the report
    f_report('Title','Power spectral & Alpha activation');
    fig_1 = openfig(fullfile(subject.folder,'Sensor_level','alpha','Power Spectral Density - alpha_7Hz-14Hz.fig'));
    title('Power Spectral Density');
    fig_2 = openfig(fullfile(subject.folder,'Activation_level','sSSBLpp','alpha','BC_VARETA_activation_alpha_7Hz_14Hz.fig'));
    title('Rigth view');
    fig_3 = openfig(fullfile(subject.folder,'Activation_level','sSSBLpp','alpha','BC_VARETA_activation_alpha_7Hz_14Hz.fig'));
    title('Left view');
    fig_4 = openfig(fullfile(subject.folder,'Activation_level','sSSBLpp','alpha','BC_VARETA_activation_alpha_7Hz_14Hz.fig'));
    title('Top view');
    fig_5 = openfig(fullfile(subject.folder,'Activation_level','sSSBLpp','alpha','BC_VARETA_activation_alpha_7Hz_14Hz.fig'));
    title('Front view');
    fig_6 = openfig(fullfile(subject.folder,'Activation_level','sSSBLpp','alpha','BC_VARETA_activation_alpha_7Hz_14Hz.fig'));
    title('Back view');
    figures = {fig_1,fig_2,fig_3,fig_4,fig_5,fig_6};
    fig_name        = strcat("Subject-",subID);
    fig_title       = 'BC-VARETA Spectral and Activation for alpha';
    fig_out         = merge_figures(fig_name, fig_title, figures,'cmap',cmap,...
        'rows', 2, 'cols', 3,'axis_on',{'on','off','off','off','off','off'}, 'view_orient',{[],[0,0],[180,0],[0,90],[90,0],[270,0]});
    f_report('Snapshot', fig_out, fig_name, [] , [200,200,875,400]);
    close(fig_1,fig_2,fig_3,fig_4,fig_5,fig_6,fig_out);
    
    
    %     sensor_level            = BC_V_info.sensor_level;
    %     activ_level             = BC_V_info.activation_level;
    %     delta_J_FSAve           = load(fullfile(subject.folder,activ_level.sssblpp.delta.ref_path,activ_level.sssblpp.delta.name),'J_FSAve');
    %     theta_J_FSAve           = load(fullfile(subject.folder,activ_level.sssblpp.theta.ref_path,activ_level.sssblpp.theta.name),'J_FSAve');
    %     alpha_J_FSAve           = load(fullfile(subject.folder,activ_level.sssblpp.alpha.ref_path,activ_level.sssblpp.alpha.name),'J_FSAve');
    %     beta_J_FSAve            = load(fullfile(subject.folder,activ_level.sssblpp.beta.ref_path,activ_level.sssblpp.beta.name),'J_FSAve');
    %     gamma1_J_FSAve          = load(fullfile(subject.folder,activ_level.sssblpp.gamma1.ref_path,activ_level.sssblpp.gamma1.name),'J_FSAve');
    %     gamma2_J_FSAve          = load(fullfile(subject.folder,activ_level.sssblpp.gamma2.ref_path,activ_level.sssblpp.gamma2.name),'J_FSAve');
    %
    %     delta_J_FSAve.J_FSAve   = log(1 + sqrt(abs(delta_J_FSAve.J_FSAve)/max(abs(delta_J_FSAve.J_FSAve(:)))));
    %     theta_J_FSAve.J_FSAve   = log(1 + sqrt(abs(theta_J_FSAve.J_FSAve)/max(abs(theta_J_FSAve.J_FSAve(:)))));
    %     alpha_J_FSAve.J_FSAve   = log(1 + sqrt(abs(alpha_J_FSAve.J_FSAve)/max(abs(alpha_J_FSAve.J_FSAve(:)))));
    %     beta_J_FSAve.J_FSAve    = log(1 + sqrt(abs(beta_J_FSAve.J_FSAve)/max(abs(beta_J_FSAve.J_FSAve(:)))));
    %     gamma1_J_FSAve.J_FSAve  = log(1 + sqrt(abs(gamma1_J_FSAve.J_FSAve)/max(abs(gamma1_J_FSAve.J_FSAve(:)))));
    %     gamma2_J_FSAve.J_FSAve  = log(1 + sqrt(abs(gamma2_J_FSAve.J_FSAve)/max(abs(gamma2_J_FSAve.J_FSAve(:)))));
    %
    %     activ3DCtrl(:,:,i)      = [delta_J_FSAve.J_FSAve, theta_J_FSAve.J_FSAve, alpha_J_FSAve.J_FSAve, beta_J_FSAve.J_FSAve, gamma1_J_FSAve.J_FSAve, gamma2_J_FSAve.J_FSAve];
    %
    %     conn_level = BC_V_info.connectivity_level;
    
    
end
% JnormControl = sum(activ3DCtrl,3)/length(subjects);
%
% JnormBandMeanDeltaFig = figure;
% patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+JnormControl(:,1),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
% set(gca,'xcolor','k','ycolor','k','zcolor','k');
% az = 0; el = 0;
% view(az,el);
% colormap(gca,cmap);
% title('J Norm Mean Delta','Color','k','FontSize',16);
% file_name = strcat('Jnorm-MeanDeltaBand','.fig');
% saveas(JnormBandMeanDeltaFig,fullfile(output_path,file_name));
% close(JnormBandMeanDeltaFig);
%
% JnormBandMeanThetaFig = figure;
% patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+JnormControl(:,2),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
% set(gca,'xcolor','k','ycolor','k','zcolor','k');
% az = 0; el = 0;
% view(az,el);
% colormap(gca,cmap);
% title('J Norm Mean Theta','Color','k','FontSize',16);
% file_name = strcat('Jnorm-MeanThetaBand','.fig');
% saveas(JnormBandMeanThetaFig,fullfile(output_path,file_name));
% close(JnormBandMeanThetaFig);
%
% JnormBandMeanAlphaFig = figure;
% patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+JnormControl(:,3),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
% set(gca,'xcolor','k','ycolor','k','zcolor','k');
% az = 0; el = 0;
% view(az,el);
% colormap(gca,cmap);
% title('J Norm Mean Alpha','Color','k','FontSize',16);
% file_name = strcat('Jnorm-MeanAlphaBand','.fig');
% saveas(JnormBandMeanAlphaFig,fullfile(output_path,file_name));
% close(JnormBandMeanAlphaFig);
%
% JnormBandMeanBetaFig = figure;
% patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+JnormControl(:,4),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
% set(gca,'xcolor','k','ycolor','k','zcolor','k');
% az = 0; el = 0;
% view(az,el);
% colormap(gca,cmap);
% title('J Norm Mean Beta','Color','k','FontSize',16);
% file_name = strcat('Jnorm-MeanBetaBand','.fig');
% saveas(JnormBandMeanBetaFig,fullfile(output_path,file_name));
% close(JnormBandMeanBetaFig);
%
% JnormBandMeanGamma1Fig = figure;
% patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+JnormControl(:,5),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
% set(gca,'xcolor','k','ycolor','k','zcolor','k');
% az = 0; el = 0;
% view(az,el);
% colormap(gca,cmap);
% title('J Norm Mean Gamma1','Color','k','FontSize',16);
% file_name = strcat('Jnorm-MeanGamma1Band','.fig');
% saveas(JnormBandMeanGamma1Fig,fullfile(output_path,file_name));
% close(JnormBandMeanGamma1Fig);

% % activ3DmeanCtrl = activ3DCtrl;
% % %% Specific analysis
% % for i=1:size(activ3DmeanCtrl,3)
% %     activ3DmeanCtrl(:,:,i) = log(1 + activ3DmeanCtrl(:,:,i));
% %     activ3DmeanCtrl(:,:,i) = activ3DmeanCtrl(:,:,i) - mean(activ3DmeanCtrl(:,:,i),'all');
% % end

% Add the footer info to the report
footer_title = 'Organization';
text = 'All rights reserved';
copyright = '@copy CC-Lab';
contact = 'cc-lab@neuroinformatics-collaboratory.org';
references = {'https://github.com/CCC-members', 'https://www.neuroinformatics-collaboratory.org/'};

f_report('Footer', footer_title, text, 'ref', references, 'copyright', copyright, 'contactus', contact);
disp('-->> Saving report.');
% Export the report
disp('-->> Exporting report.');
report_name = 'Covid_Ctrls_manual_&_auto';
FileFormat = 'html';
f_report('Export',output_path, report_name, FileFormat);

disp("--------->> Processing Covid <<---------");
disp("-------------------------------------------------");
disp("-->> Finding completed files");
root_pathCovid = "Z:\data3_260T\data\CCLAB_DATASETS\Covid\Corrected\BC-V_Output\Pathol_manual_&_auto";
subjects = dir(fullfile(root_pathCovid,'**','BC_V_info.mat'));

% Creating a report
f_report('New');
% Add a title to the report
f_report('Header','Surface plot','Covid dataset: Pathological subjects');

% Add sub-topics to the report
f_report('Sub-Index','Process description');

% Add a info to the report
f_report('Info','Transformations applied to the data'); % a line information
% Add multielements info to the report
line_1 = 'Filtering the data at 0Hz and 50Hz.';
line_2 = 'Import channel info.';
line_3 = 'Selecting good segments from marks';
line_4 = 'Apply clean_rawdata() to reject bad channels and correct continuous data using Artifact Subspace Reconstruction (ASR).';
line_5 = 'Interpolate all the removed channels.';
f_report('Info',{line_1,line_2,line_3,line_4,line_5}); % multiline information cell array

disp("-------------------------------------------------");
activ3DCovid = zeros(8002,6,length(subjects));
for i=1:length(subjects)
    subject                 = subjects(i);
    load(fullfile(subject.folder,subject.name));
    subID                   = BC_V_info.subjectID;
    disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
    % Add a title to the report
    f_report('Title','Power spectral & Alpha activation');
    fig_1 = openfig(fullfile(subject.folder,'Sensor_level','alpha','Power Spectral Density - alpha_7Hz-14Hz.fig'));
    title('Power Spectral Density');
    fig_2 = openfig(fullfile(subject.folder,'Activation_level','sSSBLpp','alpha','BC_VARETA_activation_alpha_7Hz_14Hz.fig'));
    title('Rigth view');
    fig_3 = openfig(fullfile(subject.folder,'Activation_level','sSSBLpp','alpha','BC_VARETA_activation_alpha_7Hz_14Hz.fig'));
    title('Left view');
    fig_4 = openfig(fullfile(subject.folder,'Activation_level','sSSBLpp','alpha','BC_VARETA_activation_alpha_7Hz_14Hz.fig'));
    title('Top view');
    fig_5 = openfig(fullfile(subject.folder,'Activation_level','sSSBLpp','alpha','BC_VARETA_activation_alpha_7Hz_14Hz.fig'));
    title('Front view');
    fig_6 = openfig(fullfile(subject.folder,'Activation_level','sSSBLpp','alpha','BC_VARETA_activation_alpha_7Hz_14Hz.fig'));
    title('Back view');
    figures = {fig_1,fig_2,fig_3,fig_4,fig_5,fig_6};
    fig_name        = strcat("Subject-",subID);
    fig_title       = 'BC-VARETA Spectral and Activation for alpha';
    fig_out         = merge_figures(fig_name, fig_title, figures,'cmap',cmap,...
        'rows', 2, 'cols', 3,'axis_on',{'on','off','off','off','off','off'}, 'view_orient',{[],[0,0],[180,0],[0,90],[90,0],[270,0]});
    f_report('Snapshot', fig_out, fig_name, [] , [200,200,875,400]);
    close(fig_1,fig_2,fig_3,fig_4,fig_5,fig_6,fig_out);
    
    %     sensor_level            = BC_V_info.sensor_level;
    %     activ_level             = BC_V_info.activation_level;
    %     delta_J_FSAve           = load(fullfile(subject.folder,activ_level.sssblpp.delta.ref_path,activ_level.sssblpp.delta.name),'J_FSAve');
    %     theta_J_FSAve           = load(fullfile(subject.folder,activ_level.sssblpp.theta.ref_path,activ_level.sssblpp.theta.name),'J_FSAve');
    %     alpha_J_FSAve           = load(fullfile(subject.folder,activ_level.sssblpp.alpha.ref_path,activ_level.sssblpp.alpha.name),'J_FSAve');
    %     beta_J_FSAve            = load(fullfile(subject.folder,activ_level.sssblpp.beta.ref_path,activ_level.sssblpp.beta.name),'J_FSAve');
    %     gamma1_J_FSAve          = load(fullfile(subject.folder,activ_level.sssblpp.gamma1.ref_path,activ_level.sssblpp.gamma1.name),'J_FSAve');
    %     gamma2_J_FSAve          = load(fullfile(subject.folder,activ_level.sssblpp.gamma2.ref_path,activ_level.sssblpp.gamma2.name),'J_FSAve');
    %
    %     delta_J_FSAve.J_FSAve   = log(1 + sqrt(abs(delta_J_FSAve.J_FSAve)/max(abs(delta_J_FSAve.J_FSAve(:)))));
    %     theta_J_FSAve.J_FSAve   = log(1 + sqrt(abs(theta_J_FSAve.J_FSAve)/max(abs(theta_J_FSAve.J_FSAve(:)))));
    %     alpha_J_FSAve.J_FSAve   = log(1 + sqrt(abs(alpha_J_FSAve.J_FSAve)/max(abs(alpha_J_FSAve.J_FSAve(:)))));
    %     beta_J_FSAve.J_FSAve    = log(1 + sqrt(abs(beta_J_FSAve.J_FSAve)/max(abs(beta_J_FSAve.J_FSAve(:)))));
    %     gamma1_J_FSAve.J_FSAve  = log(1 + sqrt(abs(gamma1_J_FSAve.J_FSAve)/max(abs(gamma1_J_FSAve.J_FSAve(:)))));
    %     gamma2_J_FSAve.J_FSAve  = log(1 + sqrt(abs(gamma2_J_FSAve.J_FSAve)/max(abs(gamma2_J_FSAve.J_FSAve(:)))));
    %
    %     activ3DCovid(:,:,i)     = [delta_J_FSAve.J_FSAve, theta_J_FSAve.J_FSAve, alpha_J_FSAve.J_FSAve, beta_J_FSAve.J_FSAve, gamma1_J_FSAve.J_FSAve, gamma2_J_FSAve.J_FSAve];
    %
    %
    %     conn_level = BC_V_info.connectivity_level;
    
end
% JnormCovid = sum(activ3DCovid,3)/length(subjects);
%
% JnormBandMeanDeltaFig = figure;
% patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',JnormCovid(:,1),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
% set(gca,'xcolor','k','ycolor','k','zcolor','k');
% az = 0; el = 0;
% view(az,el);
% colormap(gca,cmap);
% title('J Norm Mean Delta','Color','k','FontSize',16);
% file_name = strcat('Jnorm-MeanDeltaBand','.fig');
% saveas(JnormBandMeanDeltaFig,fullfile(output_path,file_name));
% close(JnormBandMeanDeltaFig);
%
% JnormBandMeanThetaFig = figure;
% patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',JnormCovid(:,2),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
% set(gca,'xcolor','k','ycolor','k','zcolor','k');
% az = 0; el = 0;
% view(az,el);
% colormap(gca,cmap);
% title('J Norm Mean Theta','Color','k','FontSize',16);
% file_name = strcat('Jnorm-MeanThetaBand','.fig');
% saveas(JnormBandMeanThetaFig,fullfile(output_path,file_name));
% close(JnormBandMeanThetaFig);
%
% JnormBandMeanAlphaFig = figure;
% patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',JnormCovid(:,3),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
% set(gca,'xcolor','k','ycolor','k','zcolor','k');
% az = 0; el = 0;
% view(az,el);
% colormap(gca,cmap);
% title('J Norm Mean Alpha','Color','k','FontSize',16);
% file_name = strcat('Jnorm-MeanAlphaBand','.fig');
% saveas(JnormBandMeanAlphaFig,fullfile(output_path,file_name));
% close(JnormBandMeanAlphaFig);
%
% JnormBandMeanBetaFig = figure;
% patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',JnormCovid(:,4),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
% set(gca,'xcolor','k','ycolor','k','zcolor','k');
% az = 0; el = 0;
% view(az,el);
% colormap(gca,cmap);
% title('J Norm Mean Beta','Color','k','FontSize',16);
% file_name = strcat('Jnorm-MeanBetaBand','.fig');
% saveas(JnormBandMeanBetaFig,fullfile(output_path,file_name));
% close(JnormBandMeanBetaFig);
%
% JnormBandMeanGamma1Fig = figure;
% patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',JnormCovid(:,5),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
% set(gca,'xcolor','k','ycolor','k','zcolor','k');
% az = 0; el = 0;
% view(az,el);
% colormap(gca,cmap);
% title('J Norm Mean Gamma1','Color','k','FontSize',16);
% file_name = strcat('Jnorm-MeanGamma1Band','.fig');
% saveas(JnormBandMeanGamma1Fig,fullfile(output_path,file_name));
% close(JnormBandMeanGamma1Fig);

%
% % activ3DmeanCovid = activ3DCovid;
% % %% Specific analysis
% % for i=1:size(activ3DmeanCovid,3)
% %     activ3DmeanCovid(:,:,i) = log(1 + sqrt(activ3DmeanCovid(:,:,i)/max(activ3DmeanCovid(:,:,i)));
% %     activ3DmeanCovid(:,:,i) = activ3DmeanCovid(:,:,i) - mean(activ3DmeanCovid(:,:,i),'all');
% % end

% Add the footer info to the report
footer_title = 'Organization';
text = 'All rights reserved';
copyright = '@copy CC-Lab';
contact = 'cc-lab@neuroinformatics-collaboratory.org';
references = {'https://github.com/CCC-members', 'https://www.neuroinformatics-collaboratory.org/'};

f_report('Footer', footer_title, text, 'ref', references, 'copyright', copyright, 'contactus', contact);
disp('-->> Saving report.');
% Export the report
disp('-->> Exporting report.');
report_name = 'Covid_Pathol_manual_&_auto';
FileFormat = 'html';
f_report('Export',output_path, report_name, FileFormat);

disp("-->> Process finished");