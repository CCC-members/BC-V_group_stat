function plot_differ_by_roi(data1,data2,Sc)
Scouts = Sc.Atlas(Sc.iAtlas).Scouts;
bands                = {'delta','theta','alpha','beta','gamma'};
for band = 1:size(data1,2)
    counter = 1;
    sub_roi_data1 = zeros(size(data1,3),length(Scouts));
    sub_roi_data2 = zeros(size(data2,3),length(Scouts));
    figure;    
    for roi = 1:length(Scouts)
        data1_roi = squeeze(max(data1(Scouts(roi).Vertices,band,:)));
        data2_roi = squeeze(max(data2(Scouts(roi).Vertices,band,:)));
        scatter(counter*ones(length(data1_roi),1),data1_roi,'r');
        hold on
        scatter(counter*ones(length(data2_roi),1),data2_roi,'b');
        counter = counter + 1;
        
        sub_roi_data1(:,roi) = data1_roi;
        sub_roi_data2(:,roi) = data2_roi;
    end
    title(strcat("Group differences band: " ,bands{band}));
    xlabel('Roi');
    ylabel('Power amplitude');
    set(gca,'xcolor','k','ycolor','k');
    legend('Controls','Pathols');
    
    figure;
    hold on;
    for sub=1:size(sub_roi_data2,1)
        try
            plot(sub_roi_data1(sub,:),'r');
        catch
        end
        hold on;
        plot(sub_roi_data2(sub,:),'b');
        hold on;
    end
    title(strcat("Group differences band: " ,bands{band}));
    xlabel('Roi');
    ylabel('Power amplitude');
    set(gca,'xcolor','k','ycolor','k');
    legend('Controls','Pathols');
end
end

