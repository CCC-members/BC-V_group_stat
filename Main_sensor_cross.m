clc;
clear all;
close all;

addpath('external');
addpath('functions');
addpath('templates');
addpath('make_reports');
addpath('test');

disp("-->> Starting process.");

root_path = "Z:\data3_260T\data\CCLAB_DATASETS\Covid\Corrected\BC-V_Output\Controls_manual_&_auto";

subjects = dir(root_path);
subjects(ismember({subjects.name},{'..','.'})) = [];
info_g2                 = load('Controls_info');
for i=1:length(subjects)
    subject = subjects(i);
    subID   = subject.name;
    disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
    data = load(fullfile(root_path,subID,'Generals','Funtional','Data_spectrum.mat'));
    data = data.Svv_channel;
    SAMPLING_FREQ = 200;
    cnames = {'Fp1'    'Fp2'    'F3'    'F4'    'C3'    'C4'    'P3'    'P4'    'O1'    'O2'    'F7'    'F8'    'T3'    'T4'    'T5'    'T6'    'Fz'    'Cz'    'Pz'};
    data_code = subID;
    reference = 'Pz';
    sub_info  = info_g2.data_info(contains({info_g2.data_info.SubID},subID));
    age = sub_info.Age;
    sex = sub_info.Sex;
    country = 'Cuba';
    eeg_device = 'Medicid4';
    
    [data_struct, error_msg] = data_gatherer(data, SAMPLING_FREQ, cnames, data_code, reference, age, sex, country, eeg_device);
    
end

disp("-->> Process finished.");