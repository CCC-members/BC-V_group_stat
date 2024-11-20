%% Get BC-VARETA Outputs
clc;
clear all;
% close all;

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

root_path = 'Z:/data3_260T/data/CCLAB_DATASETS/CHBM/CHBM_ARIOSKY/Octobre-2021/BC_V_Output_sSSBL_fixed/Open_eyes';
surf_path = 'Z:/data3_260T/data/CCLAB_DATASETS/CHBM/CHBM_ARIOSKY/Octobre-2021/BC_V_Structure/';   
output_path  = 'E:/CCLAB/Usama Riaz - BTOP/CHBM_activation/Jan_2021';
if(~isfolder(output_path))
    mkdir(output_path);
end
load(properties.general_params.colormap);

disp("-->> Starting process");
disp("------------------>> Processing CHBM normative dataset <<-----------------");
disp("----------------------------------------------------------------");
disp("-->> Finding completed files");


% Creating a report
report_name = 'CHBM_dataset_Power_spectrum_qc';
f_report('New');
% Add a title to the report
f_report('Header','Surface plot','CHBM dataset Power Spectral Density');


% Add sub-topics to the report
f_report('Sub-Index','Process description');

% Add a info to the report
f_report('Info','Transformations applied to the data'); % a line information
% Add multielements info to the report
line_1 = 'Filtering the data at 0Hz and 50Hz.';
line_2 = 'Import channel info.';
line_3 = 'Selecting good segments from marks';
line_4 = 'Selecting opened eyes events';
line_5 = 'Apply clean_rawdata() to reject bad channels and correct continuous data using Artifact Subspace Reconstruction (ASR).';
line_6 = 'Interpolate all the removed channels.';
f_report('Info',{line_1,line_2,line_3,line_4,line_5,line_6}); % multiline information cell array

% Add a info to the report
f_report('Info','BC-VARETA processing'); % a line information
% Add multielements info to the report
line_1 = 'Runned by frequency bin.';
line_2 = 'Band analysis from 0-50HZ.';
line_3 = 'Frequency resolution 0.5Hz';
line_4 = 'Priors -> IsCurv:1 IsParcel:1 IsNeigh:2';
f_report('Info',{line_1,line_2,line_3,line_4}); % multiline information cell array

%%
%%  Group 1
%%
% Checking firt subject for create the tensors
subjects_g1 = dir(fullfile(root_path,'**','BC_V_info.mat'));
disp("----------------------------------------------------------------");
info_g1                 = load('CHBM_info');
subject                 = subjects_g1(1);
BC_V_info               = load(fullfile(subject.folder,subject.name));
activ_level             = BC_V_info.activation_level;
activ_file              = fullfile(subject.folder,activ_level(1).Ref_path,activ_level(1).Name);
load(activ_file,"J_FSAve");
activ3D_sSSBL           = zeros(size(J_FSAve,1),length(activ_level)/3,length(subjects_g1));
activ3D_eLORETA         = zeros(size(J_FSAve,1),length(activ_level)/3,length(subjects_g1));
activ3D_LCMV            = zeros(size(J_FSAve,1),length(activ_level)/3,length(subjects_g1));
age_g1                  = zeros(length(subjects_g1),1);
count_g1 = 1;

% Add topics to the report
f_report('Index','Subjects report');
for i=1:length(subjects_g1)
    subject                 = subjects_g1(i);
    load(fullfile(subject.folder,subject.name));
    BC_V_info               = load(fullfile(subject.folder,subject.name));
    subID                   = BC_V_info.subjectID;
    %Getting subject surface
    surf        = load(fullfile(surf_path,subID,'surf','surf.mat'));
    Sc          = surf.Sc(surf.iCortex);
    
    disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
    activ_level                    = BC_V_info.activation_level;
    count = 1;
    for j=1:length(activ_level)
        activ_sSSBL = fullfile(subject.folder,activ_level(j).Ref_path,activ_level(j).Name);
        load(activ_sSSBL,"J_FSAve");
        activ3D_sSSBL(:,count,i) = J_FSAve;
