clc;
clear all;
close all;

disp("-->> Starting process...");
%  root_path = '/data3_260T/data/CCLAB_DATASETS/CHBM/CHBM_ARIOSKY/update_data/non-brain';
% root_path = '/data3_260T/data/CCLAB_DATASETS/CHBM/CHBM_ARIOSKY/update_data/freesurfer';
root_path = '/data3_260T/data/CCLAB_DATASETS/CHBM/CHBM_ARIOSKY/update_data/ciftify';
disp("-->> Locading Subjects ID to Match");
T = readtable('CCC_ID_mapping_sorted.csv');

for i = 1:height(T)
    old = cell2mat( T{i,1});
    new = cell2mat(T{i,2});
    disp(strcat("-->> Iter: ",num2str(i),"- Changing ID: ",old," for ID: " ,new)); 
    subject = fullfile(root_path,['sub-',old]);
    if(isfolder(subject))
        files = dir(fullfile(root_path,'**',['*',old,'*']));
        for j=1:length(files)
            file = files(j);
            if(~file.isdir)
                new_name = strrep(file.name,old,new);
                old_file = fullfile(file.folder,file.name);
                new_file = fullfile(file.folder,new_name);
                command = strcat("mv ", old_file , " ", new_file);
                [status,cmdout] = system(command);
            end
        end
        new_folder = fullfile(root_path,['sub-',new]);
        command = strcat("mv ", subject , " ", new_folder);
        [status,cmdout] = system(command);
    end    
end
disp("-->> Process finished!");