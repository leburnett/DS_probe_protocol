function plot_line_plot_8dir(n_reps)
%% Generate polar plot
    res_files = dir('RES_all_reps*');
    load(res_files(1).name, 'data_all_reps')

    angls = 0:45:315;
    % angls(9) = angls(1);
    % angls = deg2rad(angls); 
    
    for plot_n = 1:4
        figure
        if plot_n == 1
            % % % OFF
            % 20 dps
            values = [13, 21, 6, 17, 14, 22, 5, 18];
        elseif plot_n == 2
            % 100 dps
            values = [15, 23, 8, 19, 16, 24, 7, 20];
        elseif plot_n == 3
            % % % ON
            % 20 dps
            values = [108, 116, 101, 112, 109, 117, 100, 113];
        elseif plot_n == 4
            % 100 dps
            values = [110, 118,103, 114, 111, 119, 101, 115];
        end 
    
        % Find baseline voltage across all reps and all conditions of the bar
        % stimulus. 
        % all_voltage_data = squeeze(data_all_reps(values, 3, 1:n_reps));
        % all_voltage_data = horzcat(all_voltage_data{:}); % reshape and unpack values in cell arrays. 
        % exp_baseline = median(all_voltage_data);
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
                ylim([-65 -20])
                box off 
                ax = gca;
                ax.TickDir = 'out';                
            end 
    
            % PLOT AVERAGE 
            plot(av_resp, 'Color', 'k', 'LineWidth', 2.5)
    
            title(angls(j))
        end
    
        if plot_n == 1
            sgtitle('OFF - 20 dps') 
        elseif plot_n == 2
            sgtitle('OFF - 100 dps') 
        elseif plot_n == 3
            sgtitle('ON - 20 dps') 
        elseif plot_n == 4
            sgtitle('ON - 100 dps') 
        end 

        f = gcf;
        f.Position = [563   428   468   619];
    end 

end


% f = gcf;
% f.Position = [440   303   842   744];











