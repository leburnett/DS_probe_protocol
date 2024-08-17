function plot_line_plot_8dir_gratings_JH(n_reps, colour_reps, ylim_vals, rlim_vals, date_str)
% Used to create 7 x plots of responses to grating stimuli at
% different speeds. Will contain 8 subplots - 1 per direction, with a polar
% plot in the middle.

    date_str0 = strrep(date_str, '_', '-');

    angls = 0:45:315;
    angls(9) = angls(1);

    for plot_n = 1:7
        if plot_n == 1
            % 0.5Hz
            values = [33, 61, 47, 75, 34, 62, 48, 76];
            % speed_str = '0.5Hz - gratings';
            speed_str = '0.5Hz';
            av_col = [0.6, 0.0, 0.5];
        elseif plot_n == 2
            % 1Hz
            values = [35, 63, 49, 77, 36, 64, 50, 78];
            % speed_str = '1Hz - gratings';
            speed_str = '1Hz';
            av_col = [0, 0, 0.5];
        elseif plot_n == 3
            % 4Hz
            values = [37, 65, 51, 79, 38, 66, 52, 80];
            % speed_str = '4Hz - gratings';
            speed_str = '4Hz';
            av_col = [0.58, 0.75, 0.8];
        elseif plot_n == 4
            % 8Hz
            values = [39, 67, 53, 81, 40, 68, 54, 82];
            % speed_str = '8Hz - gratings';
            speed_str = '8Hz';
            av_col = [0.13, 0.55, 0.13];
        elseif plot_n == 5
            % 16Hz
            values = [41, 69, 55, 83, 42, 70, 56, 84];
            % speed_str = '16Hz - gratings';
            speed_str = '16Hz';
            av_col = [1, 0.65, 0.7];
        elseif plot_n == 6
            % 32Hz
            values = [43, 71, 57, 85, 44, 72, 58, 86];
            % speed_str = '32Hz - gratings';
            speed_str = '32Hz';
            av_col = [1, 0.65, 0];
        elseif plot_n == 7
            % 64Hz
            values = [45, 73, 59, 87, 46, 74, 60, 88];
            % speed_str = '64Hz - gratings';
            speed_str = '64Hz';
            av_col = [1, 0, 0];
        end 
        xticks_vals = 0:1:3; %0:10000:70000;
        xticklabel_vals = {'0', '1', '2', '3'};
    
        [time_comb_all, frame_comb_all, data_comb_all] = load_voltages(n_reps, date_str, values);

        plot_lines_and_radius(n_reps, values, time_comb_all, data_comb_all, angls, colour_reps, av_col, speed_str, date_str0, xticks_vals, xticklabel_vals, ylim_vals, rlim_vals)
        
    end
end









