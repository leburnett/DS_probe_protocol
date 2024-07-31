function plot_bar_line_ON_OFF_comb_4dir(n_reps, slow_or_fast, ylim_vals, rlim_vals, date_str, edge_or_bar)
% Used to create 2 x line plots of responses to thin bar stimuli or moving
% edges. One plot for 20 dps stimuli and the other for 100 dps stimuli. 

% Only in 4 cardinal directions. 

% Since it can be used for both 'edge' stimuli and 'thin bar' stimuli, the
% type must be specified by setting "edge__or_bars" to either "edge" or
% "bar"

    res_files = dir('RES_all_reps*');
    load(res_files(1).name, 'data_all_reps')
    date_str = strrep(date_str, '_', '-');

    angls = 0:90:315;
    angls(5) = angls(1);
    angls_rad = deg2rad(angls); 
    
    if slow_or_fast == "slow"
        idx_values = [1,3];
    elseif slow_or_fast == "fast"
        idx_values = [2,4];
    end 

    figure

    for plot_n = idx_values

        if plot_n == 1
            % % % OFF
            % 20 dps
            if edge_or_bar == "bar"
                values = [9, 1 ,10, 2];
            elseif edge_or_bar == "edge"
                values = [25, 30, 26, 29];
            end 
            av_col = [0.19, 0.19, 0.19];
            % av_col = [0.1, 0, 0.5]; 
        elseif plot_n == 2
            % 100 dps
            if edge_or_bar == "bar"
                values = [11, 3, 12, 4];
            elseif edge_or_bar == "edge"
                values = [27, 32, 28, 31];
            end
            av_col = [0.65, 0.65, 0.65];
            % av_col = [0.1, 0, 0.5]; 
        elseif plot_n == 3
            % % % ON
            % 20 dps
            if edge_or_bar == "bar"
                values = [104, 96, 105, 97];
            elseif edge_or_bar == "edge"
                values = [120, 125, 121, 124];
            end 
            av_col = [0.32, 0.62, 0.36];
            % av_col = [0.905, 0.697, 0.175];
        elseif plot_n == 4
            % 100 dps
            if edge_or_bar == "bar"
                values = [106, 98, 107, 99];
            elseif edge_or_bar == "edge"
                values = [122, 127, 123, 126];
            end
            av_col = [0.70, 0.86, 0.58];
            % av_col = [0.905, 0.697, 0.175];
        end 
    

        % Find baseline voltage across all reps and all conditions of the bar
        % stimulus. 
        all_voltage_data = squeeze(data_all_reps(values, 3, 1:n_reps));
        all_voltage_data = vertcat(all_voltage_data{:}); % reshape and unpack values in cell arrays. 
        exp_baseline = nanmedian(all_voltage_data);

        % subplot_values = [15, 3, 11, 23];
        % subplot_values = {[9,10,14,15], [2,3,7,8], [11,12,16,17], [18, 19, 23, 24]};

        % Central subplot (smaller)
        pos_center = [0.4, 0.4, 0.2, 0.2];
        
        % Top subplot (larger)
        pos_top = [0.37, 0.7, 0.25, 0.25];
        
        % Bottom subplot (larger)
        pos_bottom = [0.37, 0.07, 0.25, 0.25];
        
        % Left subplot (larger)
        pos_left = [0.1, 0.39, 0.25, 0.25];
        
        % Right subplot (larger)
        pos_right = [0.67, 0.39, 0.25, 0.25];

        subplot_values = {pos_right, pos_top, pos_left, pos_bottom};

        for j = 1:4
            % subplot(5, 5, subplot_values{j})
            subplot('Position', subplot_values{j});
            hold on
            idx = values(j);

            voltage_data = squeeze(data_all_reps(idx, 3, 1:n_reps));
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
    
            % Collect voltage data from across the repetitions. 
            data_comb = zeros(n_reps, min_len);
            time_comb = zeros(n_reps, min_len);

            % For each rep, extract the relevant voltage data.
            for k = 1:n_reps
                da = voltage_data{k};
                ta = (time_data{k});
                ta = ta-ta(1); % start time from zero for each rep.

                data_comb(k, :) = da(1:min_len);
                time_comb(k, :) = ta(1:min_len);

                % Find the maximum voltage value during the direction
                max_val_rep = max(da(1:min_len));
                rad_vals_reps(k, j) = max_val_rep;
            end 

            av_resp = nanmean(data_comb);
            av_time = nanmean(time_comb);

            notnanx = find(~isnan(av_resp));

            rad_vals_reps2 = abs(exp_baseline - rad_vals_reps);
            % repeat the first value as the 9th value to form a complete circle
            % when plotting. 
            rad_vals_reps2(:, 5) = rad_vals_reps2(:, 1);
        
            % PLOT REPS
            for ii = 1:n_reps

                % col = [0.8, 0.8, 0.8];
                % plot(data_comb(ii, :), 'Color', col, 'LineWidth', 0.6); hold on
                ylim(ylim_vals)
                if slow_or_fast == "slow"
                    % xlim([0 114000])
                    xlim([0 av_time(notnanx(end))])
                    % xticks(0:20000:114000);
                    % xticklabels({'0', '1', '2', '3', '4', '5'})
                elseif slow_or_fast == "fast"
                    % xlim([0 30000])
                    xlim([0 av_time(notnanx(end))])
                    % xticks(0:10000:30000);
                    % xticklabels({'0', '0.5', '1', '1.5'})
                end 
                box off 
                ax = gca;
                ax.TickDir = 'out';  
                ax.TickLength = [0.02, 0.02];
                ax.LineWidth = 1;
                ax.FontSize = 10;
                yticks([-60, -50, -40, -30])
            end 
    
            % PLOT AVERAGE 
            % if plot_n == 1 || plot_n == 2
            %     av_col = 'b';
            % elseif plot_n == 3 || plot_n == 4
            %     av_col = 'r';
            % end 

            plot(av_time(2:end), av_resp(2:end), 'Color', av_col, 'LineWidth', 2); hold on
            % title(angls(j))
            if angls(j)==270
                xlabel('Time (s)');
            elseif angls(j)==180
                ylabel('Voltage (mV)');
            end 
        end

        % Add polar plot in the middle: 

        % subplot(5, 5, 13)
        subplot('Position', pos_center);
        % subplot(7,7,[17, 18, 19, 24, 25, 26, 31, 32, 33])
        % plot polar plot in the centre of the subplot: 
        % for ii = 1:n_reps
            % col = [0.8 0.8 0.8];
            % polarplot(angls_rad, rad_vals_reps2(ii, :), 'Color', col, 'LineWidth', 0.65); hold on
        % end 

        % PLOT AVERAGE 
        mean_rad_values = nanmean(rad_vals_reps2);
        polarplot(angls_rad, mean_rad_values, 'Color', av_col, 'LineWidth', 2); hold on
        rlim(rlim_vals)
        rticks([0 10, 20, 30])
        rticklabels({'', '', '', '30'})
        thetaticks([0, 45, 90, 135, 180, 225, 270, 315])
        % thetaticks([])
    

        if slow_or_fast == "slow"
            speed_str = '20dps-';
        elseif slow_or_fast == "fast"
            speed_str = '100dps-';
        end 

        str_to_add = strcat(speed_str, edge_or_bar);
        % Add text:
        annotation('textbox', [0.03, 0.88, 0.2, 0.1], 'String', str_to_add, 'EdgeColor', 'none', 'FontSize', 15);
        annotation('textbox', [0.03, 0.82, 0.2, 0.1], 'String', date_str, 'EdgeColor', 'none', 'FontSize', 12);

        f = gcf;
        % f.Position = [236 74 1124 973];
        f.Position = [236   548   577   499]; 
        % f.Position = [236   477   694   570]; %small for PDFs


    end 

end













