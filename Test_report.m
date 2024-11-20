%% Make a report

disp('-->> Starting test report.');

addpath('make_report');
% Loading color map if it is needed
load('mycolormap.mat');

output_path = pwd;
report_name = 'Example_report';

% % remove the hitory of reports
% f_report('Clean');


% Creating a report
f_report('New');
% Add a title to the report
f_report('Header','Surface plot','MathWorks Help Center');
% Add a title to the report
f_report('Title','Example report');
% Add a topic to the report
f_report('Index','Syntax');
% Add a info to the report
f_report('Info','surf(X,Y,Z)'); % a line information
% Add multielements info to the report
f_report('Info',{'surf(X,Y,Z,C)','surf(Z)','surf(Z,C)','surf(ax,___)','surf(___,Name,Value)','s = surf(___)'}); % multiline information cell array
% Add sub-topics to the report
f_report('Sub-Index','Sub index #1');
f_report('Sub-Index','Sub index #2');
% Add a line info to the report
f_report('Info','Some information');

% Add a figure to the report
fig = figure;
[X,Y,Z] = peaks(30);
surfc(X,Y,Z);
colormap hsv;
axis([-3 3 -3 3 -10 5]);
title('Surf fig');
description = strcat("surf(X,Y,Z) creates a three-dimensional surface plot, which is a three-dimensional surface that has solid edge colors and solid face colors.",...
                    "The function plots the values in matrix Z as heights above a grid in the x-y plane defined by X and Y.",...
                    "The color of the surface varies according to the heights specified by Z.");                   
f_report('Snapshot', fig, 'Some text in header of the picture', description , [200,200,875,550]);
close(fig)

% Add a description text to the report
description = strcat("Specify the colors for a surface plot by including a fourth matrix input, CO.",...
    " The surface plot uses Z for height and CO for color.",...
    " Specify the colors using truecolor, which uses triplets of numbers to stand for all possible colors.",...
    " When you use truecolor, if Z is m-by-n, then CO is m-by-n-by-3.",...
    " The first page of the array indicates the red component for each color,",...
    " the second page indicates the green component, and the third page indicates the blue component.");
title_b = "Color specifications";
f_report('Block', title_b,description);


% Add a topic to the report
f_report('Index','Merger figures');
% Figure 1
x = linspace(0,3*pi,200);
y = cos(x) + rand(1,200);  
fig_1 = figure('Color','w','Name',"Fig 1",'NumberTitle','off');
scatter(x,y)
title('Figure 1');

% Figure 2
x = linspace(0,3*pi,200);
y = cos(x) + rand(1,200);
sz = 25;
c = linspace(1,10,length(x));
fig_2 = figure('Color','w','Name',"Fig 2",'NumberTitle','off');
scatter(x,y,sz,c,'filled');
title('Figure 2');

% Merging figures
figures = {fig_1,fig_2};
fig_name        = strcat("Merging figures");
fig_title       = 'Merging figures';
fig_out         = merge_figures(fig_name, fig_title, figures, 'cmap', cmap, 'width', 875, 'height', 250,...
    'rows', 1, 'cols', 2, 'axis_on', {'on','off'}, 'colorbars', {'off','on'}, ...
    'view_orient',{[],[]});

% Adding figure to the report
f_report('Snapshot', fig_out, fig_name, [] , [200,200,875,250]);
close(fig_1,fig_2,fig_out);


% Add a table to the report
colheads = {'Color Name', 'Short Name',	'RGB Triplet', 'Hexadecimal Color Code'};
description = "Cuban Human Brain Mapping information text ";
f_report('Info','Alternatively, you can specify some common colors by name. This table lists the named color options, the equivalent RGB triplets, and hexadecimal color codes.');
table = struct;
table(1).Color_Name    = "red";
table(1).Short_Name    = "r";
table(1).RGB_Triplet   = "[1 0 0]";
table(1).Hexadecimal   = "#FF0000";

table(2).Color_Name    = "green";
table(2).Short_Name    = "g";
table(2).RGB_Triplet   = "[0 1 0]";
table(2).Hexadecimal   = "#00FF00";

table(3).Color_Name    = "blue";
table(3).Short_Name    = "b";
table(3).RGB_Triplet   = "[0 0 1]";
table(3).Hexadecimal   = "#0000FF";

table(4).Color_Name    = "cyan";
table(4).Short_Name    = "c";
table(4).RGB_Triplet   = "[0 1 1]";
table(4).Hexadecimal   = "#00FFFF";

table(5).Color_Name    = "magenta";
table(5).Short_Name    = "m";
table(5).RGB_Triplet   = "[1 0 1]";
table(5).Hexadecimal   = "#FF00FF";

table(6).Color_Name    = "yellow";
table(6).Short_Name    = "y";
table(6).RGB_Triplet   = "[1 1 0]";
table(6).Hexadecimal   = "#FFFF00";

table(7).Color_Name    = "black";
table(7).Short_Name    = "k";
table(7).RGB_Triplet   = "[0 0 0]";
table(7).Hexadecimal   = "#000000";

table(8).Color_Name    = "white";
table(8).Short_Name    = "w";
table(8).RGB_Triplet   = "[1 1 1]";
table(8).Hexadecimal   = "#FFFFFF";

f_report('Table', table, 'Test table', colheads, [], description);

% Add the references to the report
references = {'https://www.mathworks.com/help/matlab/ref/surf.html',...
    'https://www.mathworks.com/help/matlab/visualize/representing-a-matrix-as-a-surface.html',...
    'https://www.mathworks.com/help/matlab'};
f_report('Ref',references);

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
FileFormat = 'html';
f_report('Export',output_path, report_name, FileFormat);

disp('-->> Process testing report finished.');

    
