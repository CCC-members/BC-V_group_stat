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

root_path_g1 = 'Z:\data3_260T\data\CCLAB_DATASETS\Covid\Corrected_June_All\BC-V_Output\Norm_manual_&_auto_bin';
root_path_g2 = 'Z:\data3_260T\data\CCLAB_DATASETS\Covid\Corrected\BC-V_Output\Controls_auto_bin';
root_path_g3 = 'Z:\data3_260T\data\CCLAB_DATASETS\Covid\Corrected\BC-V_Output\Pathol_auto_bin';
output_path  = 'D:\Data\CHBM\BC-V_group_stat';

%Getting subject layout
scalp                   = load(fullfile('Z:\data3_260T\data\CCLAB_DATASETS\Covid\Corrected_June_All\BC-V_Structure\Controls_manual_&_auto\CU COVID 003\scalp\scalp.mat'));
load(properties.general_params.colormap);
Channel                 = scalp.Cdata.Channel;
elec_data               = [];
elec_data.pos           = zeros(length(Channel),3);
for ii = 1:length(Channel)
    elec_data.lbl{ii}   = Channel(ii).Name;
    temp                = Channel(ii).Loc;
    elec_data.pos(ii,:) = mean(temp,2);
end
elec_data.label         = elec_data.lbl;
elec_data.elecpos       = elec_data.pos;
elec_data.unit          = 'mm';
cfg.marker              = '';
cfg.layout              = properties.sensor_params.layout;
cfg.channel             = 'eeg';
cfg.markersymbol        = '.';
cfg.colormap            = cmap_a;
cfg.markersize          = 3;
cfg.markercolor         = [1 1 1];
topo.elec               = elec_data;
topo.label              = elec_data.lbl;
topo.dimord             = 'chan_freq';
topo.freq               = 1;

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
good_cases              = dir("Z:\data3_260T\data\CCLAB_DATASETS\CHBM\CHBM_Pedrito\CNEURO_datos\EEG_name_corrected");
good_cases(ismember({good_cases.name},{'..','.'})) = [];
info_g1                 = load('CHBM_info');
subject                 = subjects_g1(1);
load(fullfile(subject.folder,subject.name));
sensor_level            = BC_V_info.generals;
sens_file               = fullfile(subject.folder,sensor_level(1).Ref_path,sensor_level(1).Name);
load(sens_file,"Svv_channel");
sens_g1                 = zeros(size(Svv_channel,1),size(Svv_channel,3),length(subjects_g1));
age_g1                  = zeros(length(subjects_g1),1);
H                       = eye(size(Svv_channel,1)) - ones(size(Svv_channel,1))/size(Svv_channel,1);
count_g1 = 1;
for i=1:length(subjects_g1)
    subject                 = subjects_g1(i);
    load(fullfile(subject.folder,subject.name));
    subID                   = BC_V_info.subjectID;
    if(find(ismember({good_cases.name},strcat(subID,'.mat')),1))
        disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
        sensor_level            = BC_V_info.generals;
        data_info               = info_g1.data_info(contains({info_g1.data_info.SubID},subID));
        if(~isempty(data_info))
            age_g1(count_g1)    = data_info.Age;
            sens_file           = fullfile(subject.folder,sensor_level(1).Ref_path,sensor_level(1).Name);
            load(sens_file,"Svv_channel");
            for j=1:size(Svv_channel,3)
                sens_g1(:,j,count_g1) = abs(diag(H*Svv_channel(:,:,j)*H));
            end
            count_g1 = count_g1 + 1;
        end
    end
end
sens_g1(:,:,count_g1:end) = [];
age_g1(count_g1:end) = [];

