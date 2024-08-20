function plot_bar_line_ON_OFF_comb(n_reps, slow_or_fast, ylim_vals, rlim_vals, date_str)
% Used to create 2 x line plots of responses to thick bar stimuli. 
% One plot for 20 dps stimuli and the other for 100 dps stimuli. 

    res_files = dir('RES_all_reps*');
    load(res_files(1).name, 'data_all_reps')
    date_str = strrep(date_str, '_', '-');

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
            subplot(5, 5, subplot_values(j))
    
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
            % time_comb = time_comb./1000000; % convert to seconds
            av_time = mean(time_comb);
            av_time = av_time-av_time(1);

            rad_vals_reps2 = abs(exp_baseline - rad_vals_reps);
            % repeat the first value as the 9th value to form a complete circle
            % when plotting. 
            rad_vals_reps2(:, 9) = rad_vals_reps2(:, 1);

            rectangle('Position', [0, ylim_vals(1), av_time(4500), diff(ylim_vals)], 'FaceColor', [0 0 0 0.1], 'EdgeColor', 'none')
            hold on 
        
            % PLOT REPS
            for ii = 1:n_reps
                plot(time_comb(ii, :), data_comb(ii, :), 'Color', [0.85 0.85 0.85], 'LineWidth', 0.65);
                hold on
                ylim(ylim_vals)
                box off 
                ax = gca;
                ax.TickDir = 'out';  
                ax.TickLength = [0.02, 0.02];
                ax.LineWidth = 1;
                ax.FontSize = 8;
            end 

            if slow_or_fast == "slow"
                % xlim([0 114000])
                % xticks(0:20000:114000);
                xticks(0:1:5)
                xticklabels({'0', '1', '2', '3', '4', '5'})
                xlim([0 av_time(end)])
            elseif slow_or_fast == "fast"
                % xlim([0 30000])
                % xticks(0:10000:30000);
                xticks(0:0.5:1.5)
                xticklabels({'0', '0.5', '1', '1.5'})
                xlim([0 (av_time(end)/4)])
            end 
    
            % PLOT AVERAGE 
            % yyaxis left
            plot(av_time, av_resp, 'Color', av_col, 'LineWidth', 2,  'LineStyle', '-', 'Marker', 'none'); 
            hold on
            yticks([-60, -50, -40, -30])
            ax.YAxis(1).Color = 'k';
            ylim(ylim_vals)

            % yyaxis right
            % plot(av_time, av_frame, 'k', 'LineWidth', 0.75, 'LineStyle', '-', 'Marker', 'none')
            % ax = gca;
            % ax.YAxis(2).Color = 'k';
            % ylabel('Frame position')
            % ylim([0 max(av_frame)+1])

            % title(angls(j))
        end

        % Add polar plot in the middle: 

        subplot(5, 5, 13)
        % subplot(7,7,[17, 18, 19, 24, 25, 26, 31, 32, 33])
        % plot polar plot in the centre of the subplot: 
        for jj = 1:n_reps
            col = [0.85 0.85 0.85];
            polarplot(angls_rad, rad_vals_reps2(jj, :), 'Color', col, 'LineWidth', 0.6);
            hold on
        end 

        % PLOT AVERAGE 
        mean_rad_values = mean(rad_vals_reps2);
        polarplot(angls_rad, mean_rad_values, 'Color', av_col, 'LineWidth', 2, 'LineStyle', '-', 'Marker', 'none'); hold on
        rlim(rlim_vals)
        % rticks([0 10, 20, 30])
        % rticklabels({'', '', '', '30'})
        rticks([0, rlim_vals(2)])
        rticklabels({'', string(rlim_vals(2))})
        % thetaticks([0, 45, 90, 135, 180, 225, 270, 315])
        thetaticks([])

        if slow_or_fast == "slow"
            speed_str = '20dps-bar6';
        elseif slow_or_fast == "fast"
            speed_str = '100dps-bar6';
        end 

        annotation('textbox', [0.03, 0.88, 0.2, 0.1], 'String', speed_str, 'EdgeColor', 'none', 'FontSize', 15);
        annotation('textbox', [0.03, 0.82, 0.2, 0.1], 'String', date_str, 'EdgeColor', 'none', 'FontSize', 12);

    
        f = gcf;
        % f.Position = [236 74 1124 973];
        f.Position = [10 141 1255 906];
        % f.Position = [236   548   577   499]; %[236   477   694   570]; %small for PDFs
    end 

end













