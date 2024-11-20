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

root_path_g1 = 'Z:\data3_260T\data\CCLAB_DATASETS\CHBM\CHBM_ARIOSKY\june-2021\BC-V_Output_58Ch_sSSBL';

output_path  = 'E:\CCLAB\Usama Riaz - BTOP\CHBM_activation\Pedrito selection';

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
info_g1                 = load('CHBM_info_all');
subject                 = subjects_g1(1);
load(fullfile(subject.folder,subject.name));
sensor_level            = BC_V_info.generals;
sens_file               = fullfile(subject.folder,sensor_level(1).Ref_path,sensor_level(1).Name);
load(sens_file,"Svv_channel");
sens3D_g1               = zeros(size(Svv_channel,1),size(Svv_channel,3),length(subjects_g1));
count_g1 = 1;
for i=1:length(subjects_g1)
    subject                 = subjects_g1(i);
    load(fullfile(subject.folder,subject.name));
    subID                   = BC_V_info.subjectID;
    disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
    sensor_level            = BC_V_info.generals;
    data_info(i)            = info_g1.data_info(contains({info_g1.data_info.SubID},subID));
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
save(fullfile(output_path,'sens3D.mat'),'sens3D_g1');
save(fullfile(output_path,'data_info.mat'),'data_info');
sens3D_g1t               = log(sens3D_g1);
sens3D_g1t               = sens3D_g1t - mean(sens3D_g1t,[1 2]);

save(fullfile(output_path,'sens3D_scaled.mat'),'sens3D_g1t');
