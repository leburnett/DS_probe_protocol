function plot_polar_ON_OFF_comb(n_reps, slow_or_fast, rlim_vals)
% Used to create 2 x line plots of responses to thick bar stimuli. 
% One plot for 20 dps stimuli and the other for 100 dps stimuli. 

    res_files = dir('RES_all_reps*');
    load(res_files(1).name, 'data_all_reps')

    angls = 0:45:315;
    angls(9) = angls(1);
    angls_rad = deg2rad(angls); 
    
    if slow_or_fast == "slow"
        idx_values = [1,3];
    elseif slow_or_fast == "fast"
        idx_values = [2,4];
    end 

    % Generate figure that is ONLY the polar plot. 
    figure

    for plot_n = idx_values

        if plot_n == 1
            % % % OFF 20 dps
            values = [13, 21, 6, 17, 14, 22, 5, 18];
            av_col = [0.19, 0.19, 0.19];
        elseif plot_n == 2
            % 100 dps
            values = [15, 23, 8, 19, 16, 24, 7, 20];
            av_col = [0.65, 0.65, 0.65];
        elseif plot_n == 3
            % % % ON 20 dps
            values = [108, 116, 101, 112, 109, 117, 100, 113];
            av_col = [0.32, 0.62, 0.36];
        elseif plot_n == 4
            % 100 dps
            values = [110, 118, 103, 114, 111, 119, 102, 115];
            av_col = [0.70, 0.86, 0.58];
        end 

        % Find baseline voltage across all reps and all conditions of the bar
        % stimulus. 
        all_voltage_data = squeeze(data_all_reps(values, 3, 1:n_reps));
        all_voltage_data = vertcat(all_voltage_data{:}); % reshape and unpack values in cell arrays. 
        exp_baseline = nanmedian(all_voltage_data);

        for j = 1:8
    
            idx = values(j);

            voltage_data = squeeze(data_all_reps(idx, 3, 1:n_reps));
            frame_data = squeeze(data_all_reps(idx, 2, 1:n_reps));
            time_data = squeeze(data_all_reps(idx, 1, 1:n_reps));

            % Find the shortest length of a rep. 
            min_len = 1000000; % use 1000000 as a baseline. 
            for k = 1:n_reps
                dd = voltage_data{k};
                len_dd = length(dd);
                if len_dd<min_len
                    min_len = len_dd;
                end 
            end 

            start_from = 500; % remove 25ms at the beginning.Show 250ms static
            remove_end = 2750; % remove 125ms at end.

            % For each rep, extract the relevant voltage data.
            for k = 1:n_reps
                da = voltage_data{k};
                % Find the maximum voltage value during the direction. Do
                % not include the 250ms static at the beginning.
                max_val_rep = max(da(start_from+4500:min_len-remove_end));
                rad_vals_reps(k, j) = max_val_rep;
            end 

            rad_vals_reps2 = abs(exp_baseline - rad_vals_reps);
            % repeat the first value as the 9th value to form a complete circle
            % when plotting. 
            rad_vals_reps2(:, 9) = rad_vals_reps2(:, 1);
 
        end

        % plot polar plot in the centre of the subplot: 
        for jj = 1:n_reps
            col = [0.85 0.85 0.85];
            polarplot(angls_rad, rad_vals_reps2(jj, :), 'Color', col, 'LineWidth', 1);
            hold on
        end 

        % PLOT AVERAGE 
        mean_rad_values = mean(rad_vals_reps2);
        polarplot(angls_rad, mean_rad_values, 'Color', av_col, 'LineWidth', 3, 'LineStyle', '-', 'Marker', 'none'); hold on
        rlim(rlim_vals)
        rticks([0, rlim_vals(2)])
        rticklabels({'', string(rlim_vals(2))})
        % thetaticks([])
        thetaticks([0, 45, 90, 135, 180, 225, 270, 315])
        thetaticklabels({''})
        set(gca, "FontSize", 15)

        f = gcf;
        f.Position = [216 629 344 268];

    end 

end













