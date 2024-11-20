%% Get BC-VARETA Outputs
clc;
clear all;
% close all;

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

root_path = 'E:/Data/CHBM/EEG_Preprocessing/Reports';
output_path  = 'E:/Data/CHBM/EEG_Preprocessing';
if(~isfolder(output_path))
    mkdir(output_path);
end
load(properties.general_params.colormap);

disp("-->> Starting process");
disp("------------------>> Processing CHBM normative dataset <<-----------------");
disp("----------------------------------------------------------------");
disp("-->> Finding completed files");


% Creating a report
report_name = 'CHBM_EEGLAB Preprocessing';
f_report('New');
% Add a title to the report
f_report('Header','Surface plot','Power Spectral Density before and after EEGLAB Preprocessing');


% Add sub-topics to the report
f_report('Sub-Index','Process description');

% Add a info to the report
f_report('Info','Transformations applied to the data'); % a line information
% Add multielements info to the report
line_1 = 'Filtering the data at 0Hz and 50Hz.';
line_2 = 'Import channel info.';
line_3 = 'Selecting good segments from marks';
line_4 = 'Selecting opened eyes events';
line_5 = 'Apply clean_rawdata() to reject bad channels and correct continuous data using Artifact Subspace Reconstruction (ASR).';
line_6 = 'Remove bad channels.';
line_7 = 'Decompose ICA (icatype - runica)';
line_8 = 'Label independent components using ICLabel ';
line_9 = 'Flag components as atifacts';
line_10 = 'The Categories are (in order) Brain, Muscle, Eye, Heart, Line Noise, Channel Noise, Other.';
line_11 = '[0 0.75; 0.25 1; 0.25 1; 0.25 1; 0.25 1; 0.25 1; 0.25 1]';
f_report('Info',{line_1,line_2,line_3,line_4,line_5,line_6,line_7,line_8,line_9,line_10,line_11}); % multiline information cell array



%%
%%  Group 1
%%
% Checking firt subject for create the tensors
subjects = dir(fullfile(root_path));
subjects(ismember({subjects.name},{'.','..'})) = [];

% Add topics to the report
f_report('Index','Subjects report');
for i=1:length(subjects)
    try
        subject                 = subjects(i);
        subID                   = subject.name;
        disp(strcat("-->> Processing subject: ",subID," Iter: ", num2str(i)));
        count = 1;
        
        % Add a title to the report
        f_report('Title','Power Spectral Density - EEGLAB Preprocessing');
        
        % Power Spectral before
        fig_1 = openfig(fullfile(subject.folder,subID,'Op_eyes','Cross-spectrum.fig'));
        title('Power Spectral Raw EEG');
        fig_name        = strcat("Subject-",subID, " - Before");
        f_report('Snapshot', fig_1, fig_name, [] , [200,200,875,600]);
        % Power Spectral after
        fig_2 = openfig(fullfile(subject.folder,subID,'Op_eyes','Cross-spectrum_cleaned.fig'));
        title('Power Spectral EEG cleaned');
        
%         figures = {fig_1,fig_2};
        fig_name        = strcat("Subject-",subID, " - After");
%         fig_title       = 'EEGLAB Preprocessing';
%         fig_out         = merge_figures(fig_name, fig_title, figures, 'cmap', cmap, 'width', 875, 'height', 250,...
%             'rows', 1, 'cols', 2, 'axis_on', {'on','on'}, 'colorbars', {'off','off'}, ...
%             'view_orient',{[],[]});
        f_report('Snapshot', fig_2, fig_name, [] , [200,200,875,600]);
        close(fig_1,fig_2);
    catch
        continue;
    end    
end

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


