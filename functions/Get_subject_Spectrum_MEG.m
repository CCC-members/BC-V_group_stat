
%% Get J from BC-VARETA results

clear all;
close all;
clc;
%
addpath('/home/cmi2/brainstorm3/');
BCV_output_path = "/data3_260T/data/CCLAB_DATASETS/HCP-GUSHI-2019/Run_2/BC-V_Output/Sensor_level";
BCV_input_path = "/data3_260T/data/CCLAB_DATASETS/HCP-GUSHI-2019/Run_1/BCV_input_data/Surface_8k";
output_path = "/data3_260T/share_space/jcclab-users/Ariosky/BCV/BC-V_Spectrum_Corrected";
data_path = "/data3_260T/data/CCLAB_DATASETS/HCP-GUSHI-2019/Selected_data/";
modality = 'MEG';


% BCV_output_path = "/data3_260T/data/CCLAB_DATASETS/CHBM/CHBM_ARIOKSY/run/BC-VARETA_output";
% BCV_input_path = "/data3_260T/data/CCLAB_DATASETS/CHBM/CHBM_ARIOKSY/run/BC-VARETA_structure_FSAve";
% output_path = "/data3_260T/BCV/BC-V_Activation/";
% modality = 'EEG';

bands = ["delta","theta","alpha","beta","gamma1"];
methods = ["sSSBLpp","eLORETA","LCMV"];
binds = [0.1 0.6 1.1 1.6 2.1 2.6 3.1 3.6 4 ...
    4.5 5 5.5 6 6.5 7 ...
    7.5 8 8.5 9 9.5 10 10.5 11 11.5 12 12.5 13 13.5 14 ...
    14.5 15 15.5 16 16.5 17 17.5 18 18.5 19 19.5 20 20.5 21 21.5 22 22.5 23 23.5 24 24.5 25 25.5 26 26.5 27 27.5 28 28.5 29 29.5 30 30.5 31 ...
    32 32.5 33 33.5 34 34.5 35 35.5 36 36.5 37 37.5 38 38.5 39 39.5 40 40.5 41 41.5 42 42.5 43 43.5 44 44.5 45 45.5 46 46.5 47 47.5 48 48.5 49 49.5 50];

load('mycolormap_brain_basic_conn.mat');

load('HCP_participants_info.mat');
psd3D       = struct([]);

path_na     = fullfile(output_path,modality);
mkdir(path_na);
subjects    = dir(BCV_output_path);
subjects(ismember( {subjects.name}, {'.', '..'})) = [];  %remove . and ..
brainstorm reset
brainstorm nogui local
gui_brainstorm('DeleteProtocol','Empty_protocol');
gui_brainstorm('CreateProtocol','Empty_protocol',0,0);
% start new report

bst_report('Start','Power spectrum for HCP Dataset');

for i=1:length(subjects)
    subject = subjects(i);    
    load(fullfile(BCV_input_path,subject.name,'surf','surf.mat'));
    disp(strcat("-->> Processing subject: ", subject.name ));
    load(fullfile(subject.folder,subject.name,'Sensor_level','Sensor_level_data_spectrum.mat'));
    fig = openfig(fullfile(subject.folder,subject.name,'Sensor_level','alpha','Power Spectral Density - alpha_7Hz-14Hz.fig'));
    bst_report('Snapshot',fig,[],strcat('Power Sapectrum for subject: ',num2str(subject.name)),[200,200,750,475]);
    close(fig);
    for j=1:length(binds)
        psd(:,j)  = diag(Svv_channel(:,:,j));
    end
    psd3D(i).SubID  = subject.name;
    psd             = abs(psd);
    psd3D(i).psd    = psd;
    meg = load(fullfile(data_path,subject.name,'MEG','Restin','rmegpreproc',...
        strcat(subject.name,'_MEG_5-Restin_rmegpreproc.mat')),'data');
    psd3D(i).SamplingFrequency = meg.data.fsample;
    subs = [Participants_info.SubID]';
    info = Participants_info(find(ismember(subs,str2double(subject.name)),1));
    
    psd3D(i).Age = info.Age;
    psd3D(i).Sex = info.Sex;
    psd3D(i).Alpha_Peak = info.Alpha_Peak;
    psd3D(i).Beta = info.Beta_Peak;
    
    clear psd;
end

% Save and display report
ReportFile = bst_report('Save');

bst_report('Export', ReportFile, fullfile(path_na, 'Power spectrum HCP Dataset.html'));


brainstorm stop;

disp('Saving subject files');
save(fullfile(path_na,strcat('psd3D.mat')),'psd3D','-v7.3');


% Compiting J norm Subjec Mean
% J3Dnorm_function(method_path_fsa,J3Dnorm,sub_sample);
% J3Dnorm_sp_function(method_path_fsa,J3Dnorm_sp,sub_sample);

pre_psd = zeros(length(binds),length(subjects));
for i=1:length(psd3D)    
    psd_log     = log(psd3D(i).psd);
    psd_median  = median(psd_log,1); 
    pre_psd(:,i)  = psd_median';
end   
save(fullfile(path_na,strcat('prep_psd.mat')),'pre_psd','-v7.3');
plot(pre_psd,'Color','r');
close all;
