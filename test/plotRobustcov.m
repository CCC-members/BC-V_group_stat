function [fig_3D_robustcov, fig_2D_distance] = plotRobustcov(mappedX,dfmcd,g,Outfmcd)

fig_3D_robustcov = figure;
title('t-sne')
switch size(mappedX,2)
    case 2
        scatter(mappedX(g{1,1},1),mappedX(g{1,1},2),10,'MarkerEdgeColor','g','MarkerFaceColor','g');
        hold on
        scatter(mappedX(g{1,2},1),mappedX(g{1,2},2),10,'MarkerEdgeColor','b','MarkerFaceColor','b');
        hold on
        scatter(mappedX(g{1,3},1),mappedX(g{1,3},2),10,'MarkerEdgeColor','m','MarkerFaceColor','m');
        legend(g{2,1},g{2,2},g{2,3});
    otherwise
        scatter3(mappedX(g{1,1},1),mappedX(g{1,1},2),mappedX(g{1,1},3),10,'MarkerEdgeColor','g','MarkerFaceColor','g');
        hold on
        scatter3(mappedX(g{1,2},1),mappedX(g{1,2},2),mappedX(g{1,2},3),10,'MarkerEdgeColor','b','MarkerFaceColor','b');
        hold on
        scatter3(mappedX(g{1,3},1),mappedX(g{1,3},2),mappedX(g{1,3},3),10,'MarkerEdgeColor','m','MarkerFaceColor','m'); 
        legend(g{2,1},g{2,2},g{2,3});
end

%%
fig_2D_distance = figure;
title('DD Plot, FMCD method');
d_classical = pdist2(mappedX, mean(mappedX),'mahal');
p = size(mappedX,2);
chi2quantile = sqrt(chi2inv(0.975,p));
plot(d_classical(g{1,1}), dfmcd(g{1,1}), 'o', 'color', 'g');
hold on
plot(d_classical(g{1,2}), dfmcd(g{1,2}), 'o', 'color', 'b');
hold on
plot(d_classical(g{1,3}), dfmcd(g{1,3}), 'o', 'color', 'm');
line([chi2quantile, chi2quantile], [0, max(dfmcd)], 'color', 'r');
line([min(d_classical), max(d_classical)], [chi2quantile, chi2quantile], 'color', 'r');
hold on
plot(d_classical(Outfmcd), dfmcd(Outfmcd), 'r+');
legend(g{2,1},g{2,2},g{2,3},'limits');
xlabel('Mahalanobis Distance');
ylabel('Robust Distance');
end