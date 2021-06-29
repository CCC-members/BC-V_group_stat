function fig_scattergram = plot_age_sens(data,age)
X                     = [ones(length(age),1) age];
fig_scattergram       = figure;
for freq = 1:size(data,2)
    data_sens                         = squeeze(data(:,freq,:));
    data_sens_median                  = median(data_sens,2);
    [val,id_data_sens]                = sort(data_sens_median);
    data_sens                         = data_sens(id_data_sens,:);  
    count_sens = 1;
    for sens = 1:size(data,1)
        scatter(age,squeeze(data_sens(sens,:)));
        hold on
        Y                             = squeeze(data_sens(sens,:))';
        B(:,sens)                      = X\Y;
        Y                             = squeeze(B(1,sens))*X(:,1) + squeeze(B(2,sens))*X(:,2);
        plot(age,Y)
        count_sens = count_sens + 1;
    end
    xlabel('age');
    ylabel('roi-act');
    title(['age-scattergram ',bands{freq}]);
    fig_scattergram{freq}             = fig;
end

