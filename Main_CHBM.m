%% Get BC-VARETA Outputs
clc;
clear all;
close all;

addpath('external');
addpath('functions');
addpath('templates');
addpath('make_reports');
addpath('test');

properties = jsondecode(fileread(fullfile('app','properties.json')));

%% Printing data information
disp(strcat("-->> Name:",properties.generals.name));
disp(strcat("-->> Version:",properties.generals.version));
disp(strcat("-->> Version date:",properties.generals.version_date));
disp("=================================================================");

root_path_g1 = 'Z:\data3_260T\share_space\jcclab-users\Ariosky\BC-V_Output\CHBM_Template';
root_path_g2 = 'Z:\data3_260T\data\CCLAB_DATASETS\Covid\Corrected\BC-V_Output\Controls_manual_&_auto';
root_path_g3 = 'Z:\data3_260T\data\CCLAB_DATASETS\Covid\Corrected\BC-V_Output\Pathol_manual_&_auto';
output_path  = 'D:\Data\CHBM\BC-V_group_stat';

%Getting subject surface
surf        = load(fullfile('Z:\data3_260T\data\CCLAB_DATASETS\Covid\Corrected\BC-V_Structure\Controls_manual_&_auto\CU COVID 003\surf\surf.mat'));
Sc          = surf.Sc(surf.iCortex);

load(properties.colormap);
disp("-->> Starting process");
disp("------------------>> Processing CHBM normative dataset <<-----------------");
disp("----------------------------------------------------------------");
disp("-->> Finding completed files");

%%
%%  Group 1
%%
% Checking firt subject for create the tensors
subjects_g1 = dir(fullfile(root_path_g1,'**','BC_V_info.mat'));
disp("----------------------------------------------------------------");
info_g1                 = load('CHBM_info');
subject                 = subjects_g1(1);
load(fullfile(subject.folder,subject.name));
activ_level             = BC_V_info.activation_level;
activ_file              = fullfile(subject.folder,activ_level(1).Ref_path,activ_level(1).Name);
load(activ_file,"J");
activ3D_g1              = zeros(size(J,1),length(activ_level),length(subjects_g1));
age_g1                  = zeros(length(subjects_g1),1);
count_g1 = 1;
for i=1:length(subjects_g1)
    subject                 = subjects_g1(i);
    load(fullfile(subject.folder,subject.name));
    subID                   = BC_V_info.subjectID;
    disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
    activ_level             = BC_V_info.activation_level;   
    age_g1(i)               = info_g1.data_info(contains({info_g1.data_info.SubID},subID)).Age;
    for j=1:length(activ_level)
        activ_file = fullfile(subject.folder,activ_level(j).Ref_path,activ_level(j).Name);
        load(activ_file,"J");
        activ3D_g1(:,j,count_g1) = J;
    end
    count_g1 = count_g1 + 1;
end

%%
%%  Group 2
%%
disp("------------------>> Processing Covid-control dataset <<-----------------");
disp("----------------------------------------------------------------");
disp("-->> Finding completed files");
subjects_g2 = dir(fullfile(root_path_g2,'**','BC_V_info.mat'));
disp("----------------------------------------------------------------");
info_g2                 = load('Controls_info');
% Checking firt subject for create the tensors
subject                 = subjects_g2(1);
load(fullfile(subject.folder,subject.name));
activ_level             = BC_V_info.activation_level;
activ_file              = fullfile(subject.folder,activ_level(1).Ref_path,activ_level(1).Name);
load(activ_file,"J");
activ3D_g2              = zeros(size(J,1),length(activ_level),length(subjects_g2));
age_g2                  = zeros(length(subjects_g2),1);
count_g2                = 1;
for i=1:length(subjects_g2)
    subject                 = subjects_g2(i);
    load(fullfile(subject.folder,subject.name));
    subID                   = BC_V_info.subjectID;
    disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
    activ_level             = BC_V_info.activation_level;
    age_g2(i)               = info_g2.data_info(contains({info_g2.data_info.SubID},subID)).Age;
    for j = 1:length(activ_level)
        activ_file = fullfile(subject.folder,activ_level(j).Ref_path,activ_level(j).Name);
        load(activ_file,"J");
        activ3D_g2(:,j,count_g2) = J;
    end
    count_g2 = count_g2 + 1;
end

%%
%%  Group 3
%%
disp("------------------>> Processing Covid dataset <<-----------------");
disp("----------------------------------------------------------------");
disp("-->> Finding completed files");
subjects_g3 = dir(fullfile(root_path_g3,'**','BC_V_info.mat'));
disp("----------------------------------------------------------------");
info_g3                 = load('Pathol_info');
% Checking firt subject for create the tensors
subject                 = subjects_g3(1);
load(fullfile(subject.folder,subject.name));
activ_level             = BC_V_info.activation_level;
activ_file              = fullfile(subject.folder,activ_level(1).Ref_path,activ_level(1).Name);
load(activ_file,"J");
activ3D_g3              = zeros(size(J,1),length(activ_level),length(subjects_g3));
age_g3                  = zeros(length(subjects_g3),1);
count_g3                = 1;
for i=1:length(subjects_g3)
    subject                 = subjects_g3(i);
    load(fullfile(subject.folder,subject.name));
    subID                   = BC_V_info.subjectID;
    disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
    activ_level             = BC_V_info.activation_level;
    age_g3(i)               = info_g3.data_info(contains({info_g3.data_info.SubID},subID)).Age;
    for j = 1:length(activ_level)
        activ_file = fullfile(subject.folder,activ_level(j).Ref_path,activ_level(j).Name);
        load(activ_file,"J");
        activ3D_g3(:,j,count_g3) = J;
    end
    count_g3 = count_g3 + 1;
