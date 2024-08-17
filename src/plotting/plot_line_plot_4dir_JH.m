function plot_line_plot_4dir_JH(n_reps, colour_reps, ylim_vals, rlim_vals, date_str, edge_or_bar)
% Used to create 4 x line plots of responses to thin bar stimuli or moving
% edges.

% These stimuli only move in the 4 cardinal directions. They do not move
% along the diagonals. 

% Since it can be used for both 'edge' stimuli and 'thin bar' stimuli, the
% type must be specified by setting "edge__or_bars" to either "edge" or
% "bar"

    date_str0 = strrep(date_str, '_', '-');

    % Only 4 angles
    angls = 0:90:315;
    angls(5) = angls(1);
    
    for plot_n = 1:4
        if plot_n == 1
            % % % OFF
            % 20 dps
            if edge_or_bar == "bar"
                values = [9, 2 ,10, 1];
            elseif edge_or_bar == "edge"
                values = [25, 29, 26, 30];
            end 
            av_col = [0.19, 0.19, 0.19];
            % av_col = [0.1, 0, 0.5]; 
            xlim_val = 5;
            xticks_vals = 0:1:5;
            xticklabel_vals = {'0', '1', '2', '3', '4', '5'};
            speed_str = '20dps-Dark-';
        elseif plot_n == 2
            % 100 dps
            if edge_or_bar == "bar"
                values = [11, 4, 12, 3];
            elseif edge_or_bar == "edge"
                values = [27, 31, 28, 32];
            end 
            av_col = [0.65, 0.65, 0.65];
            % av_col = [0.1, 0, 0.5]; 
            xlim_val = 1.5;
            xticks_vals = 0:0.5:1.5;
            xticklabel_vals = {'0', '0.5', '1', '1.5'};
            speed_str = '100dps-Dark-';
        elseif plot_n == 3
            % % % ON
            % 20 dps
            if edge_or_bar == "bar"
                values = [104, 97, 105, 96];
            elseif edge_or_bar == "edge"
                values = [120, 124, 121, 125];
            end 
            av_col = [0.32, 0.62, 0.36];
            % av_col = [0.905, 0.697, 0.175];
            xlim_val = 5;
            xticks_vals = 0:1:5; %0:20000:114000;
            xticklabel_vals = {'0', '1', '2', '3', '4', '5'};
            speed_str = '20dps-Bright-';
        elseif plot_n == 4
            % 100 dps
            if edge_or_bar == "bar"
                values = [106, 99, 107, 98];
            elseif edge_or_bar == "edge"
                values = [122, 126, 123, 127];
            end 
            av_col = [0.70, 0.86, 0.58];
            % av_col = [0.905, 0.697, 0.175];
            xlim_val = 1.5;
            xticks_vals = 0:0.5:1.5;
            xticklabel_vals = {'0', '0.5', '1', '1.5'};
            speed_str = '100dps-Bright-';
        end 
    
        [time_comb_all, frame_comb_all, data_comb_all] = load_voltages(n_reps, date_str, values);

        plot_lines_and_radius(n_reps, values, time_comb_all, data_comb_all, angls, colour_reps, av_col, speed_str, date_str0, xticks_vals, xticklabel_vals, ylim_vals, rlim_vals)

    end 
end

