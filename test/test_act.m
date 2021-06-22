clear all
% close all
clc

%% prepare data
data_path    = 'BC-V_Activation_final\';
% method       = 'eLORETA';
method       = 'sSSBLpp';
[data]       = prepdata(data_path,method);

%% test original data
nperm   = 100;
psignif = 0.01; 
[stats_max_abs_t,orig_max_abs_t,orig_t] = max_abs_t_2group(data.data1,data.data2,nperm,psignif);
plotperm(stats_max_abs_t,orig_max_abs_t);
tstat_cortex(orig_t,stats_max_abs_t);

%% test regressed data
nperm   = 100;
psignif = 0.01; 
[stats_max_abs_t,orig_max_abs_t,orig_t] = max_abs_t_2group(data.data1,data.data2_regressed,nperm,psignif);
plotperm(stats_max_abs_t,orig_max_abs_t);
tstat_cortex(orig_t,stats_max_abs_t);
