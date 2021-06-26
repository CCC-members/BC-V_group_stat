function fig_scattergram = plot_age_roi(data,age,Sc)
Scouts                = Sc.Atlas(Sc.iAtlas).Scouts;
bands                 = {'delta','theta','alpha','beta','gamma'};
data_roi              = zeros(length(Scouts),size(data,3));
X1                    = ones(length(age),1);
X2                    = age;
X                     = [X1 X2];
fig_scattergram       = cell(length(bands),1);
for band = 1:length(bands)
    for roi = 1:length(Scouts)
        data_roi(roi,:)               = squeeze(median(data(Scouts(roi).Vertices,band,:),1));
    end
    data_roi_median                   = median(data_roi,2);
    [val,id_data_roi]                 = sort(data_roi_median);
    data_roi                          = data_roi(id_data_roi,:);
    fig = figure;
    count_roi = 1;
    for roi = 1:length(Scouts)
        scatter(age,squeeze(data_roi(roi,:)));
        hold on
        Y                             = squeeze(data_roi(roi,:))';
        B(:,roi)                      = X\Y;
        Y                             = squeeze(B(1,roi))*X(:,1) + squeeze(B(2,roi))*X(:,2);
        plot(age,Y)
        count_roi = count_roi + 1;
    end
    xlabel('age');
    ylabel('roi-act');
    title(['age-scattergram ',bands{band}]);
    fig_scattergram{band}             = fig;
end

