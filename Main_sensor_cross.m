clc;
clear all;
close all;

addpath('external');
addpath('functions');
addpath('templates');
addpath('make_reports');
addpath('test');

disp("-->> Starting process.");

root_path = "Z:\data3_260T\data\CCLAB_DATASETS\Covid\Corrected_June_All\BC-V_Structure\Pathol_manual_&_auto";
output_path = "E:\Data\Covid\Data_gather\Pathol";
subjects = dir(root_path);
subjects(ismember({subjects.name},{'..','.'})) = [];
info_g2                 = load('Pathol_info');
for i=1:length(subjects)
    subject = subjects(i);
    subID   = subject.name;
    disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
    sub_info = info_g2.data_info(contains({info_g2.data_info.SubID},subID));
    if(~isempty(sub_info))
        load(fullfile(root_path,subID,'meeg','meeg.mat'));
        data = MEEG.data;
        nd = size(data,1);
        nt = fix(200/0.3906);
        ne = fix(size(data,2)/nt);
        rest = nt*ne+1;
        data(:, rest:end) = [];
        data = reshape(data, nd, nt, ne);
        SAMPLING_FREQ = 200;
        cnames = {'Fp1'    'Fp2'    'F3'    'F4'    'C3'    'C4'    'P3'    'P4'    'O1'    'O2'    'F7'    'F8'    'T3'    'T4'    'T5'    'T6'    'Fz'    'Cz'    'Pz'};
        data_code = subID;
        reference = 'Pz';
        age = sub_info.Age;
        sex = sub_info.Sex;
        country = 'Cuba';
        eeg_device = 'Medicid4';
        
        [data_struct, error_msg] = data_gatherer(data, SAMPLING_FREQ, cnames, data_code, reference, age, sex, country, eeg_device);
        
        save(fullfile(output_path, strcat(subID,'.mat')),'data_struct','error_msg');
    end
end

disp("-->> Process finished.");
