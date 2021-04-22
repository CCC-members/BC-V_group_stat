%% Get BC-VARETA Outputs
clc;
clear all;
close all;

addpath('external');
addpath('functions');
addpath('templates');
addpath('make_reports');
disp("-->> Starting process");
root_path = "E:\Data\Conectome\BC-V_Output";

subjects = dir(fullfile(root_path,'**','BC_V_info.mat'));

for i=1:length(subjects)
    subject = subjects(i);
    load(fullfile(subject.folder,subject.name));
    subID = BC_V_info.subjectID;
    sensor_level = BC_V_info.sensor_level;
    activ_level = BC_V_info.activation_level;
    
end





disp("-->> Process finished");