%%
%%  Group 2
%%
disp("------------------>> Processing Covid-control dataset <<-----------------");
disp("----------------------------------------------------------------");
disp("-->> Finding completed files");
subjects_g2 = dir(fullfile(root_path_g2,'**','BC_V_info.mat'));
disp("----------------------------------------------------------------");
info_g2                 = load('Controls_info');
subject                 = subjects_g2(1);
load(fullfile(subject.folder,subject.name));
sensor_level            = BC_V_info.generals;
sens_file               = fullfile(subject.folder,sensor_level(1).Ref_path,sensor_level(1).Name);
load(sens_file,"Svv_channel");
sens_g2                 = zeros(size(Svv_channel,1),size(Svv_channel,3),length(subjects_g2));
age_g2                  = zeros(length(subjects_g2),1);
H                       = eye(size(Svv_channel,1)) - ones(size(Svv_channel,1))/size(Svv_channel,1);
count_g2 = 1;
for i=1:length(subjects_g2)
    subject                 = subjects_g2(i);
    load(fullfile(subject.folder,subject.name));
    subID                   = BC_V_info.subjectID;
    disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
    sensor_level            = BC_V_info.generals;
    data_info               = info_g2.data_info(contains({info_g2.data_info.SubID},subID));
    if(~isempty(data_info))
        age_g2(count_g2)    = data_info.Age;    
        sens_file           = fullfile(subject.folder,sensor_level(1).Ref_path,sensor_level(1).Name);
        load(sens_file,"Svv_channel");
        for j=1:size(Svv_channel,3)
            sens_g2(:,j,count_g2) = abs(diag(H*Svv_channel(:,:,j)*H));
        end
        count_g2 = count_g2 + 1;
    end
end
sens_g2(:,:,count_g2:end) = [];
age_g2(count_g2:end) = [];

%%
%%  Group 3
%%
disp("------------------>> Processing Covid dataset <<-----------------");
disp("----------------------------------------------------------------");
disp("-->> Finding completed files");
subjects_g3 = dir(fullfile(root_path_g3,'**','BC_V_info.mat'));
disp("----------------------------------------------------------------");
info_g3                 = load('Pathol_info');
subject                 = subjects_g3(1);
load(fullfile(subject.folder,subject.name));
sensor_level            = BC_V_info.generals;
sens_file               = fullfile(subject.folder,sensor_level(1).Ref_path,sensor_level(1).Name);
load(sens_file,"Svv_channel");
sens_g3               = zeros(size(Svv_channel,1),size(Svv_channel,3),length(subjects_g3));
age_g3                  = zeros(length(subjects_g3),1);
H                       = eye(size(Svv_channel,1)) - ones(size(Svv_channel,1))/size(Svv_channel,1);
count_g3 = 1;
for i=1:length(subjects_g3)
    subject                 = subjects_g3(i);
    load(fullfile(subject.folder,subject.name));
    subID                   = BC_V_info.subjectID;
    disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
    sensor_level            = BC_V_info.generals;
    data_info               = info_g3.data_info(contains({info_g3.data_info.SubID},subID));
    if(~isempty(data_info))
        age_g3(count_g3)    = data_info.Age;
        sens_file           = fullfile(subject.folder,sensor_level(1).Ref_path,sensor_level(1).Name);
        load(sens_file,"Svv_channel");
        for j = 1:size(Svv_channel,3)
            sens_g3(:,j,count_g3) = abs(diag(H*Svv_channel(:,:,j)*H));
        end
        count_g3 = count_g3 + 1;
    end
end
sens_g3(:,:,count_g3:end) = [];
age_g3(count_g3:end) = [];

%%
%% Group comparison
%%
%% log and remove subject scale
sens_g1t                      = log(sens_g1);
sens_g2t                      = log(sens_g2);
sens_g3t                      = log(sens_g3);
sens_g1t                      = sens_g1t - mean(sens_g1t,[1 2]);
sens_g2t                      = sens_g2t - mean(sens_g2t,[1 2]);
sens_g3t                      = sens_g3t - mean(sens_g3t,[1 2]);

%% age regression 
[sens_g1t,sens_g2t,sens_g3t]  = linear_regression(sens_g1t,age_g1,sens_g2t,age_g2,sens_g3t,age_g3);

