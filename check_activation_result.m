%% test result

% root_path = "Z:\data3_260T\data\CCLAB_DATASETS\Covid\Corrected\BC-V_Output\Covid";
root_path = "Z:\data3_260T\data\CCLAB_DATASETS\CHBM\CHBM_ARIOSKY\Octobre-2021\BC_V_Output_sSSBL_fixed";

subjects           =  dir(root_path);
subjects(ismember( {subjects.name}, {'.', '..','Closed_eyes','Open_eyes'})) = [];  %remove . and ..
incompled = [];
for i=1:length(subjects)
    subject = subjects(i);
    disp(strcat("Processing subject: ",subject.name));
%     file_to_check = fullfile(subject.folder,subject.name,'Connectivity_level\HIGGS\gamma2\MEEG_source_gamma2_65Hz_90Hz.mat');
%     file_to_check = fullfile(subject.folder,subject.name,'Sensor_level\gamma1\Sensor_level_gamma1_50Hz.mat');
      file_to_check = fullfile(subject.folder,subject.name,'Activation_level/sSSBLpp/gamma1/MEEG_source_gamma1_50Hz.mat');
    if(~isfile(file_to_check))
        incompled = [incompled; subject.name];
%         rmdir(fullfile(subject.folder,subject.name),'s');
    end
end

disp("Process finished.");