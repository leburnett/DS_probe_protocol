function plot_bar_line_ON_OFF_comb(n_reps, slow_or_fast, ylim_vals, rlim_vals)

%% Generate polar plot
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
            % % % OFF
            % 20 dps
            values = [13, 21, 6, 17, 14, 22, 5, 18];
            av_col = [0.19, 0.19, 0.19];
            % av_col = [0.1, 0, 0.5]; 
        elseif plot_n == 2
            % 100 dps
            values = [15, 23, 8, 19, 16, 24, 7, 20];
            av_col = [0.65, 0.65, 0.65];
            % av_col = [0.1, 0, 0.5]; 
        elseif plot_n == 3
            % % % ON
            % 20 dps
            values = [108, 116, 101, 112, 109, 117, 100, 113];
            av_col = [0.32, 0.62, 0.36];
            % av_col = [0.905, 0.697, 0.175];
        elseif plot_n == 4
            % 100 dps
            values = [110, 118,103, 114, 111, 119, 102, 115];
            av_col = [0.70, 0.86, 0.58];
            % av_col = [0.905, 0.697, 0.175];
        end 
    

        % Find baseline voltage across all reps and all conditions of the bar
        % stimulus. 
        all_voltage_data = squeeze(data_all_reps(values, 3, 1:n_reps));
        all_voltage_data = horzcat(all_voltage_data{:}); % reshape and unpack values in cell arrays. 
        exp_baseline = median(all_voltage_data);

        subplot_values = [15, 9, 3, 7, 11, 17, 23, 19];

        for j = 1:8
            subplot(5, 5, subplot_values(j))
    
            idx = values(j);
            voltage_data = squeeze(data_all_reps(idx, 3, 1:n_reps));
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
            % For each rep, extract the relevant voltage data.
            for k = 1:n_reps
                da = voltage_data{k};
                data_comb(k, :) = da(1:min_len);

                % Find the maximum voltage value during the direction
                max_val_rep = max(da(1:min_len));
                rad_vals_reps(k, j) = max_val_rep;
            end 

            av_resp = mean(data_comb);

            rad_vals_reps2 = abs(exp_baseline - rad_vals_reps);
            % repeat the first value as the 9th value to form a complete circle
            % when plotting. 
            rad_vals_reps2(:, 9) = rad_vals_reps2(:, 1);
        
            % PLOT REPS
            for ii = 1:n_reps

                % col = [0.8, 0.8, 0.8];
                % plot(data_comb(ii, :), 'Color', col, 'LineWidth', 0.6); hold on
                ylim(ylim_vals)
                if slow_or_fast == "slow"
                    xlim([0 114000])
                    xticks(0:20000:114000);
                    xticklabels({'0', '1', '2', '3', '4', '5'})
                elseif slow_or_fast == "fast"
                    xlim([0 30000])
                    xticks(0:10000:30000);
                    xticklabels({'0', '0.5', '1', '1.5'})
                end 
                box off 
                ax = gca;
                ax.TickDir = 'out';  
                ax.TickLength = [0.02, 0.02];
                ax.LineWidth = 1;
                ax.FontSize = 8;
                yticks([-60, -50, -40, -30])
            end 
    
            % PLOT AVERAGE 
            % if plot_n == 1 || plot_n == 2
            %     av_col = 'b';
            % elseif plot_n == 3 || plot_n == 4
            %     av_col = 'r';
            % end 

            plot(av_resp, 'Color', av_col, 'LineWidth', 2); hold on
            title(angls(j))
        end

        % Add polar plot in the middle: 

        subplot(5, 5, 13)
        % subplot(7,7,[17, 18, 19, 24, 25, 26, 31, 32, 33])
        % plot polar plot in the centre of the subplot: 
        % for ii = 1:n_reps
            % col = [0.8 0.8 0.8];
            % polarplot(angls_rad, rad_vals_reps2(ii, :), 'Color', col, 'LineWidth', 0.65); hold on
        % end 

        % PLOT AVERAGE 
        mean_rad_values = mean(rad_vals_reps2);
        polarplot(angls_rad, mean_rad_values, 'Color', av_col, 'LineWidth', 2); hold on
        rlim(rlim_vals)
        rticks([0 10, 20, 30])
        rticklabels({'', '', '', '30'})
        thetaticks([0, 45, 90, 135, 180, 225, 270, 315])
        % thetaticks([])
    
        f = gcf;
        % f.Position = [236 74 1124 973];
        f.Position = [236   477   694   570]; %small for PDFs
    end 

end













