
%% Get J from BC-VARETA results

clear all;
close all;
clc;

% BCV_output_path = "/data3_260T/share_space/jcclab-users/Rigel/BC_VARETA_OutPut_8K/All_data_bin";
% BCV_input_path = "/data3_260T/share_space/jcclab-users/Rigel/BCV_input_data/Surface_8k";
% output_path = "/data3_260T/BCV/BC-V_Activation/";
% modality = 'MEG';

BCV_output_path = "/data3_260T/data/CCLAB_DATASETS/CHBM/CHBM_ARIOSKY/run/BC-VARETA_output/";
BCV_input_path = "/data3_260T/data/CCLAB_DATASETS/CHBM/CHBM_ARIOSKY/run/BC-VARETA_structure_FSAve";
output_path = "/data3_260T/share_space/jcclab-users/Ariosky/BC-V/BC-V_Activation_Corrected/";
data_path           = "/data3_260T/data/CCLAB_DATASETS/CHBM/CHBM_ARIOSKY/update_data/ds_bids_cbm_012720";
modality = 'EEG';
T = readtable('CCC_ID_mapping_sorted.csv');

[data, header, participants] = tsvread(fullfile(data_path,'participants.tsv'));

subjects = dir(BCV_output_path);
subjects(ismember( {subjects.name}, {'.', '..'})) = [];  %remove . and ..

bands = ["delta","theta","alpha","beta","gamma1"];
methods = ["sSSBLpp","eLORETA","LCMV"];
binds = [0.1 0.6 1.1 1.6 2.1 2.6 3.1 3.6 4 ...
    4.5 5 5.5 6 6.5 7 ...
    7.5 8 8.5 9 9.5 10 10.5 11 11.5 12 12.5 13 13.5 14 ...
    14.5 15 15.5 16 16.5 17 17.5 18 18.5 19 19.5 20 20.5 21 21.5 22 22.5 23 23.5 24 24.5 25 25.5 26 26.5 27 27.5 28 28.5 29 29.5 30 30.5 31 ...
    32 32.5 33 33.5 34 34.5 35 35.5 36 36.5 37 37.5 38 38.5 39 39.5 40 40.5 41 41.5 42 42.5 43 43.5 44 44.5 45 45.5 46 46.5 47 47.5 48 48.5 49 49.5 50];

load('FSAve_cortex_8k.mat');
load('mycolormap_brain_basic_conn.mat');

