function plotperm(stats_max_abs_t,orig_max_abs_t)
xrange  = linspace(0,log(1+orig_max_abs_t));
pvalues = pdf(stats_max_abs_t.pdf,exp(xrange)-1);
pvalue  = pdf(stats_max_abs_t.pdf,orig_max_abs_t);
figure
semilogx(exp(xrange)-1,pvalues,'.',orig_max_abs_t,pvalue,'*');
title(['p = ',num2str(stats_max_abs_t.p_orig)])
% keyboard
end