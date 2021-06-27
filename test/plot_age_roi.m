function fig_scattergram = plot_age_roi(data_g1,age_g1,data_g2,age_g2,data_g3,age_g3,Sc)
Scouts                = Sc.Atlas(Sc.iAtlas).Scouts;
bands                 = {'delta','theta','alpha','beta','gamma'};
data_roi_g1           = zeros(length(Scouts),size(data_g1,3));
data_roi_g2           = zeros(length(Scouts),size(data_g2,3));
data_roi_g3           = zeros(length(Scouts),size(data_g3,3));
X_g1                  = [ones(length(age_g1),1) age_g1];
X_g2                  = [ones(length(age_g2),1) age_g2];
X_g3                  = [ones(length(age_g3),1) age_g3];
min_age               = min([min(age_g1) min(age_g2) min(age_g3)]);
max_age               = max([max(age_g1) max(age_g2) max(age_g3)]);
span_age              = min_age:1:max_age;
X                     = [ones(length(span_age),1) span_age'];
fig_scattergram       = cell(length(bands),1);
colors = {'r','b','y'};
for band = 1:length(bands)
    % extracting roi and band data median for every subject
    for roi = 1:length(Scouts)
        data_roi_g1(roi,:)            = squeeze(median(data_g1(Scouts(roi).Vertices,band,:),1));
        data_roi_g2(roi,:)            = squeeze(median(data_g2(Scouts(roi).Vertices,band,:),1));
        data_roi_g3(roi,:)            = squeeze(median(data_g3(Scouts(roi).Vertices,band,:),1));
    end
    % sorting roi and band data by ensemble median
    data_roi_g1_median                = median(data_roi_g1,2);
    data_roi_g2_median                = median(data_roi_g2,2);
    data_roi_g3_median                = median(data_roi_g3,2);
    [val,id_data_roi_g1]              = sort(data_roi_g1_median);
    [val,id_data_roi_g2]              = sort(data_roi_g2_median);
    [val,id_data_roi_g3]              = sort(data_roi_g3_median);
    data_roi_g1                       = data_roi_g1(id_data_roi_g1,:);
    data_roi_g2                       = data_roi_g2(id_data_roi_g2,:);
    data_roi_g3                       = data_roi_g3(id_data_roi_g3,:);
    
    for roi = 1:length(Scouts)
        % age line g1
        B_g1(:,roi)                   = X_g1\(squeeze(data_roi_g1(roi,:))');
        Y_g1(roi,:)                   = squeeze(B_g1(1,roi))*X(:,1) + squeeze(B_g1(2,roi))*X(:,2);
        % age line g2
        B_g2(:,roi)                   = X_g2\(squeeze(data_roi_g2(roi,:))');
        Y_g2(roi,:)                   = squeeze(B_g2(1,roi))*X(:,1) + squeeze(B_g2(2,roi))*X(:,2);
        % age line g3
        B_g3(:,roi)                   = X_g3\(squeeze(data_roi_g3(roi,:))');
        Y_g3(roi,:)                   = squeeze(B_g3(1,roi))*X(:,1) + squeeze(B_g3(2,roi))*X(:,2);
    end
    % ploting age line and scatterd data
    %     fig                               = figure;
    %     for roi = 1:length(Scouts)
    %         scatter(age_g1,squeeze(data_roi_g1(roi,:)),'MarkerEdgeColor',colors{1},'MarkerFaceColor',colors{1});
    %         hold on
    %         scatter(age_g2,squeeze(data_roi_g2(roi,:)),'MarkerEdgeColor',colors{2},'MarkerFaceColor',colors{2});
    %         hold on
    %         scatter(age_g3,squeeze(data_roi_g3(roi,:)),'MarkerEdgeColor',colors{3},'MarkerFaceColor',colors{3});
    %         hold on
    %         plot(squeeze(X(:,2)),squeeze(Y_g1(roi,:)),'Color',colors{1});
    %     end
    fig                               = figure;
    for roi = 1:length(Scouts)
        plot(squeeze(X(:,2)),squeeze(Y_g1(roi,:)),'Color',colors{1});
        hold on
        plot(squeeze(X(:,2)),squeeze(Y_g2(roi,:)),'Color',colors{2});
        hold on
        plot(squeeze(X(:,2)),squeeze(Y_g3(roi,:)),'Color',colors{3});
        hold on
    end
    xlabel('age');
    ylabel('roi-act');
    title(['age-scattergram ',bands{band}]);
    fig_scattergram{band}             = fig;
end