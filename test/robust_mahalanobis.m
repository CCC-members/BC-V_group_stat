function D2 = robust_mahalanobis(ZI,ZJ)
[sig,mu,D2] = robustcov([ZI; ZJ]); 
end