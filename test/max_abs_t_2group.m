function [stats_max_abs_t,orig_max_abs_t,orig_t] = max_abs_t_2group(data1,data2,nperm,psignif)
% MAX_ABAST_DIF_TEST permuation test of difference between two multivariate
%samples
%   X1, X2 are matrices with same number of variables (dcolumns p) and
%   possibly different number of inviduals n1 and n2

%% original test, MEG EEG groups separately
[orig_max_abs_t,orig_t] = my_ttest2(data1,data2);

%% test with permutations
[n1,~]        = size(data1);
[n2,~]        = size(data2);
X             = [data1;data2];
for iperm = 1:nperm
    permlist             = randperm(n1+n2);
    ind1                 = permlist(1:n1);
    ind2                 = permlist(n1+1:end);
    [max_abs_t(iperm),~] = my_ttest2(X(ind1,:),X(ind2,:));
end % for iperm

%% fit probability density function and comulative distribution 
max_abs_t              = max_abs_t';
stats_max_abs_t.val    = max_abs_t;
stats_max_abs_t.pdf    = fitdist(max_abs_t,'Kernel');
stats_max_abs_t.p_orig = 1 - cdf(stats_max_abs_t.pdf,orig_max_abs_t);
stats_max_abs_t.th     = icdf(stats_max_abs_t.pdf,1-psignif);
end