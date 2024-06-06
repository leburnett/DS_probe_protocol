function plot_polar_plot(n_reps)
%% Generate polar plot

% Load results file
res_files = dir('RES_all_reps*');
load(res_files(1).name, 'data_all_reps')

rad_vals_reps= ones(n_reps,8);

angls = 0:45:315;
angls(9) = angls(1);
angls = deg2rad(angls); 

figure
for subplot_n = 1:4

    % n_cols = ceil(n_reps/2);
    subplot(2, 2, subplot_n)

    if subplot_n == 1
        % % % OFF
        % 20 dps
        values = [13, 21, 6, 17, 14, 22, 5, 18];
    elseif subplot_n == 2
        % 100 dps
        values = [15, 23, 8, 19, 16, 24, 7, 20];
    elseif subplot_n == 3
        % % % ON
        % 20 dps
        values = [108, 116, 101, 112, 109, 117, 100, 113];
    elseif subplot_n == 4
        % 100 dps
        values = [110, 118,103, 114, 111, 119, 101, 115];
    end 

    % Find baseline voltage across all reps and all conditions of the bar
    % stimulus. 
    all_voltage_data = squeeze(data_all_reps(values, 3, 1:n_reps));
    all_voltage_data = horzcat(all_voltage_data{:}); % reshape and unpack values in cell arrays. 
    exp_baseline = median(all_voltage_data);
    
    for j = 1:8
        idx = values(j);
        voltage_data = squeeze(data_all_reps(idx, 3, 1:n_reps));
        
        % Find the length of the shortest repetition. 
        % Use this to generate the array created later to store the voltage data in. 

        min_len = 1000000; % use 1000000 as a baseline. 
        for k = 1:n_reps
            dd = voltage_data{k};
            len_dd = length(dd);
            if len_dd<min_len
                min_len = len_dd;
            end 
        end 

        % Collect voltage data from across the repetitions. 
        data_comb = zeros(n_reps, min_len);
        % For each rep, extract the relevant voltage data.
        for k = 1:n_reps
            da = voltage_data{k};
            data_comb(k, :) = da(1:min_len);
            % Find the maximum voltage value during the direction
            max_val_rep = max(da(1:min_len));
            rad_vals_reps(k, j) = max_val_rep;
        end 
    
        % reshaped = reshape(data_comb, 1,[]);
        % av_resp = mean(data_comb);
        % max_av = max(av_resp);
        % if numel(max_av)>1
        %     if numel(unique(max_av))>1 
        %         max_av = max(max_av);
        %     else 
        %         max_av = max_av(1);
        %     end 
        % end 
        % rad_values(1,j) = max_av;

    end 
    
    % PLOT REPS
    rad_vals_reps2 = abs(exp_baseline - rad_vals_reps);
    % repeat the first value as the 9th value to form a complete circle
    % when plotting. 
    rad_vals_reps2(:, 9) = rad_vals_reps2(:, 1);
    
    for ii = 1:n_reps
        if ii == 1
            col = 'r';
        elseif ii == 2
            col = 'm';
        elseif ii == 3
            col = 'c';
        elseif ii == 4
            col = 'b';
        elseif ii == 5
            col = [0.6 0.6 0.6];
        end 
        polarplot(angls, rad_vals_reps2(ii, :), 'Color', col, 'LineWidth', 0.75); hold on
    end 
    
    % PLOT AVERAGE 
    mean_rad_values = mean(rad_vals_reps2);
    polarplot(angls, mean_rad_values, 'Color', 'k', 'LineWidth', 3)
    rlim([0 20])
    thetaticks([0, 45, 90, 135, 180, 225, 270, 315])

    if subplot_n == 1
        title('OFF - 20 dps') 
    elseif subplot_n == 2
        title('OFF - 100 dps') 
    elseif subplot_n == 3
        title('ON - 20 dps') 
    elseif subplot_n == 4
        title('ON - 100 dps') 
    end 

end 

f = gcf;
f.Position = [440   303   842   744];











