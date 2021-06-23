function avrg_cortex(activ3D,Sc,group)
load('mycolormap_brain_basic_conn');
smoothValue          = 0.66;
SurfSmoothIterations = 10;
SulciMap             = Sc.SulciMap;
Faces                = Sc.Faces;
Vertices             = tess_smooth(Sc.Vertices, smoothValue, SurfSmoothIterations, Sc.VertConn, 1);
activ3D              = squeeze(mean(activ3D,3));
bands                = {'delta','theta','alpha','beta','gamma'};
figure
for i = 1:length(bands)
    sources_iv = abs(activ3D(:,i));
    subplot(1,length(bands),i);
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',...
        sources_iv,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    set(gca,'xcolor','k','ycolor','k','zcolor','k');
%     patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06+...
%         log(1+sources_iv),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
%     set(gca,'xcolor','k','ycolor','k','zcolor','k');
    az = 90; el = 270;
    view(az,el);
    colormap(gca,cmap);
    title(['cortex-tstat-',group,' ',bands{i}]);
end
figure; plot(activ3D(:));
title(['data-periodicity-',group]);
end