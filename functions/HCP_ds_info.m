
clc;
close all;
clear all;
disp(strcat("Starting process."));
[num,txt,raw] = xlsread('E:\Data\Conectome\unrestricted_yingwang_10_23_2020_6_23_55.csv',1);

Ids = raw([2:end],1);
Ages = raw([2:end],5);
Genders = raw([2:end],4);
Realese = raw([2:end],2);
p_general_info = struct([]);
count = 1;
for i=1:length(Ids)
    subId = Ids{i};
    disp(strcat("Processing subject: ", num2str(subId)));   
    if(Realese(i) == "S1200")
        p_general_info(count).SubID = subId;
        p_general_info(count).Age = Ages{i};
        p_general_info(count).Sex = Genders{i};
        count = count + 1;
    end    
end
disp(strcat("Saving file"));
save('HCP_participants_info.mat','p_general_info');

disp(strcat("Process finished."));