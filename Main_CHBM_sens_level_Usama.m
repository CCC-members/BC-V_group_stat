%% Get BC-VARETA Outputs
clc;
clear all;
close all;

addpath(genpath('external'));
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

root_path_g1 = 'Z:\data3_260T\data\CCLAB_DATASETS\CHBM\CHBM_ARIOSKY\june-2021\BC-V_Output_sSSBL';

output_path  = 'D:\Data\CHBM\BC-V_group_stat';

%Getting subject layout

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
sensor_level            = BC_V_info.generals;
sens_file               = fullfile(subject.folder,sensor_level(1).Ref_path,sensor_level(1).Name);
load(sens_file,"Svv_channel");
sens3D_g1               = zeros(size(Svv_channel,1),size(Svv_channel,3),length(subjects_g1));
age_g1                  = zeros(length(subjects_g1),1);
count_g1 = 1;
for i=1:length(subjects_g1)
    subject                 = subjects_g1(i);
    load(fullfile(subject.folder,subject.name));
    subID                   = BC_V_info.subjectID;
    disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
    sensor_level            = BC_V_info.generals;
    age_g1(i)               = info_g1.data_info(contains({info_g1.data_info.SubID},subID)).Age;
    sens_file               = fullfile(subject.folder,sensor_level(1).Ref_path,sensor_level(1).Name);
    load(sens_file,"Svv_channel");
    for j=1:size(Svv_channel,3)
        sens3D_g1(:,j,count_g1) = abs(diag(Svv_channel(:,:,j)));
    end
    count_g1 = count_g1 + 1;
end


%%
%% Group comparison
%%
%% remove subject scale 
sens3D_g1t               = log(sens3D_g1);
sens3D_g1t               = sens3D_g1t - mean(sens3D_g1t,[1 2]);
fig_scattergram          = plot_age_sens(sens3D_g1t,age_g1);

%% figures
% Creating a report
report_name = 'Covid dataset_sens_analysis';
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
%% EEG topography
for band = 1:length(bands)
    % diff g1_g2
    topo.powspctrm      = data_diff_g1g2(:,band);
    figure_diff_g1_g2   = figure;
    ft_topoplotTFR(cfg,topo);
    fig_name           = strcat(['sensor-tstat-normativeVScontrol' ' ' band.name ' ' 'topography']);
    title(fig_name)
    f_report('Snapshot', figure_diff_g1_g2, fig_name, [] , [200,200,875,350]);
    close(figure_diff_g1_g2);
    
    % diff g2_g3
    topo.powspctrm      = data_diff_g2g3(:,band);
    figure_diff_g2_g3   = figure;
    ft_topoplotTFR(cfg,topo);
    fig_name           = strcat(['sensor-tstat-normativeVScontrol' ' ' band.name ' ' 'topography']);
    title(fig_name)
    f_report('Snapshot', figure_diff_g2_g3, fig_name, [] , [200,200,875,350]);
    close(figure_diff_g2_g3);
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