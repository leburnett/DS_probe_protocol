function plot_line_plot_8dir(n_reps, colour_reps, ylim_vals, rlim_vals, date_str)
% Used to create 8 x line plots of responses to thick bar stimuli with a
% polar plot in the middle.

    res_files = dir('RES_all_reps*');
    load(res_files(1).name, 'data_all_reps')
    date_str = strrep(date_str, '_', '-');

    angls = 0:45:315;
    angls(9) = angls(1);
    angls_rad = deg2rad(angls); 
    
    for plot_n = 1:4
        figure
        if plot_n == 1
            % % % OFF
            % 20 dps
            values = [13, 21, 6, 17, 14, 22, 5, 18];
            av_col = [0.19, 0.19, 0.19];
            % av_col = [0.1, 0, 0.5]; 
            xlim_val = 120000;
            xticks_vals = 0:1:5; %0:20000:114000;
            xticklabel_vals = {'0', '1', '2', '3', '4', '5'};
            speed_str = '20dps-Dark-bar6';
        elseif plot_n == 2
            % 100 dps
            values = [15, 23, 8, 19, 16, 24, 7, 20];
            av_col = [0.65, 0.65, 0.65];
            % av_col = [0.1, 0, 0.5]; 
            xlim_val = 30000;
            xticks_vals = 0:0.5:1.5; %0:10000:30000;
            xticklabel_vals = {'0', '0.5', '1', '1.5'};
            speed_str = '100dps-Dark-bar6';
        elseif plot_n == 3
            % % % ON
            % 20 dps
            values = [108, 116, 101, 112, 109, 117, 100, 113];
            av_col = [0.32, 0.62, 0.36];
            % av_col = [0.905, 0.697, 0.175];
            xlim_val = 120000;
            xticks_vals = 0:1:5; %0:20000:114000;
            xticklabel_vals = {'0', '1', '2', '3', '4', '5'};
            speed_str = '20dps-Light-bar6';
        elseif plot_n == 4
            % 100 dps
            values = [110, 118,103, 114, 111, 119, 102, 115];
            av_col = [0.70, 0.86, 0.58];
            % av_col = [0.905, 0.697, 0.175];
            xlim_val = 30000;
            xticks_vals = 0:0.5:1.5; %0:10000:30000;
            xticklabel_vals = {'0', '0.5', '1', '1.5'};
            speed_str = '100dps-Light-bar6';
        end 
    
        % Find baseline voltage across all reps and all conditions of the bar
        % stimulus. 
        all_voltage_data = squeeze(data_all_reps(values, 3, 1:n_reps));
        all_voltage_data = horzcat(all_voltage_data{:}); % reshape and unpack values in cell arrays. 
        exp_baseline = median(all_voltage_data);

        subplot_values = [15, 9, 3, 7, 11, 17, 23, 19];
        % subplot_values = [28, 13, 4, 9, 22, 37, 46, 41];

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

            % Collect voltage data from across the repetitions. 
            data_comb = zeros(n_reps, min_len);
            frame_comb = zeros(n_reps, min_len);
            time_comb = zeros(n_reps, min_len);

            % For each rep, extract the relevant voltage data.
            for k = 1:n_reps
                da = voltage_data{k};
                fa = frame_data{k};
                ta = (time_data{k});
                ta = ta-ta(1); % start time from zero for each rep. 

                data_comb(k, :) = da(1:min_len);
                frame_comb(k, :) = fa(1:min_len);
                time_comb(k, :) = ta(1:min_len);

                % Find the maximum voltage value during the direction
                max_val_rep = max(da(1:min_len));
                rad_vals_reps(k, j) = max_val_rep;

            end

            av_resp = mean(data_comb);
            av_frame = mean(frame_comb);
            time_comb = time_comb./1000000; % convert to seconds
            av_time = mean(time_comb);

            rad_vals_reps2 = abs(exp_baseline - rad_vals_reps);
            % repeat the first value as the 9th value to form a complete circle
            % when plotting. 
            rad_vals_reps2(:, 9) = rad_vals_reps2(:, 1);
        
            % PLOT REPS
            for ii = 1:n_reps

                if colour_reps == true 
                    if ii == 1
                        col = 'r';
                    elseif ii == 2
                        col = [1, 0.71, 0.76];
                    elseif ii == 3
                        col = [0.68, 0.85, 0.9];
                    elseif ii == 4
                        col = 'b';
                    elseif ii == 5
                        col = [0.6 0.6 0.6];
                    end 
                elseif colour_reps == false
                    col = [0.8 0.8 0.8];
                end 
                    
                plot(time_comb(ii, :), data_comb(ii, :), 'Color', col, 'LineWidth', 0.65); hold on
                ylim(ylim_vals)
                box off 
                ax = gca;
                ax.TickDir = 'out';    
                ax.TickLength = [0.03, 0.03];
                ax.LineWidth = 1;
                ax.FontSize = 8;
            end 

            % PLOT AVERAGE 
            plot(av_time, av_resp, 'Color', av_col, 'LineWidth', 2)
            xlim([0 xlim_val])
            xticks(xticks_vals)
            xticklabels(xticklabel_vals)
            title(angls(j))

            yyaxis right
            plot(av_time, av_frame, 'k', 'LineWidth', 0.5, 'LineStyle', '-', 'Marker', 'none')
            ax = gca;
            ax.YAxis(2).Color = 'k';
            ylabel('Frame position')

            if angls(j)==270
                xlabel('Time (s)');
            elseif angls(j)==180
                ylabel('Voltage (mV)');
            end 

        end

        subplot(5, 5, 13)
        % plot polar plot in the centre of the subplot: 
        for ii = 1:n_reps
            if colour_reps == true 
                if ii == 1
                    col = 'r';
                elseif ii == 2
                    col = [1, 0.71, 0.76];
                elseif ii == 3
                    col = [0.68, 0.85, 0.9];
                elseif ii == 4
                    col = 'b';
                elseif ii == 5
                    col = [0.6 0.6 0.6];
                end 
            elseif colour_reps == false
                col = [0.8 0.8 0.8];
            end 
            polarplot(angls_rad, rad_vals_reps2(ii, :), 'Color', col, 'LineWidth', 0.65); hold on
        end 

        % PLOT AVERAGE 
        mean_rad_values = mean(rad_vals_reps2);
        polarplot(angls_rad, mean_rad_values, 'Color', av_col, 'LineWidth', 2)
        rlim(rlim_vals)
        rticks([0 10, 20, 30])
        rticklabels({'0', '', '', '30'})
        thetaticks([0, 45, 90, 135, 180, 225, 270, 315])

        annotation('textbox', [0.03, 0.88, 0.2, 0.1], 'String', speed_str, 'EdgeColor', 'none', 'FontSize', 18);
        annotation('textbox', [0.03, 0.82, 0.2, 0.1], 'String', date_str, 'EdgeColor', 'none', 'FontSize', 14);

        f = gcf;
        f.Position = [236   548   577   499]; % [236   477   694   570]; %[236   493   612   554]; %small for pdfs
        % f.Position = [236 74 1124 973];
        % f.Position = [563   428   468   619];
        % tightfig;
    end 

end


