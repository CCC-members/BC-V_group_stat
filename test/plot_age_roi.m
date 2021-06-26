function fig_scattergram = plot_age_roi(data_g1,age_g1,data_g2,age_g2,data_g3,age_g3,Sc)
Scouts                = Sc.Atlas(Sc.iAtlas).Scouts;
bands                 = {'delta','theta','alpha','beta','gamma'};
data_roi_g1           = zeros(length(Scouts),size(data_g1,3));
data_roi_g2           = zeros(length(Scouts),size(data_g2,3));
data_roi_g3           = zeros(length(Scouts),size(data_g3,3));
X1                    = ones(length(age_g1),1);
X2                    = age_g1;
X                     = [X1 X2];
fig_scattergram       = cell(length(bands),1);
for band = 1:length(bands)
    for roi = 1:length(Scouts)
        data_roi_g1(roi,:)            = squeeze(median(data_g1(Scouts(roi).Vertices,band,:),1));
    end
    data_roi_median                   = median(data_roi_g1,2);
    [val,id_data_roi]                 = sort(data_roi_median);
    data_roi_g1                       = data_roi_g1(id_data_roi,:);
    fig = figure;
    count_roi = 1;
    for roi = 1:length(Scouts)
        Y                             = squeeze(data_roi_g1(roi,:))';
        B(:,roi)                      = X\Y;
        Y                             = squeeze(B(1,roi))*X(:,1) + squeeze(B(2,roi))*X(:,2);
        % scatter and line for g1
        subplot(1,3,1);
        scatter(age_g1,squeeze(data_roi_g1(roi,:)));
        hold on    
        plot(age_g1,Y)
        % scatter and line for g2
        subplot(1,3,2);
        scatter(age_g1,squeeze(data_roi_g1(roi,:)));
        hold on
        plot(age_g1,Y)
        % scatter and line for g3
        subplot(1,3,3);
        scatter(age_g1,squeeze(data_roi_g1(roi,:)));
        hold on
        Y                             = squeeze(data_roi_g1(roi,:))';
        B(:,roi)                      = X\Y;
        Y                             = squeeze(B(1,roi))*X(:,1) + squeeze(B(2,roi))*X(:,2);
        plot(age_g1,Y)
        count_roi = count_roi + 1;
    end
    xlabel('age');
    ylabel('roi-act');
    title(['age-scattergram ',bands{band}]);
    fig_scattergram{band}             = fig;
end

