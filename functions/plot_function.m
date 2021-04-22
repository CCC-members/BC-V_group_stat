function  plot_function(Faces,Vertices,JnormBandMeanAlpha,cmap_a)

 for f=1:70        
        JnormBandMeanFig = figure;
        patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',log(JnormBandMeanAlpha(:,1,f)),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
        set(gca,'xcolor','k','ycolor','k','zcolor','k');
        az = 0; el = 0;
        view(az,el);
        c = hot;
        colormap(cmap_a);
        title(strcat('J Norm Band Mean Alpha_subject_',num2str(f)),'Color','k','FontSize',16);
        disp(strcat('bin_',num2str(f)));
        saveas(JnormBandMeanFig,fullfile('alpha_figures',strcat('Alpha_subject_',num2str(f))));
        close(JnormBandMeanFig);
    end
end

