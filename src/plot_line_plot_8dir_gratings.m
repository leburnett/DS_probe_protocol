function plot_line_plot_8dir_gratings(n_reps)
%% Generate polar plot
    res_files = dir('RES_all_reps*');
    load(res_files(1).name, 'data_all_reps')

    angls = 0:45:315;
    % angls(9) = angls(1);
    % angls = deg2rad(angls); 
    
    for plot_n = 1:7
        figure
        if plot_n == 1
            % 0.5Hz
            values = [33, 75, 48, 61, 34, 76, 47, 62];
        elseif plot_n == 2
            % 1Hz
            values = [35, 77, 50, 63, 36, 78, 49, 64];
        elseif plot_n == 3
            % 4Hz
            values = [37, 79, 52, 65, 38, 80, 51, 66];
        elseif plot_n == 4
            % 8Hz
            values = [39, 81, 54, 67, 40, 82, 53, 68];
        elseif plot_n == 5
            % 16Hz
            values = [41, 83, 56, 69, 42, 84, 55, 70];
        elseif plot_n == 6
            % 32Hz
            values = [43, 85, 58, 71, 44, 86, 57, 72];
        elseif plot_n == 7
            % 64Hz
            values = [45, 87, 60, 73, 46, 88, 59, 74];
        end 
    
        % Find baseline voltage across all reps and all conditions of the bar
        % stimulus. 
        % all_voltage_data = squeeze(data_all_reps(values, 3, 1:n_reps));
        % all_voltage_data = horzcat(all_voltage_data{:}); % reshape and unpack values in cell arrays. 
        % exp_baseline = median(all_voltage_data);
        
        for j = 1:8
            subplot(4, 2, j)
    
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
                xlim([0 67500])
                box off 
                ax = gca;
                ax.TickDir = 'out';                
            end 
    
            % PLOT AVERAGE 
            plot(av_resp, 'Color', 'k', 'LineWidth', 2.5)
    
            title(angls(j))
        end
    
        if plot_n == 1
            sgtitle('0.5 Hz') 
        elseif plot_n == 2
            sgtitle('1 Hz') 
        elseif plot_n == 3
            sgtitle('4 Hz') 
        elseif plot_n == 4
            sgtitle('8 Hz') 
        elseif plot_n == 5
            sgtitle('16 Hz') 
        elseif plot_n == 6
            sgtitle('32 Hz') 
        elseif plot_n == 7
            sgtitle('64 Hz') 
        end 

        f = gcf;
        f.Position = [563   428   468   619];
    end 

end


% f = gcf;
% f.Position = [440   303   842   744];











