function [data_roi,data] = get_roi_data(data,Sc)
load('mycolormap_brain_basic_conn');
smoothValue           = 0.66;
SurfSmoothIterations  = 10;
SulciMap              = Sc.SulciMap;
Faces                 = Sc.Faces;
Vertices              = tess_smooth(Sc.Vertices, smoothValue, SurfSmoothIterations, Sc.VertConn, 1);
Scouts                = Sc.Atlas(Sc.iAtlas).Scouts;
bands                 = {'delta','theta','alpha','beta','gamma'};
data_roi              = zeros(length(Scouts),size(data,2),size(data,3));
for roi = 1:length(Scouts)
    data_roi(roi,:,:)              = sum(data(Scouts(roi).Vertices,:,:),1);
    data(Scouts(roi).Vertices,:,:) = repmat(data_roi(roi,:,:),length(Scouts(roi).Vertices),1,1);
end

% data_mean             = log(squeeze(mean(data,3)));
% for band = 1:length(bands)
%     figure
%     %     subplot(1,length(bands),band);
%     %     patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',...
%     %         data_diff(:,band),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
%     %     set(gca,'xcolor','k','ycolor','k','zcolor','k');
%     patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06 +...
%         data_mean(:,band),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
%     set(gca,'xcolor','k','ycolor','k','zcolor','k');
%     az = 90; el = 270;
%     view(az,el);
% %     colormap(gca,cmap);
%     title(['cortex-tstat ',bands{band}]);
% end

end