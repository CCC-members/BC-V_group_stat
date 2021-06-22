function group_difference(data1,data2,Sc)
load('mycolormap_brain_basic_conn');
smoothValue          = 0.66;
SurfSmoothIterations = 10;
SulciMap             = Sc.SulciMap;
Faces                = Sc.Faces;
Vertices             = tess_smooth(Sc.Vertices, smoothValue, SurfSmoothIterations, Sc.VertConn, 1);
nperm                = 1000;
psignif              = 0.05;
nsubj1               = size(data1,3);
nsubj2               = size(data2,3);
Scouts               = Sc.Atlas(Sc.iAtlas).Scouts;
bands                = {'delta','theta','alpha','beta','gamma'};
data_diff            = zeros(size(data1,1),size(data1,2));
counter              = 0;
for band = 1:length(bands)
    for roi = 1:length(Scouts)
        data1_band_roi    = data1(Scouts(roi).Vertices,band,:);
        data2_band_roi    = data2(Scouts(roi).Vertices,band,:);
        nroi              = length(Scouts(roi).Vertices);
        nband             = length(band);
        data1_band_roi    = reshape(data1_band_roi,nroi*nband,nsubj1)';
        data2_band_roi    = reshape(data2_band_roi,nroi*nband,nsubj2)';
        [stats_max_abs_t_band_roi,orig_max_abs_t_band_roi,orig_t_band_roi] = max_abs_t_2group(data1_band_roi,data2_band_roi,nperm,psignif);
        counter           = counter + sum(find(abs(orig_t_band_roi) > stats_max_abs_t_band_roi.th));
        if ~isempty(find(abs(orig_t_band_roi) > stats_max_abs_t_band_roi.th))
            data_diff(Scouts(roi).Vertices,band) = abs(orig_t_band_roi);
        end
    end
end

for band = 1:length(bands)
    figure
%     subplot(1,length(bands),band);
%     patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',...
%         data_diff(:,band),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
%     set(gca,'xcolor','k','ycolor','k','zcolor','k');
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',SulciMap*0.06 + 0.06 +...
        data_diff(:,band),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    set(gca,'xcolor','k','ycolor','k','zcolor','k');
    az = 90; el = 270;
    view(az,el);
    colormap(gca,cmap);
    title(['cortex-tstat ',bands{band}]);
end


end