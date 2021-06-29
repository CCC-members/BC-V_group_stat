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

root_path_g1 = 'Z:\data3_260T\data\CCLAB_DATASETS\CHBM\CHBM_ARIOSKY\june-2021\BC-V_Output_sSSBL';
output_path  = 'E:\Data\CHBM\Activation_Output';
if(~isfolder(output_path))
    mkdir(output_path);
end
load(properties.general_params.colormap);

%Getting subject surface
surf        = load(fullfile('FSAve_cortex_8k.mat'));
Sc          = surf;
save(fullfile(output_path,'FSAve_cortex.mat'),'-struct','surf');

disp("-->> Starting process");
disp("------------------>> Processing CHBM dataset <<-----------------");
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
activ_level             = BC_V_info.activation_level;
activ_file              = fullfile(subject.folder,activ_level(1).Ref_path,activ_level(1).Name);
load(activ_file,"J_FSAve");
activ3D              = zeros(size(J,1),length(activ_level),length(subjects_g1));
group_info                  = zeros(length(subjects_g1),1);
count_g = 1;
for i=1:length(subjects_g1)
    subject                 = subjects_g1(i);
    load(fullfile(subject.folder,subject.name));
    subID                   = BC_V_info.subjectID;
%     if(find(ismember({good_cases.name},strcat(subID,'.mat')),1))
        disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
        activ_level                    = BC_V_info.activation_level;
        data_info = info_g1.data_info(contains({info_g1.data_info.SubID},subID));
        if(~isempty(data_info))
            group_info(count_g)           = data_info.Age;
            for j=1:length(activ_level)
                activ_file = fullfile(subject.folder,activ_level(j).Ref_path,activ_level(j).Name);
                load(activ_file,"J_FSAve");
                activ3D(:,j,count_g) = J_FSAve;
            end
            count_g = count_g + 1;
        end
%     end
end
activ3D(:,:,count_g:end) = [];
group_info(count_g:end) = [];

save(fullfile(output_path,'FSAve_activ3D.mat'),'activ3D');
save(fullfile(output_path,'group_info.mat'),'group_info');
%%
%% Group comparison
%%
%% remove subject scale
activ_scaled               = log(activ3D);
activ_scaled               = activ_scaled - mean(activ_scaled,[1 2]);

save(fullfile(output_path,'FSAve_activ_scaled_log_&_mean.mat'),'activ_scaled');

disp("-->> Process finished.");