%         activ_eLORETA = fullfile(subject.folder,activ_level(j+1).Ref_path,activ_level(j+1).Name);
%         load(activ_eLORETA,"J_FSAve");
%         activ3D_eLORETA(:,count,i) = J_FSAve;
%         activ_LCMV = fullfile(subject.folder,activ_level(j+2).Ref_path,activ_level(j+2).Name);
%         load(activ_LCMV,"J_FSAve");
%         activ3D_LCMV(:,count,i) = J_FSAve;
        count = count + 1;
    end 
    % Add a title to the report
    f_report('Title','Sensor and Source spectrum');
    
    % Sensor Power Spectral    
    fig_1 = openfig(fullfile(subject.folder,'Sensor_level','alpha','Power Spectral Density - alpha_7Hz-14Hz.fig'));
    title('Power Spectral');
    
    % Source Power Spectral
    J = activ3D_sSSBL(:,:,i);
    J_log = 10*log10(abs(J'));
    fig_2 = figure('Color','w','Name',"Source Power Spectral",'NumberTitle','off');
    hold on;
    F = [0.1 0.6 1.1 1.6 2.1 2.6 3.1 3.6 4 ...
        4 4.5 5 5.5 6 6.5 7 ...
        7 7.5 8 8.5 9 9.5 10 10.5 11 11.5 12 12.5 13 13.5 14 ...
        14 14.5 15 15.5 16 16.5 17 17.5 18 18.5 19 19.5 20 20.5 21 21.5 22 22.5 23 23.5 24 24.5 25 25.5 26 26.5 27 27.5 28 28.5 29 29.5 30 30.5 31 ...
        31 31.5 32 32.5 33 33.5 34 34.5 35 35.5 36 36.5 37 37.5 38 38.5 39 39.5 40 40.5 41 41.5 42 42.5 43 43.5 44 44.5 45 45.5 46 46.5 47 47.5 48 48.5 49 49.5 50];
    plot(F,J_log);
    set(gca,'Color','w','XColor','k','YColor','k');
    ylabel('PSD (dB)','Color','k');
    xlabel('Freq. (Hz)','Color','k');
    title(strcat("Source Power Spectral"),'Color','k');
    
    figures = {fig_1,fig_2};
    fig_name        = strcat("Subject-",subID);
    fig_title       = 'BC-VARETA Sensor and Source Spectral Density';
    fig_out         = merge_figures(fig_name, fig_title, figures, 'cmap', cmap, 'width', 875, 'height', 250,...
        'rows', 1, 'cols', 2, 'axis_on', {'on','on'}, 'colorbars', {'off','off'}, ...
        'view_orient',{[],[]});
    f_report('Snapshot', fig_out, fig_name, [] , [200,200,875,250]);
    close(fig_1,fig_2,fig_out);
    
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


activ3D = activ3D_sSSBL;
save(fullfile(output_path,'CHBM_sSSBL.mat'),'activ3D');
% activ3D = activ3D_eLORETA;
% save(fullfile(output_path,'CHBM_eLORETA.mat'),'activ3D');
% activ3D = activ3D_LCMV;
% save(fullfile(output_path,'CHBM_LCMV.mat'),'activ3D');
subjects = subjects_g1;
save(fullfile(output_path,'subjects.mat'),'subjects');

%%
%% Group comparison
%%
%% remove subject scale
activ3D_g1t               = log(activ3D_g1);
activ3D_g1t               = activ3D_g1t - mean(activ3D_g1t,[1 2]);
activ3D_g2t               = log(activ3D_g2);
activ3D_g2t               = activ3D_g2t - mean(activ3D_g2t,[1 2]);
activ3D_g3t               = log(activ3D_g3);
activ3D_g3t               = activ3D_g3t - mean(activ3D_g3t,[1 2]);
fig_scattergram           = plot_age_roi(activ3D_g1t,age_g1,activ3D_g2t,age_g2,activ3D_g3t,age_g3,Sc);

%% linea regression
[activ3D_g1t,activ3D_g2t,activ3D_g3t] = linear_regression(activ3D_g1t,age_g1,activ3D_g2t,age_g2,activ3D_g3t,age_g3);

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
data_diff_g1g2(data_diff_g1g2 < stats_max_abs_t.th) = 0;

%% diff g2_g3
[stats_max_abs_t,orig_max_abs_t,orig_t] = max_abs_t_2group(activ3D_g2t,activ3D_g3t,nperm,psignif);
data_diff_g2g3               = reshape(orig_t,size(activ3D_g1,1),size(activ3D_g1,2));
data_diff_g2g3(data_diff_g2g3 < stats_max_abs_t.th) = 0;

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