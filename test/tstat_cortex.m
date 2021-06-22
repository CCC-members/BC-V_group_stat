function tstat_cortex(orig_t,stats_max_abs_t,Sc)
load('mycolormap_brain_basic_conn');
smoothValue          = 0.66;
SurfSmoothIterations = 10;
SulciMap             = Sc.SulciMap;
Faces                = Sc.Faces;
Vertices             = tess_smooth(Sc.Vertices, smoothValue, SurfSmoothIterations, Sc.VertConn, 1);
th                   = stats_max_abs_t.th;
orig_t               = reshape(orig_t,8002,5);
frequencies          = [0.1 4; 4 7; 7 14; 14 31; 32 50];
bands                = {'delta','theta','alpha','beta','gamma'};
figure
for i = 1:length(bands)
    sources_iv = abs(orig_t(:,i));
    sources_iv(sources_iv < th) = 0;
    sources_iv = sum(sources_iv,2);
    sources_iv(sources_iv > 0) = 1;
    subplot(1,length(bands),i);
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',...
        sources_iv,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    set(gca,'xcolor','k','ycolor','k','zcolor','k');
%     patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+...
%         log(1+sources_iv),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
%     set(gca,'xcolor','k','ycolor','k','zcolor','k');
    az = 90; el = 270;
    view(az,el);
%     colormap(gca,cmap);
    title(['cortex-tstat ',bands{i}]);
end
end