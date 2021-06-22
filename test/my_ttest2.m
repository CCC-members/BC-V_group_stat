function [max_abs_t,t] = my_ttest2(data1,data2)
[n1,~]    = size(data1);
[n2,~]    = size(data2);
m1        = mean(data1);
m2        = mean(data2);
s1        = std(data1);
s2        = std(data2);
t         = ((m1-m2)./sqrt(s1.^2/n1 + s2.^2/n2))';
max_abs_t = max(abs(t));
end
