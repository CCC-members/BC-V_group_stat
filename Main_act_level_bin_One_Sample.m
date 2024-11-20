%% Get BC-VARETA Outputs
clc;
clear all;
close all;

addpath('external');
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
output_path  = 'E:\CCLAB\Usama Riaz - BTOP\CHBM_activation\Pedrito selection\Data 50Hz';
if(~isfolder(output_path))
    mkdir(output_path);
end
load(properties.general_params.colormap);

%Getting subject surface
surf        = load(fullfile('FSAve_cortex_8k.mat'));
Sc          = surf;
save(fullfile(output_path,'FSAve_cortex.mat'),'-struct','surf');

disp("-->> Starting process");
disp("------------------>> Processing CHBM dataset <<-----------------");
disp("----------------------------------------------------------------");
disp("-->> Finding completed files");

% Creating a report
report_name = 'CHBM_dataset_58Ch_50Hz_qc';
f_report('New');
% Add a title to the report
f_report('Header','Surface plot','CHBM dataset cleanning data');


% Add sub-topics to the report
f_report('Sub-Index','Process description');

% Add a info to the report
f_report('Info','Transformations applied to the data'); % a line information
% Add multielements info to the report
line_1 = 'Filtering the data at 0Hz and 50Hz.';
line_2 = 'Selecting 58 common Channels.';
line_3 = 'Selecting good segments from marks';
line_4 = 'Apply clean_rawdata() to reject bad channels and correct continuous data using Artifact Subspace Reconstruction (ASR).';
line_5 = 'Interpolate all the removed channels.';
line_6 = 'plot power spectral in sensors and sources.';
f_report('Info',{line_1,line_2,line_3,line_4,line_5,line_6}); % multiline information cell array


%%
%%  Group 1
%%
% Checking firt subject for create the tensors
subjects_g1 = dir(fullfile(root_path_g1,'**','BC_V_info.mat'));
disp("----------------------------------------------------------------");
good_cases              = dir("Z:\data3_260T\data\CCLAB_DATASETS\CHBM\CHBM_Pedrito\CNEURO_datos\EEG_name_corrected");
good_cases(ismember({good_cases.name},{'..','.'})) = [];
info_g1                 = load('CHBM_info_all');
subject                 = subjects_g1(1);
load(fullfile(subject.folder,subject.name));
activ_level             = BC_V_info.activation_level;
activ_file              = fullfile(subject.folder,activ_level(1).Ref_path,activ_level(1).Name);
load(activ_file,"J_FSAve");
% activ3D              = zeros(size(J_FSAve,1),length(activ_level),length(subjects_g1));
% activ2D              = zeros(size(J_FSAve,1),length(activ_level));
activ3D              = zeros(size(J_FSAve,1),100,length(subjects_g1));
activ2D              = zeros(size(J_FSAve,1),100);
count_g = 1;
for i=1:length(subjects_g1)
    subject                 = subjects_g1(i);
    load(fullfile(subject.folder,subject.name));
    subID                   = BC_V_info.subjectID;
    %     if(find(ismember({good_cases.name},strcat(subID,'.mat')),1))
    disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
    activ_level                    = BC_V_info.activation_level;
    data_info = info_g1.data_info(contains({info_g1.data_info.SubID},subID));
    if(~isempty(data_info))
        group_info(count_g)           = data_info;
        for j=1:length(activ_level)
            activ_file = fullfile(subject.folder,activ_level(j).Ref_path,activ_level(j).Name);
            load(activ_file,"J_FSAve");
            activ2D(:,j) = J_FSAve;
        end
        activ2D(:,101:end) = [];
        activ3D(:,:,count_g) = activ2D;
        %             PSD = load(fullfile(subject.folder,'Generals','Funtional','Data_spectrum.mat'),'PSD');
        f_report('Title','Sensor and activation results');
        sens_fig = openfig(fullfile(subject.folder,'Sensor_level','alpha','Power Spectral Density - alpha_7Hz-14Hz.fig'));
        title('Sensor Power Spectral');
        
        source_fig = figure;        
        activ2D_perm = permute(activ2D, [2 1]);
        
        plot(0.5:0.5:50,10*log10(abs(activ2D_perm)));
        set(gca,'Color','w','XColor','k','YColor','k');
        ylabel('Source PSD(dB)','Color','k');
        xlabel('Freq. (Hz)','Color','k');
        title('Source Power Spectral');
        
        figures = {sens_fig,source_fig};
        fig_name        = strcat("Subject-",subID);
        fig_title       = 'BC-VARETA Sensor and Activation Power Spectral';
        fig_out         = merge_figures(fig_name, fig_title, figures,'cmap',cmap,'width',875,'height',500,...
            'rows', 1, 'cols', 2,'axis_on', {'on','on'}, 'view_orient',{[],[]}, 'colorbars',{'off','off'});
        f_report('Snapshot', fig_out, fig_name, [] , [200,200,875,500]);
        close(sens_fig, source_fig, fig_out);
        
        count_g = count_g + 1;
    end
%     end
end
% activ3D(:,:,count_g:end) = [];
% group_info(count_g:end) = [];

% save(fullfile(output_path,'FSAve_activ3D.mat'),'activ3D','-v7.3','-nocompression');
% save(fullfile(output_path,'group_info.mat'),'group_info');
%%
%% Group comparison
%%
%% remove subject scale
% activ_scaled               = log(activ3D);
% activ_scaled               = activ_scaled - mean(activ_scaled,[1 2]);

% save(fullfile(output_path,'FSAve_activ_scaled_log_&_mean.mat'),'activ_scaled','-v7.3','-nocompression');

% Add the footer info to the report
footer_title = 'Organization';
text = 'All rights reserved';
copyright = '@copy CC-Lab';
contact = 'cc-lab@neuroinformatics-collaboratory.org';
references = {'https://github.com/CCC-members', 'https://www.neuroinformatics-collaboratory.org/'};

f_report('Footer', footer_title, text, 'ref', references, 'copyright', copyright, 'contactus', contact);
disp('-->> Saving report.');
% Export the report
disp('-->> Exporting report.');
% report_name = 'CHBM_by_events';
FileFormat = 'html';
f_report('Export',output_path, report_name, FileFormat);

disp("-->> Process finished.");