%% organize features
sens_g1t                      = reshape(sens_g1t,size(sens_g1t,1)*size(sens_g1t,2),size(sens_g1t,3));
sens_g2t                      = reshape(sens_g2t,size(sens_g2t,1)*size(sens_g2t,2),size(sens_g2t,3));
sens_g3t                      = reshape(sens_g3t,size(sens_g3t,1)*size(sens_g3t,2),size(sens_g3t,3));
sens_g1t                      = permute(sens_g1t,[2 1]);
sens_g2t                      = permute(sens_g2t,[2 1]);
sens_g3t                      = permute(sens_g3t,[2 1]);

%% principal component analysis
[coeff,score,latent]          = pca([sens_g1t; sens_g2t; sens_g3t]);
[mappedX]                     = tsne(score,'NumDimensions',3);%'Distance','mahalanobis',,'Distance','mahalanobis''NumPCAComponents',100'Distance','mahalanobis''NumPCAComponents',100
[~, ~, dfmcd, OutIdx]         = robustcov(mappedX);%,'OutlierFraction',0.05,'Method','ogk'
g                             = {[1:1:size(sens_g1t,1)]' ...
    [(size(sens_g1t,1) + 1):1:(size(sens_g1t,1) + size(sens_g2t,1))]' ...
    [(size(sens_g1t,1) + size(sens_g2t,1) + 1):1:(size(sens_g1t,1) + size(sens_g2t,1) + size(sens_g3t,1))]'; ...
    'CHBMP' ...
    'CONTROL' ...
    'COVID'};
[fig_3D_robustcov, fig_2D_distance] = plotRobustcov(mappedX,dfmcd,g,OutIdx);

%% remove subjects
min_nsample                   = min([size(sens_g1t,1) size(sens_g2t,1) size(sens_g3t,1)]);
sens_g1t(min_nsample+1:end,:) = [];
sens_g2t(min_nsample+1:end,:) = [];
sens_g3t(min_nsample+1:end,:) = [];
psignif                       = 0.05;
nperm                         = 1000;

%% diff g1_g2
[h_g1g2,p_g1g2,~,stats_g1g2]  = ttest2(sens_g2t,sens_g1t,'Tail','both','Alpha',psignif);
[pID_g1g2,pN_g1g2]            = FDR(p_g1g2,psignif);
ind_p_g1g2                    = find(p_g1g2 > pID_g1g2);
orig_t_g1g2                   = stats_g1g2.tstat';
orig_t_g1g2(ind_p_g1g2)       = 0;
orig_t_g1g2                   = reshape(orig_t_g1g2,size(sens_g1,1),size(sens_g1,2));
figure; 
imagesc(orig_t_g1g2);
ax            = gca;
max_val       = max(abs(orig_t_g1g2(:)));
ax.CLim       = [-max_val max_val];
ax.XTick      = [1:10:101];
ax.XTickLabel = {'0', '5', '10', '15', '20', '25', '30', '35', '40', '45', '50'};
ax.YTick      = [1:1:19];
ax.YTickLabel = {'Fp1','Fp2','F3','F4','C3','C4','P3','P4','O1','O2','F7','F8','T3','T4','T5','T6','Cz','Fz','Pz'};
colormap(bipolar(201, 0.3))
colorbar
xlabel('frequency (Hz)')
ylabel('sensors 10-20 system')
title('CHBMP-Control differences');

