function plot_line_plot_7speeds_flicker(n_reps, colour_reps, ylim_vals, date_str)
% Used to create 1 plot of responses to flicker stimuli
% Will contain 7 subplots - 1 per speed. 

    res_files = dir('RES_all_reps*');
    load(res_files(1).name, 'data_all_reps')
    date_str = strrep(date_str, '_', '-');

    speeds = {'0.5Hz', '1Hz', '4Hz', '8Hz', '16Hz', '32Hz', '64Hz'};
   

        figure

        values = [89, 90, 91, 92, 93, 94, 95];
        % title_str = 'Flickers';

        xticks_vals = 0:10000:70000;
        xticklabel_vals = {'0', '0.5', '1', '1.5','2', '2.5', '3', '3.5'};

        % Find baseline voltage across all reps and all conditions of the bar
        % stimulus. 
        all_voltage_data = squeeze(data_all_reps(values, 3, 1:n_reps));
        all_voltage_data = horzcat(all_voltage_data{:}); % reshape and unpack values in cell arrays. 
        exp_baseline = median(all_voltage_data);

        for j = 1:7 % 7 speeds 

             if j == 1
                av_col = [0.6, 0.0, 0.5];
            elseif j == 2
                av_col = [0, 0, 0.5];
            elseif j == 3
                av_col = [0.58, 0.75, 0.8];
            elseif j == 4
                av_col = [0.13, 0.55, 0.13];
            elseif j == 5
                av_col = [1, 0.65, 0.7];
            elseif j == 6
                av_col = [1, 0.65, 0];
            elseif j == 7
                av_col = [1, 0, 0];
            end 

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
                xlim([0 67500])
                box off 
                ax = gca;
                ax.TickDir = 'out';   
                ax.TickLength = [0.03, 0.03];
                ax.LineWidth = 1;
                ax.FontSize = 8;
            end 
    
            % PLOT AVERAGE 
            plot(av_resp, 'Color', av_col, 'LineWidth', 2)
            xticks(xticks_vals)
            xticklabels(xticklabel_vals)
            title(speeds{j})
            ylabel('Voltage (mV)');

            if j == 7
                xlabel('Time (s)');
            end 

        end

        % sgtitle(strcat(title_str, ' - ', date_str))
        sgtitle(date_str)

        f = gcf;
        f.Position = [1468 101 315 946];

end











