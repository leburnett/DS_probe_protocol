function plot_polar_plot_with_arrow_DS_probe_protocol()

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

        subplot_values = [15, 9, 3, 7, 11, 17, 23, 19];

        for j = 1:8
            % subplot(5, 5, subplot_values(j))
    
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
            min_len2 = min_len - (start_from+remove_end)+1; 
    
            % Collect voltage data from across the repetitions. 
            data_comb = zeros(n_reps, min_len2);
            frame_comb = zeros(n_reps, min_len2);
            time_comb = zeros(n_reps, min_len2);

            % For each rep, extract the relevant voltage data.
            for k = 1:n_reps
                da = voltage_data{k};
                fa = frame_data{k};
                ta = (time_data{k});
                ta = ta-ta(1); % start time from zero for each rep. 

                data_comb(k, :) = da(start_from:min_len-remove_end);
                frame_comb(k, :) = fa(start_from:min_len-remove_end);
                time_comb(k, :) = ta(start_from:min_len-remove_end);

                % Find the maximum voltage value during the direction. Do
                % not include the 250ms static at the beginning.
                max_val_rep = max(da(start_from+4500:min_len-remove_end));
                rad_vals_reps(k, j) = max_val_rep;
            end 

            av_resp = mean(data_comb);
            av_frame = mean(frame_comb);
            av_time = mean(time_comb);
            av_time = av_time-av_time(1);

            rad_vals_reps2 = abs(exp_baseline - rad_vals_reps);
            % repeat the first value as the 9th value to form a complete circle
            % when plotting. 
            rad_vals_reps2(:, 9) = rad_vals_reps2(:, 1);

        end

        % PLOT AVERAGE 
        mean_rad_values = mean(rad_vals_reps2);
        polarplot(angls_rad, mean_rad_values, 'Color', av_col, 'LineStyle', '-',  'LineWidth', 3, 'Marker', 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'w'); 
        hold on

        rlim(rlim_vals)
        rticks([0, 10, 20])
        rticklabels({'0', '10', '20'})
        thetaticks(angls(1:8))

        ax = gca;
        ax.LineWidth = 1.2;
        ax.FontSize = 15;
        ax.ThetaTick = rad2deg(theta);
        ax.ThetaTickLabel = {};
        hold on

        angles = [0, pi/4, pi/2, 3*pi/4, pi, 5*pi/4, 3*pi/2, 7*pi/4];
        magnitudes = [9.1337, 8.2808, 9.4188, 14.6325, 7.2827, 7.3278, 12.2076, 10.6435];

        x = sum(magnitudes .* cos(angles));
        y = sum(magnitudes .* sin(angles));

        resultant_angle = atan2(y, x);
        resultant_angle = mod(resultant_angle, 2*pi); % ensure it's in [0, 2pi]
        resultant_magnitude = sqrt(x^2 + y^2);
        
        add_arrow_to_polarplot(resultant_magnitude, resultant_angle, col)
    end 

end 