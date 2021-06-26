function fig_scattergram = plot_age_sens(data,age)
bands                 = {'delta','theta','alpha','beta','gamma'};
X1                    = ones(length(age),1);
X2                    = age;
X                     = [X1 X2];
fig_scattergram       = cell(length(bands),1);
for band = 1:length(bands)
    data_sens                         = squeeze(data(:,band,:));
    data_sens_median                  = median(data_sens,2);
    [val,id_data_sens]                = sort(data_sens_median);
    data_sens                         = data_sens(id_data_sens,:);
    fig = figure;
    count_roi = 1;
    for roi = 1:length(Scouts)
        scatter(age,squeeze(data_sens(roi,:)));
        hold on
        Y                             = squeeze(data_sens(roi,:))';
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
