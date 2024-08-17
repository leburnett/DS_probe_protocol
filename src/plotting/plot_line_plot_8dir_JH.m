function plot_line_plot_8dir_JH(n_reps, colour_reps, ylim_vals, rlim_vals, date_str)
% Used to create 8 x line plots of responses to thick bar stimuli with a
% polar plot in the middle.

    date_str0 = strrep(date_str, '_', '-');

    angls = 0:45:315;
    angls(9) = angls(1);
    
    for plot_n = 1:4
        if plot_n == 1
            % % % OFF
            % 20 dps
            values = [13, 21, 6, 17, 14, 22, 5, 18];
            av_col = [0.19, 0.19, 0.19];
            % av_col = [0.1, 0, 0.5]; 
            % xlim_val = 120000;
            xticks_vals = 0:1:5; %0:20000:114000;
            xticklabel_vals = {'0', '1', '2', '3', '4', '5'};
            speed_str = '20dps-Dark-bar6';
        elseif plot_n == 2
            % 100 dps
            values = [15, 23, 8, 19, 16, 24, 7, 20];
            av_col = [0.65, 0.65, 0.65];
            % av_col = [0.1, 0, 0.5]; 
            % xlim_val = 30000;
            xticks_vals = 0:0.5:1.5; %0:10000:30000;
            xticklabel_vals = {'0', '0.5', '1', '1.5'};
            speed_str = '100dps-Dark-bar6';
        elseif plot_n == 3
            % % % ON
            % 20 dps
            values = [108, 116, 101, 112, 109, 117, 100, 113];
            av_col = [0.32, 0.62, 0.36];
            % av_col = [0.905, 0.697, 0.175];
            % xlim_val = 120000;
            xticks_vals = 0:1:5; %0:20000:114000;
            xticklabel_vals = {'0', '1', '2', '3', '4', '5'};
            speed_str = '20dps-Light-bar6';
        elseif plot_n == 4
            % 100 dps
            values = [110, 118,103, 114, 111, 119, 102, 115];
            av_col = [0.70, 0.86, 0.58];
            % av_col = [0.905, 0.697, 0.175];
            % xlim_val = 30000;
            xticks_vals = 0:0.5:1.5; %0:10000:30000;
            xticklabel_vals = {'0', '0.5', '1', '1.5'};
            speed_str = '100dps-Light-bar6';
        end 
    
        [time_comb_all, frame_comb_all, data_comb_all] = load_voltages(n_reps, date_str, values);

        plot_lines_and_radius(n_reps, values, time_comb_all, data_comb_all, angls, colour_reps, av_col, speed_str, date_str0, xticks_vals, xticklabel_vals, ylim_vals, rlim_vals)

    end 
end


