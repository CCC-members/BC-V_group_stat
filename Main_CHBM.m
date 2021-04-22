%% Get BC-VARETA Outputs
clc;
clear all;
close all;

addpath('external');
addpath('functions');
addpath('templates');
addpath('make_reports');

properties = jsondecode(fileread(fullfile('app','properties.json')));

%% Printing data information
disp(strcat("-->> Name:",properties.generals.name));
disp(strcat("-->> Version:",properties.generals.version));
disp(strcat("-->> Version date:",properties.generals.version_date));
disp("=================================================================");


root_path = properties.Input_path;
output_path = properties.Output_path;
load(properties.colormap);
disp("-->> Starting process");
disp("------------------>> Processing CHBM dataset <<-----------------");
disp("----------------------------------------------------------------");
disp("-->> Finding completed files");
root_pathCtrl = "Z:\data3_260T\share_space\jcclab-users\Ariosky\BC-V_Output\CHBM_plg_good_segments";
subjects = dir(fullfile(root_pathCtrl,'**','BC_V_info.mat'));
disp("----------------------------------------------------------------");

% Creating a report
report_name = 'CHBM dataset_qc';
f_report('New');
% Add a title to the report
f_report('Header','Surface plot','CHBM dataset cleanning data');


% Add sub-topics to the report
f_report('Sub-Index','Process description');

% Add a info to the report
f_report('Info','Transformations applied to the data'); % a line information
% Add multielements info to the report
line_1 = 'Filtering the data at 0Hz and 50Hz.';
line_2 = 'Import channel info.';
line_3 = 'Selecting good segments from marks';
line_4 = 'Selecting opened and closed eyes events';
line_5 = 'Apply clean_rawdata() to reject bad channels and correct continuous data using Artifact Subspace Reconstruction (ASR).';
line_6 = 'Interpolate all the removed channels.';
f_report('Info',{line_1,line_2,line_3,line_4,line_5,line_6}); % multiline information cell array

% Checking firt subject for create the tensors
subject                 = subjects(1);
load(fullfile(subject.folder,subject.name));
sensor_level            = BC_V_info.sensor_level;
sensor_file             = fullfile(subject.folder,sensor_level(1).Ref_path,sensor_level(1).Name);
load(sensor_file, 'Svv');
activ_level             = BC_V_info.activation_level; 
activ_file              = fullfile(subject.folder,activ_level(1).Ref_path,activ_level(1).Name);        
load(activ_file,"J_FSAve");


sensor3DCtrl = cell(length(subject),length(sensor_level));
activ3DCtrl = zeros(size(J_FSAve,1),length(activ_level),length(subject));
for i=1:length(subject)
    subject                 = subjects(i);
    load(fullfile(subject.folder,subject.name));
    subID                   = BC_V_info.subjectID;
    disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
    
    %Getting subject surface
    surf        = load(fullfile('Z:\data3_260T\share_space\jcclab-users\Ariosky\BC-V_Structure\CHBM_plg_good_segments',subID,'surf\surf.mat'));
    Sc          = surf.Sc(surf.iCortex);
    Vertices    = Sc.Vertices;
    VertConn    = Sc.VertConn;
    SulciMap    = Sc.SulciMap;
    smoothValue = 0.66;
    SurfSmoothI = 10;
    Vertices    = tess_smooth(Vertices, smoothValue, SurfSmoothI,VertConn, 1);
    Faces       = Sc.Faces;
    
    % Add a title to the report
    f_report('Title','Sensor and activation results');
    fig_1_delta = openfig(fullfile(subject.folder,'Sensor_level','delta','Power Spectral Density - delta_0Hz-4Hz.fig'));
    title('Power Spectral');
    fig_2_delta = openfig(fullfile(subject.folder,'Sensor_level','delta','Scalp_2D_delta_0Hz_4Hz.fig'));
    title('Topology');
    fig_3_delta = openfig(fullfile(subject.folder,'Activation_level','sSSBLpp','delta','BC_VARETA_activation_delta_0Hz_4Hz.fig'));
    title('Activation rigth view');
    fig_4_delta = openfig(fullfile(subject.folder,'Activation_level','sSSBLpp','delta','BC_VARETA_activation_delta_0Hz_4Hz.fig'));
    title('Activation left view');
    fig_1_alpha = openfig(fullfile(subject.folder,'Sensor_level','alpha','Power Spectral Density - alpha_7Hz-14Hz.fig'));
    title('Power Spectral');
    fig_2_alpha = openfig(fullfile(subject.folder,'Sensor_level','alpha','Scalp_2D_alpha_7Hz_14Hz.fig'));
    title('Topology');
    fig_3_alpha = openfig(fullfile(subject.folder,'Activation_level','sSSBLpp','alpha','BC_VARETA_activation_alpha_7Hz_14Hz.fig'));
    title('Activation rigth view');
    fig_4_alpha = openfig(fullfile(subject.folder,'Activation_level','sSSBLpp','alpha','BC_VARETA_activation_alpha_7Hz_14Hz.fig'));
    title('Activation left view');    
    figures = {fig_1_delta,fig_2_delta,fig_3_delta,fig_4_delta,fig_1_alpha,fig_2_alpha,fig_3_alpha,fig_4_alpha};
    fig_name        = strcat("Subject-",subID);
    fig_title       = 'BC-VARETA Spectral and Activation for delta & alpha band';
    fig_out         = merge_figures(fig_name, fig_title, figures,'cmap',cmap,'width',875,'height',350,...
        'rows', 2, 'cols', 4,'axis_on',{'on','off','off','off','on','off','off','off'},...
        'view_orient',{[],[],[0,0],[180,0],[],[],[0,0],[180,0]});
    f_report('Snapshot', fig_out, fig_name, [] , [200,200,875,350]);
    close(fig_1_delta,fig_2_delta,fig_3_delta,fig_4_delta,fig_1_alpha,fig_2_alpha,fig_3_alpha,fig_4_alpha,fig_out);
        
    sensor_level            = BC_V_info.sensor_level;
    for j=1:length(sensor_level)
        sensor_file = fullfile(subject.folder,sensor_level(j).Ref_path,sensor_level(j).Name);        
        load(sensor_file, 'Svv');
        sensor3DCtrl(i,j) = {Svv};
    end
    
    activ_level             = BC_V_info.activation_level;    
    for j=1:length(activ_level)
        activ_file = fullfile(subject.folder,activ_level(j).Ref_path,activ_level(j).Name);        
        load(activ_file,"J_FSAve");
        activ3DCtrl(:,j,i) = abs(log(1 + sqrt(J_FSAve/max(J_FSAve(:)))));
    end
    
%     conn_level = BC_V_info.connectivity_level;    
    
end
% JnormControl = sum(activ3DCtrl,3)/10;
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
% report_name = 'CHBM_by_events';
FileFormat = 'html';
f_report('Export',output_path, report_name, FileFormat);

disp("-->> Process finished");