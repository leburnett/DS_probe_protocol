function plot_line_plot_7speeds_flicker_JH(n_reps, colour_reps, ylim_vals, date_str)
% Used to create 1 plot of responses to flicker stimuli
% Will contain 7 subplots - 1 per speed. 

    date_str0 = strrep(date_str, '_', '-');

    for plot_n = 1:7
        if plot_n == 1
            % 0.5Hz
            values = [89];
            % speed_str = '0.5Hz - gratings';
            speed_str = '0.5Hz';
            av_col = [0.6, 0.0, 0.5];
        elseif plot_n == 2
            % 1Hz
            values = [90];
            % speed_str = '1Hz - gratings';
            speed_str = '1Hz';
            av_col = [0, 0, 0.5];
        elseif plot_n == 3
            % 4Hz
            values = [91];
            % speed_str = '4Hz - gratings';
            speed_str = '4Hz';
            av_col = [0.58, 0.75, 0.8];
        elseif plot_n == 4
            % 8Hz
            values = [92];
            % speed_str = '8Hz - gratings';
            speed_str = '8Hz';
            av_col = [0.13, 0.55, 0.13];
        elseif plot_n == 5
            % 16Hz
            values = [93];
            % speed_str = '16Hz - gratings';
            speed_str = '16Hz';
            av_col = [1, 0.65, 0.7];
        elseif plot_n == 6
            % 32Hz
            values = [94];
            % speed_str = '32Hz - gratings';
            speed_str = '32Hz';
            av_col = [1, 0.65, 0];
        elseif plot_n == 7
            % 64Hz
            values = [95];
            % speed_str = '64Hz - gratings';
            speed_str = '64Hz';
            av_col = [1, 0, 0];
        end 
        xticks_vals = 0:1:3; %0:10000:70000;
        xticklabel_vals = {'0', '1', '2', '3'};

        [time_comb_all, frame_comb_all, data_comb_all] = load_voltages(n_reps, date_str, values);

        plot_lines_and_radius(n_reps, values, time_comb_all, data_comb_all, 0, colour_reps, av_col, speed_str, date_str0, xticks_vals, xticklabel_vals, ylim_vals, 0)

    end
end











