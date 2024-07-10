function plot_line_plot_4dir(n_reps, colour_reps, ylim_vals, rlim_vals, edge_or_bar)
% Used to create 4 x line plots of responses to thin bar stimuli or moving
% edges.

% These stimuli only move in the 4 cardinal directions. They do not move
% along the diagonals. 

% Since it can be used for both 'edge' stimuli and 'thin bar' stimuli, the
% type must be specified by setting "edge__or_bars" to either "edge" or
% "bar"

    res_files = dir('RES_all_reps*');
    load(res_files(1).name, 'data_all_reps')
    date_str = strrep(res_files(1).name(end-13:end-4), '_', '-');

    % Only 4 angles
    angls = 0:90:315;
    angls(5) = angls(1);
    angls_rad = deg2rad(angls); 
    
    for plot_n = 1:4
        figure
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
            xlim_val = 120000;
            xticks_vals = 0:20000:114000;
            xticklabel_vals = {'0', '1', '2', '3', '4', '5'};
            speed_str = '20dps-Dark-';
        elseif plot_n == 2
            % 100 dps
            if edge_or_bar == "bar"
                values = [11, 3, 12, 4];
            elseif edge_or_bar == "edge"
                values = [27, 32, 28, 31];
            end 
            av_col = [0.65, 0.65, 0.65];
            % av_col = [0.1, 0, 0.5]; 
            xlim_val = 30000;
            xticks_vals = 0:10000:30000;
            xticklabel_vals = {'0', '0.5', '1', '1.5'};
            speed_str = '100dps-Dark-';
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
            xlim_val = 120000;
            xticks_vals = 0:20000:114000;
            xticklabel_vals = {'0', '1', '2', '3', '4', '5'};
            speed_str = '20dps-Bright-';
        elseif plot_n == 4
            % 100 dps
            if edge_or_bar == "bar"
                values = [106, 98, 107, 99];
            elseif edge_or_bar == "edge"
                values = [122, 127, 123, 126];
            end 
            av_col = [0.70, 0.86, 0.58];
            % av_col = [0.905, 0.697, 0.175];
            xlim_val = 30000;
            xticks_vals = 0:10000:30000;
            xticklabel_vals = {'0', '0.5', '1', '1.5'};
            speed_str = '100dps-Bright-';
        end 
    
        % Find baseline voltage across all reps and all conditions of the bar
        % stimulus. 
        all_voltage_data = squeeze(data_all_reps(values, 3, 1:n_reps));
        all_voltage_data = horzcat(all_voltage_data{:}); % reshape and unpack values in cell arrays. 
        exp_baseline = median(all_voltage_data);

        % subplot_values = [15, 3, 11, 23];

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
            % subplot(5, 5, subplot_values(j))
            subplot('Position', subplot_values{j});
    
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
            rad_vals_reps2(:, 5) = rad_vals_reps2(:, 1);
        
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
                    
                plot(data_comb(ii, :), 'Color', col, 'LineWidth', 0.65); hold on
                ylim(ylim_vals)
                box off 
                ax = gca;
                ax.TickDir = 'out';    
                ax.TickLength = [0.03, 0.03];
                ax.LineWidth = 1;
                ax.FontSize = 8;
            end 

            % PLOT AVERAGE 
            plot(av_resp, 'Color', av_col, 'LineWidth', 2)
            xlim([0 xlim_val])
            xticks(xticks_vals)
            xticklabels(xticklabel_vals)
            % title(angls(j))

            if angls(j)==270
                xlabel('Time (s)');
            elseif angls(j)==180
                ylabel('Voltage (mV)');
            end 

        end

        % subplot(5, 5, 13)
        subplot('Position', pos_center);
        % subplot(7,7,[17, 18, 19, 24, 25, 26, 31, 32, 33])
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
        % thetaticks([])
    
        % if plot_n == 1
        %     sgtitle('OFF - 20 dps') 
        % elseif plot_n == 2
        %     sgtitle('OFF - 100 dps') 
        % elseif plot_n == 3
        %     sgtitle('ON - 20 dps') 
        % elseif plot_n == 4
        %     sgtitle('ON - 100 dps') 
        % end 
        str_to_add = strcat(speed_str, edge_or_bar);
        % Add text:
        annotation('textbox', [0.03, 0.88, 0.2, 0.1], 'String', str_to_add, 'EdgeColor', 'none', 'FontSize', 20);
        annotation('textbox', [0.03, 0.82, 0.2, 0.1], 'String', date_str, 'EdgeColor', 'none', 'FontSize', 20);


        f = gcf;
        f.Position = [236   477   694   570]; %[236   493   612   554]; %small for pdfs
        % f.Position = [236 74 1124 973];
        % f.Position = [563   428   468   619];
        % tightfig;
    end 

end