end


%%
%% Group comparison
%%
%% remove subject scale 
activ3D_g1t               = log(activ3D_g1);
activ3D_g1t               = activ3D_g1t - mean(activ3D_g1t,[1 2]);
fig_scattergram           = plot_age(activ3D_g1t,age_g1,Sc);

activ3D_g2t               = log(activ3D_g2);
activ3D_g3t               = log(activ3D_g3);
activ3D_g2t               = activ3D_g2t - mean(activ3D_g2t,[1 2]);
activ3D_g3t               = activ3D_g3t - mean(activ3D_g3t,[1 2]);

%% linea regression
[activ3D_g1t,activ3D_g2t,activ3D_g3t] = linear_regression(activ3D_g1t,age_g1,activ3D_g2t,age_g2,activ3D_g3t,age_g3,Sc,cmap);

activ3D_g1t               = reshape(activ3D_g1t,size(activ3D_g1t,1)*size(activ3D_g1t,2),size(activ3D_g1t,3));
activ3D_g2t               = reshape(activ3D_g2t,size(activ3D_g2t,1)*size(activ3D_g2t,2),size(activ3D_g2t,3));
activ3D_g3t               = reshape(activ3D_g3t,size(activ3D_g3t,1)*size(activ3D_g3t,2),size(activ3D_g3t,3));

activ3D_g1t               = permute(activ3D_g1t,[2 1]);
activ3D_g2t               = permute(activ3D_g2t,[2 1]);
activ3D_g3t               = permute(activ3D_g3t,[2 1]);

nperm                     = 1000;
psignif                   = 0.05;
%% diff g1_g2
[stats_max_abs_t,orig_max_abs_t,orig_t] = max_abs_t_2group(activ3D_g1t,activ3D_g2t,nperm,psignif);
data_diff_g1g2               = reshape(orig_t,size(activ3D_g1,1),size(activ3D_g1,2));
% data_diff_g1g2(data_diff_g1g2 < stats_max_abs_t.th) = 0;
%% diff g2_g3
[stats_max_abs_t,orig_max_abs_t,orig_t] = max_abs_t_2group(activ3D_g2t,activ3D_g3t,nperm,psignif);
data_diff_g2g3               = reshape(orig_t,size(activ3D_g1,1),size(activ3D_g1,2));
% data_diff_g2g3(data_diff_g2g3 < stats_max_abs_t.th) = 0;

%% figures
% Creating a report
report_name = 'Covid dataset';
f_report('New');
% Add a title to the report
f_report('Title','Group difference normativeVScontrol, controlVScovid');
% Add a title to the report
f_report('Header','Cortical topography');
% Add a info to the report
f_report('Index','Linear trend of the data with age'); % a line information
bands = {'delta','theta','alpha','beta','gamma'};
for band = 1:length(bands)
    fig_out  = fig_scattergram{band};
    fig_name = ['age-scattergram ',bands{band}]; 
    f_report('Snapshot', fig_out, fig_name, [] , [200,200,875,350]);
    close(fig_out);
