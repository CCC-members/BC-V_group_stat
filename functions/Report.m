%% Get Report for BC-VARETA Outputs
clc;
clear all;
close all;
load('mycolormap_brain_basic_conn.mat');
addpath('make_report');
disp("-->> Starting process");

surf        = load('Z:\data3_260T\data\CCLAB_DATASETS\Covid\Corrected\BC-V_Structure\Controls\CU COVID 003\surf\surf.mat');
Sc          = surf.Sc(surf.iCortex);
Vertices    = Sc.Vertices;
VertConn    = Sc.VertConn;
SulciMap    = Sc.SulciMap;
smoothValue = 0.66;
SurfSmoothI = 10;
Vertices    = tess_smooth(Vertices, smoothValue, SurfSmoothI,VertConn, 1);
Faces       = Sc.Faces;

disp("--------->> Processing Controls <<---------");
disp("-------------------------------------------------");
disp("-->> Finding completed files");
root_pathCtrl = "Z:\data3_260T\data\CCLAB_DATASETS\Covid\Corrected\BC-V_Output\Controls";
subjects = dir(fullfile(root_pathCtrl,'**','BC_V_info.mat'));
disp("-------------------------------------------------");