%% diff g2_g3
[h_g2g3,p_g2g3,~,stats_g2g3]  = ttest2(sens_g3t,sens_g2t,'Tail','both','Alpha',psignif);
[pID_g2g3,pN_g2g3]            = FDR(p_g2g3,psignif);
ind_p_g2g3                    = find(p_g2g3 > pID_g2g3);
orig_t_g2g3                   = stats_g2g3.tstat';
orig_t_g2g3(ind_p_g2g3)       = 0;
orig_t_g2g3                   = reshape(orig_t_g2g3,size(sens_g2,1),size(sens_g2,2));
figure;
imagesc(orig_t_g2g3);
ax            = gca;
max_val       = max(abs(orig_t_g2g3(:)));
ax.CLim       = [-max_val max_val];
ax.XTick      = [1:10:101];
ax.XTickLabel = {'0', '5', '10', '15', '20', '25', '30', '35', '40', '45', '50'};
ax.YTick      = [1:1:19];
ax.YTickLabel = {'Fp1','Fp2','F3','F4','C3','C4','P3','P4','O1','O2','F7','F8','T3','T4','T5','T6','Cz','Fz','Pz'};
colormap(bipolar(201, 0.3))
colorbar
xlabel('frequency (Hz)')
ylabel('sensors 10-20 system')
title('Control-Covid differences');

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
    fig_out                   = fig_scattergram{band};
    fig_name                  = ['age-scattergram ',bands{band}]; 
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
    fig_name            = strcat(['sensor-tstat-normativeVScontrol' ' ' band.name ' ' 'topography']);
    title(fig_name)
    f_report('Snapshot', figure_diff_g1_g2, fig_name, [] , [200,200,875,350]);
    close(figure_diff_g1_g2);
    
    % diff g2_g3
    topo.powspctrm      = data_diff_g2g3(:,band);
    figure_diff_g2_g3   = figure;
    ft_topoplotTFR(cfg,topo);
    fig_name            = strcat(['sensor-tstat-normativeVScontrol' ' ' band.name ' ' 'topography']);
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
% sens_g1t_sub           = cov(reshape(sens_g1t,size(sens_g1t,1)*size(sens_g1t,2),size(sens_g1t,3))');
% [U,D]                  = svd(sens_g1t_sub);
% d                      = diag(D);
% sens_g1t_emb           = tsne(reshape(sens_g1t,size(sens_g1t,1)*size(sens_g1t,2),size(sens_g1t,3))','Algorithm','exact','NumDimensions',3);
% sens_g2t_emb           = tsne(reshape(sens_g2t,size(sens_g2t,1)*size(sens_g2t,2),size(sens_g2t,3))','Algorithm','exact','NumDimensions',3);
% sens_g3t_emb           = tsne(reshape(sens_g3t,size(sens_g3t,1)*size(sens_g3t,2),size(sens_g3t,3))','Algorithm','exact','NumDimensions',3);
% fig_2D_embedding1      = figure;
% subplot(1,3,1)
% scatter3(sens_g1t_emb(:,1),sens_g1t_emb(:,2),sens_g1t_emb(:,3),'MarkerEdgeColor','g','MarkerFaceColor','g');
% title('CHBMP 2D-embedding');
% subplot(1,3,2)
% scatter3(sens_g2t_emb(:,1),sens_g2t_emb(:,2),sens_g2t_emb(:,2),'MarkerEdgeColor','b','MarkerFaceColor','b');
% hold on
% scatter(sens_g2t_emb([31 71],1),sens_g2t_emb([31 71],2),'filled','MarkerEdgeColor','c','MarkerFaceColor','c');
% title('Control 2D-embedding');
% sens_g2t(:,:,[31 71])   = [];
% subplot(1,3,3)
% sscatter(sens_g3t_emb(:,1),sens_g3t_emb(:,2),'MarkerEdgeColor','r','MarkerFaceColor','r');
% title('Covid 2D-embedding');
% 
% fig_2D_embedding2      = figure;
% title('2D-embedding')
% scatter(sens_g1t_emb(:,1),sens_g1t_emb(:,2),'filled','MarkerEdgeColor','r','MarkerFaceColor','r');
% hold on
% scatter(sens_g2t_emb(:,1),sens_g2t_emb(:,2),'filled','MarkerEdgeColor','r','MarkerFaceColor','r');
% hold on
% scatter(sens_g2t_emb(:,1),sens_g2t_emb(:,2),'filled','MarkerEdgeColor','r','MarkerFaceColor','r');