for i=1:length(methods)
    %     J3Dnorm         = zeros(8002,length(binds),70);
    %     J3Dnorm_sp      = zeros(8002,length(binds),70);
    %     J3D             = zeros(8002,length(binds),70);
    %     J3Dsp           = zeros(8002,length(binds),70);
    %     F3Dstat         = zeros(8002,length(binds),70);
    %
    %     J3Dnorm_fsa     = zeros(8002,length(binds),70);
    %     J3Dnorm_sp_fsa  = zeros(8002,length(binds),70);
    %     J3D_fsa         = zeros(8002,length(binds),70);
    %     J3Dsp_fsa       = zeros(8002,length(binds),70);
    %     F3Dstat_fsa     = zeros(8002,length(binds),70);
    
    J3Dnorm         = struct([]);
    J3Dnorm_sp      = struct([]);
    J3D             = struct([]);
    J3Dsp           = struct([]);
    F3Dstat         = struct([]);
    
    J3Dnorm_fsa     = struct([]);
    J3Dnorm_sp_fsa  = struct([]);
    J3D_fsa         = struct([]);
    J3Dsp_fsa       = struct([]);
    F3Dstat_fsa     = struct([]);
    
    method = methods(i);
    fprintf(1,strcat('-->> Getting activation for ',method,' method: %3d%%\n'),0);
    method_path_na = fullfile(output_path,'Native',modality,method);
    method_path_fsa = fullfile(output_path,'FSAverage',modality,method);
    mkdir(method_path_na);
    mkdir(method_path_fsa);
    check_bins = zeros(70,length(binds));
    for j=1:length(subjects)
        subject = subjects(j);
        J2Dnorm         = zeros(8002,length(binds));
        J2Dnorm_sp      = zeros(8002,length(binds));
        J2D             = zeros(8002,length(binds));
        J2Dsp           = zeros(8002,length(binds));
        F2Dstat         = zeros(8002,length(binds));
        
        J2Dnorm_fsa     = zeros(8002,length(binds));
        J2Dnorm_sp_fsa  = zeros(8002,length(binds));
        J2D_fsa         = zeros(8002,length(binds));
        J2Dsp_fsa       = zeros(8002,length(binds));
        F2Dstat_fsa     = zeros(8002,length(binds));
        
        load(fullfile(BCV_input_path,subject.name,'surf','surf.mat'));
        disp(strcat("-->> Processing subject: ", subject.name ));
        method_files = dir(fullfile(subject.folder,subject.name,'Activation_level/',method,'/','**','MEEG_source*'));
        
        for k=1:length(method_files)
            method_file = method_files(k);
            if(isequal(method,"LCMV"))
                load(fullfile(method_file.folder,method_file.name),'J','miu','scaleSvv','scaleKe','stat');
                s2j = miu;
            else
                load(fullfile(method_file.folder,method_file.name),'J','s2j','scaleSvv','scaleKe','stat');
            end
            name_parts = split(method_file.name,'_');
            band = name_parts(3);
            bin = split(name_parts(4),'Hz.mat');
            bin = str2double(bin{1});
            ind_bin = find(binds==bin);
            if(~isempty(ind_bin))
                check_bins(j,ind_bin) = 1;
                % nonsparse J
                s2j_1                       = s2j(:,1);
                s2j_2                       = s2j(:,2);
                J                           = ((s2j_1 + s2j_2)/2)*sqrt(scaleSvv(1)*scaleSvv(2))/(scaleKe(1)*scaleKe(2));
                Jnorm                       = log(1 + sqrt(J/max(J)));
                
                % sparse J
                stat_1                      = stat(:,1);
                indms_1                     = find(stat_1 > 1);
                stat_2                      = stat(:,2);
                indms_2                     = find(stat_2 > 1);
                indms                       = unique([indms_1;indms_2]);
                Jsp                         = zeros(8002,1);
                Jsp(indms)                  = ((s2j_1(indms) + s2j_2(indms))/2)*sqrt(scaleSvv(1)*scaleSvv(2))/(scaleKe(1)*scaleKe(2));
                Jnorm_sp                    = log(1 + sqrt(Jsp/max(Jsp)));
                % statistic
                Fstat                       = (stat_1 +stat_2)/2;
                
                
                % native space
                J2Dnorm(:,ind_bin)      = Jnorm;
                J2Dnorm_sp(:,ind_bin)   = Jnorm_sp;
                J2D(:,ind_bin)          = J;
                J2Dsp(:,ind_bin)        = Jsp;
                F2Dstat(:,ind_bin)      = Fstat;
                
                % ordering results by FSAve indices
                Jnorm_FSAve = zeros(length(Jnorm),1);
                Jnorm_sp_FSAve = zeros(length(Jnorm_sp),1);
                J_FSAve = zeros(length(J),1);
                Jsp_FSAve = zeros(length(Jsp),1);
                Fstat_FSAve = zeros(length(Fstat),1);
                for h=1:length(sub_to_FSAve)
                    indices = sub_to_FSAve(h,:);
                    Jnorm_FSAve(h) = (Jnorm(indices(1))+Jnorm(indices(2))+Jnorm(indices(2)))/3;
                    Jnorm_sp_FSAve(h) = (Jnorm_sp(indices(1))+Jnorm_sp(indices(2))+Jnorm_sp(indices(2)))/3;
                    J_FSAve(h) = (J(indices(1))+J(indices(2))+J(indices(2)))/3;
                    Jsp_FSAve(h) = (Jsp(indices(1))+Jsp(indices(2))+Jsp(indices(2)))/3;
                    Fstat_FSAve(h) = (Fstat(indices(1))+Fstat(indices(2))+Fstat(indices(2)))/3;
                end
                
                % FSAve space
                J2Dnorm_fsa(:,ind_bin)      = Jnorm_FSAve;
                J2Dnorm_sp_fsa(:,ind_bin)   = Jnorm_sp_FSAve;
                J2D_fsa(:,ind_bin)          = J_FSAve;
                J2Dsp_fsa(:,ind_bin)        = Jsp_FSAve;
                F2Dstat_fsa(:,ind_bin)      = Fstat_FSAve;
            end
        end
        
        sub     = replace(subject.name,'sub-','');
        index   = find(strcmp(T{:,1},sub),1);
        new     = cell2mat(T{index,2});
        newID   = strcat('sub-',new);
        
        [~,~,info]          = tsvread(fullfile(data_path,newID,strcat(newID,'_scans.tsv')));
        
        %Native space
        J3Dnorm(j).SubID    = newID;
        J3Dnorm(j).Age      = str2double(info{2,2});
        J3Dnorm(j).Sex      = participants{find(strcmp(participants(:,1),newID),1),2};
        J3Dnorm(j).J2Dnorm  = J2Dnorm;
        
        J3Dnorm_sp(j).SubID         = newID;
        J3Dnorm_sp(j).Age           = str2double(info{2,2});
        J3Dnorm_sp(j).Sex           = participants{find(strcmp(participants(:,1),newID),1),2};
        J3Dnorm_sp(j).J2Dnorm_sp    = J2Dnorm_sp;
        
        J3D(j).SubID    = newID;
        J3D(j).Age      = str2double(info{2,2});
        J3D(j).Sex      = participants{find(strcmp(participants(:,1),newID),1),2};
        J3D(j).J2D      = J2D;
        
        J3Dsp(j).SubID  = newID;
        J3Dsp(j).Age    = str2double(info{2,2});
        J3Dsp(j).Sex    = participants{find(strcmp(participants(:,1),newID),1),2};
        J3Dsp(j).J2Dsp  = J2Dsp;
        
        F3Dstat(j).SubID    = newID;
        F3Dstat(j).Age      = str2double(info{2,2});
        F3Dstat(j).Sex      = participants{find(strcmp(participants(:,1),newID),1),2};
        F3Dstat(j).F2Dstat  = F2Dstat;
        
        %FSAve space
        J3Dnorm_fsa(j).SubID        = newID;
        J3Dnorm_fsa(j).Age          = str2double(info{2,2});
        J3Dnorm_fsa(j).Sex          = participants{find(strcmp(participants(:,1),newID),1),2};
        J3Dnorm_fsa(j).J2Dnorm_fsa  = J2Dnorm_fsa;
        
        J3Dnorm_sp_fsa(j).SubID             = newID;
        J3Dnorm_sp_fsa(j).Age               = str2double(info{2,2});
        J3Dnorm_sp_fsa(j).Sex               = participants{find(strcmp(participants(:,1),newID),1),2};
        J3Dnorm_sp_fsa(j).J2Dnorm_sp_fsa    = J2Dnorm_sp_fsa;
        
        J3D_fsa(j).SubID    = newID;
        J3D_fsa(j).Age      = str2double(info{2,2});
        J3D_fsa(j).Sex      = participants{find(strcmp(participants(:,1),newID),1),2};
        J3D_fsa(j).J2D_fsa  = J2D_fsa;
        
        J3Dsp_fsa(j).SubID      = newID;
        J3Dsp_fsa(j).Age        = str2double(info{2,2});
        J3Dsp_fsa(j).Sex        = participants{find(strcmp(participants(:,1),newID),1),2};
        J3Dsp_fsa(j).J2Dsp_fsa  = J2Dsp_fsa;
        
        F3Dstat_fsa(j).SubID        = newID;
        F3Dstat_fsa(j).Age          = str2double(info{2,2});
        F3Dstat_fsa(j).Sex          = participants{find(strcmp(participants(:,1),newID),1),2};
        F3Dstat_fsa(j).F2Dstat_fsa  = F2Dstat_fsa;
        
        eeg_json = fullfile(data_path,newID,'eeg',strcat(newID,'_task-protmap_eeg.json'));
        if(isfile(eeg_json))
            eeg_description = jsondecode(fileread(eeg_json));
            
            % Native space
            J3Dnorm(j).SamplingFrequency    = eeg_description.SamplingFrequency;
            J3Dnorm(j).eeg_description      = eeg_description;
            
            J3Dnorm_sp(j).SamplingFrequency = eeg_description.SamplingFrequency;
            J3Dnorm_sp(j).eeg_description   = eeg_description;
            
            J3D(j).SamplingFrequency        = eeg_description.SamplingFrequency;
            J3D(j).eeg_description          = eeg_description;
            
            J3Dsp(j).SamplingFrequency      = eeg_description.SamplingFrequency;
            J3Dsp(j).eeg_description        = eeg_description;
            
            F3Dstat(j).SamplingFrequency    = eeg_description.SamplingFrequency;
            F3Dstat(j).eeg_description      = eeg_description;
            
            % FSAve space
            J3Dnorm_fsa(j).SamplingFrequency    = eeg_description.SamplingFrequency;
            J3Dnorm_fsa(j).eeg_description      = eeg_description;
            
            J3Dnorm_sp_fsa(j).SamplingFrequency = eeg_description.SamplingFrequency;
            J3Dnorm_sp_fsa(j).eeg_description   = eeg_description;
            
            J3D_fsa(j).SamplingFrequency        = eeg_description.SamplingFrequency;
            J3D_fsa(j).eeg_description          = eeg_description;
            
            J3Dsp_fsa(j).SamplingFrequency      = eeg_description.SamplingFrequency;
            J3Dsp_fsa(j).eeg_description        = eeg_description;
            
            F3Dstat_fsa(j).SamplingFrequency    = eeg_description.SamplingFrequency;
            F3Dstat_fsa(j).eeg_description      = eeg_description;
        end
    end
    disp('Saving subject files');
    
    % Native space
    save(fullfile(method_path_na,strcat('J3Dnorm.mat')),'J3Dnorm','-v7.3');
    save(fullfile(method_path_na,strcat('J3Dnorm_sp.mat')),'J3Dnorm_sp','-v7.3');
    save(fullfile(method_path_na,strcat('J3D.mat')),'J3D','-v7.3');
    save(fullfile(method_path_na,strcat('J3Dsp.mat')),'J3Dsp','-v7.3');
    save(fullfile(method_path_na,strcat('F3Dstat.mat')),'F3Dstat','-v7.3');
    
    % Compiting J norm Subjec Mean
    %    J3Dnorm_function(method_path_na,J3Dnorm,length(subjects));
    %    J3Dnorm_sp_function(method_path_na,J3Dnorm_sp,length(subjects));
    
    % FSAve space
    J3Dnorm     = J3Dnorm_fsa;
    J3Dnorm_sp  = J3Dnorm_sp_fsa;
    J3D         = J3D_fsa;
    J3Dsp       = J3Dsp_fsa;
    F3Dstat     = F3Dstat_fsa;
    
    save(fullfile(method_path_fsa,strcat('J3Dnorm.mat')),'J3Dnorm','-v7.3');
    save(fullfile(method_path_fsa,strcat('J3Dnorm_sp.mat')),'J3Dnorm_sp','-v7.3');
    save(fullfile(method_path_fsa,strcat('J3D.mat')),'J3D','-v7.3');
    save(fullfile(method_path_fsa,strcat('J3Dsp.mat')),'J3Dsp','-v7.3');
    save(fullfile(method_path_fsa,strcat('F3Dstat.mat')),'F3Dstat','-v7.3');
    
    % Compiting J norm Subjec Mean
    %    J3Dnorm_function(method_path_fsa,J3Dnorm,length(subjects));
    %    J3Dnorm_sp_function(method_path_fsa,J3Dnorm_sp,length(subjects));    
    
end