end
% Add topic to the report
f_report('Index','Student T-test of the groups');
% Add a info to the report
f_report('Info','Transformations applied to the data'); % a line information
% Add multielements info to the report
line_1 = 'collect normative data_g1(gen,band,nsubj_g1)';
line_2 = 'collect control data_g2(gen,band,nsubj_g2)';
line_3 = 'collect covid data_g3(gen,band,nsubj_g3)';
line_4 = 'log transformation data <- log(data)';
line_5 = 'remove individual subject scale data <- mean(data,[1 2])';
line_6 = 'obtain age regression coefficients with normative data_g1';
line_7 = 'remove age effect in data_g1, data_g2, data_g3 with regression coeffcients';
line_8 = 'obtain Tstudent(data_g1,data_g2) between normative and control data';
line_9 = 'obtain Tstudent(data_g2,data_g3) between control and covid data';
f_report('Info',{line_1,line_2,line_3,line_4,line_5,line_6,line_7,line_8,line_9}); % multiline information cell array
%%
for band = 1:length(bands)
    % diff g1_g2
    figure_diff_g1_g2 = figure;
    patch('Faces',Sc.Faces,'Vertices',Sc.Vertices,'FaceVertexCData',...
        data_diff_g1g2(:,band),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    set(gca,'xcolor','k','ycolor','k','zcolor','k');
%     patch('Faces',Sc.Faces,'Vertices',Sc.Vertices,'FaceVertexCData',Sc.SulciMap*0.06 + 0.06 +...
%         data_diff_g1g2(:,band),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
%     set(gca,'xcolor','k','ycolor','k','zcolor','k');
%     colormap(gca,cmap);
    colorbar 
    axis off
    figures         = {figure_diff_g1_g2,figure_diff_g1_g2,figure_diff_g1_g2,figure_diff_g1_g2};
    fig_name        = strcat(['cortex-tstat-normativeVScontrol ',bands{band}]);
    fig_title       = strcat(['cortex-tstat-normativeVScontrol ',bands{band}]);
    fig_out         = merge_figures(fig_name, fig_title, figures,'width',875,'height',350,...
        'rows', 2, 'cols', 2,'axis_on',{'off','off','off','off'},...
        'colorbars',{'on','on','on','on'},...
        'view_orient',{[0,0],[180,0],[90,0],[270,0]});
    f_report('Snapshot', fig_out, fig_name, [] , [200,200,875,350]);
    close(figure_diff_g1_g2,fig_out);
    
    % diff g2_g3
    figure_diff_g2_g3 = figure;
    patch('Faces',Sc.Faces,'Vertices',Sc.Vertices,'FaceVertexCData',...
        data_diff_g2g3(:,band),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    set(gca,'xcolor','k','ycolor','k','zcolor','k');
%     patch('Faces',Sc.Faces,'Vertices',Sc.Vertices,'FaceVertexCData',Sc.SulciMap*0.06 + 0.06 +...
%         data_diff_g1g2(:,band),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
%     set(gca,'xcolor','k','ycolor','k','zcolor','k');
%     colormap(gca,cmap);
    colorbar 
    axis off
    figures         = {figure_diff_g2_g3,figure_diff_g2_g3,figure_diff_g2_g3,figure_diff_g2_g3};
    fig_name        = strcat(['cortex-tstat-controlVScovid ',bands{band}]);
    fig_title       = strcat(['cortex-tstat-controlVScovid ',bands{band}]);
    fig_out         = merge_figures(fig_name, fig_title, figures,'width',875,'height',350,...
        'rows', 2, 'cols', 2,'axis_on',{'off','off','off','off'},...
        'colorbars',{'on','on','on','on'},...
        'view_orient',{[0,0],[180,0],[90,0],[270,0]});
    f_report('Snapshot', fig_out, fig_name, [] , [200,200,875,350]);
    close(figure_diff_g2_g3,fig_out);
end

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


%%

% [activ3D_g1t,~]         = get_roi_data(activ3D_g1,Sc);
% [activ3D_g2t,~]         = get_roi_data(activ3D_g2,Sc);
% activ3D_g1t             = log(activ3D_g1t);
% activ3D_g1t             = activ3D_g1t - mean(activ3D_g1t,[1 2]);
% activ3D_g2t             = log(activ3D_g2t);
% activ3D_g2t             = activ3D_g2t - mean(activ3D_g2t,[1 2]);
% nperm                   = 1000;
% psignif                 = 0.05;
% activ3D_g1t             = reshape(activ3D_g1t,size(activ3D_g1t,1)*size(activ3D_g1t,2),size(activ3D_g1t,3));
% activ3D_g2t             = reshape(activ3D_g2t,size(activ3D_g2t,1)*size(activ3D_g2t,2),size(activ3D_g2t,3));
% activ3D_g1t             = permute(activ3D_g1t,[2 1]);
% activ3D_g2t             = permute(activ3D_g2t,[2 1]);
% 
% 
% %% mean data1
% figure
% patch('Faces',Sc.Faces,'Vertices',Sc.Vertices,'FaceVertexCData',...
%     squeeze(mean(activ3D_g1(:,1,:),3)),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
% set(gca,'xcolor','k','ycolor','k','zcolor','k');
% az = 90; el = 270;
% view(az,el);
% colormap(gca,cmap);
% % title(['cortex-tstat ',bands{band}]);
% %% mean data2
% figure
% patch('Faces',Sc.Faces,'Vertices',Sc.Vertices,'FaceVertexCData',...
%     squeeze(mean(activ3D_g2(:,1,:),3)),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
% set(gca,'xcolor','k','ycolor','k','zcolor','k');
% az = 90; el = 270;
% view(az,el);
% colormap(gca,cmap);
% % title(['cortex-tstat ',bands{band}]);
% %
% 
% 
% group_difference(activ3D_g1t,activ3D_g2t,Sc);
% 
% 
% 
% activ3D_g1t             = log(activ3D_g1t);
% activ3D_g1t             = activ3D_g1t - mean(activ3D_g1t,[1 2]);
% activ3D_g2t             = log(activ3D_g2t);
% activ3D_g2t             = activ3D_g2t - mean(activ3D_g2t,[1 2]);
% 
% 
% group_difference(activ3D_g1t_regressed,activ3D_g2t_regressed,Sc)
% 
% 
% plot_differ_by_roi(activ3D_g1t,activ3D_g2t,Sc);
% avrg_cortex(activ3D_g1t,Sc,'g1');
% avrg_cortex(activ3D_g2t,Sc,'g2');