
clc;
close all;
clear all;
disp(strcat("Starting process."));
dataset_dir = "/data3_260T/data/CCLAB_DATASETS/CHBM/CHBM_ARIOSKY/update_data/ds_bids_cbm_012720";
subjects = dir(fullfile(dataset_dir));

subjects(ismember( {subjects.name}, {'.', '..'})) = [];  %remove . and ..

[data, header, participants] = tsvread(fullfile(dataset_dir,'participants.tsv'));

p_general_info = struct([]);
count = 1;
for i=1:length(subjects)
    subject = subjects(i);
    if(subject.isdir)
        disp(strcat("Processing subject: ", subject.name))
        p_general_info(count).SubID = subject.name;
        if(isfile(fullfile(subject.folder,subject.name,strcat(subject.name,'_scans.tsv'))))
            [data, header, info] = tsvread(fullfile(subject.folder,subject.name,strcat(subject.name,'_scans.tsv')));
            p_general_info(count).Age = str2double(info{2,2});
            p_general_info(count).Sex = participants{find(strcmp(participants(:,1),subject.name),1),2};
            eeg_json = fullfile(subject.folder,subject.name,'eeg',strcat(subject.name,'_task-protmap_eeg.json'));
            if(isfile(eeg_json))
                eeg_description = jsondecode(fileread(eeg_json));
                p_general_info(count).SamplingFrequency = eeg_description.SamplingFrequency;
                p_general_info(count).EEG_Info = eeg_description;
            end
            count = count + 1;
        end
    end
end
disp(strcat("Saving file"));
save('CHBM_participants_info.mat','p_general_info');

disp(strcat("Process finished."));