function plot_line_plot_flashes_JH(n_reps)

    date_str0 = strrep(date_str, '_', '-');
   
    values = [89, 90, 91, 92, 93, 94, 95];
    
    [time_comb_all, frame_comb_all, data_comb_all] = load_voltages(n_reps, date_str, values);

    plot_lines_and_radius(n_reps, values, time_comb_all, data_comb_all, angls_rad, colour_reps, av_col, speed_str, date_str0, xticks_vals, xticklabel_vals, ylim_vals, rlim_vals)



    for j = 1:7
        subplot(7, 1, j)

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
        end 

        av_resp = mean(data_comb);
    
        % PLOT REPS
        for ii = 1:n_reps
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
            plot(data_comb(ii, :), 'Color', col, 'LineWidth', 0.6); hold on
            ylim([-65 -30])
            xlim([0 62500])
            box off 
            ax = gca;
            ax.TickDir = 'out';                
        end 

        % PLOT AVERAGE 
        plot(av_resp, 'Color', 'k', 'LineWidth', 2.5)

        if j == 1
            title('0.5 Hz') 
        elseif j == 2
            title('1 Hz') 
        elseif j == 3
            title('4 Hz') 
        elseif j == 4
            title('8 Hz') 
        elseif j == 5
            title('16 Hz') 
        elseif j == 6
            title('32 Hz') 
        elseif j == 7
            title('64 Hz') 
        end 

    end

    f = gcf;
    f.Position = [563 1  413  1046];

end












