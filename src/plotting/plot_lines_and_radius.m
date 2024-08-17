function plot_lines_and_radius(n_reps, values, time_comb_all, data_comb_all, angls, colour_reps, av_col, speed_str, date_str0, ...
    xticks_vals, xticklabel_vals, ylim_vals, rlim_vals)

    n_values = length(values);
    rad_vals_reps = zeros([n_values+1,n_reps]);
    for j = 1:n_values
        i_nan = find(isnan(time_comb_all(j,1,:)),1,'first');
        time_comb = squeeze(time_comb_all(j,:,1:i_nan-1));
        data_comb = squeeze(data_comb_all(j,:,1:i_nan-1));

        av_resp = mean(data_comb);
        time_comb = time_comb./1000000; % convert to seconds
        av_time = mean(time_comb);

        figure
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
            plot(time_comb(ii, :), data_comb(ii, :), 'Color', col, 'LineWidth', 0.65); 
            hold on
            ylim(ylim_vals)
            box off 
            ax = gca;
            ax.TickDir = 'out';    
            ax.TickLength = [0.03, 0.03];
            ax.LineWidth = 1;
            ax.FontSize = 8;
        end 
        plot(av_time, av_resp, 'Color', av_col, 'LineWidth', 2)
        xticks(xticks_vals)
        xticklabels(xticklabel_vals)
        title(angls(j))
        ylabel('Voltage (mV)');
        xlabel('Time (s)');
        annotation('textbox', [0.03, 0.88, 0.2, 0.1], 'String', speed_str, 'EdgeColor', 'none', 'FontSize', 18);
        annotation('textbox', [0.03, 0.82, 0.2, 0.1], 'String', date_str0, 'EdgeColor', 'none', 'FontSize', 14);

        rad_vals_reps(j,:) = max(data_comb,[],2)-min(data_comb,[],2);
    end
    rad_vals_reps(n_values+1,:) = rad_vals_reps(1,:);

    if n_values>1
        % plot polar plot in the centre of the subplot: 
        angls_rad = deg2rad(angls); 
        figure
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
            polarplot(angls_rad, rad_vals_reps(:,ii), 'Color', col, 'LineWidth', 0.65); 
            hold on
        end 
        mean_rad_values = mean(rad_vals_reps, 2);
        polarplot(angls_rad, mean_rad_values, 'Color', av_col, 'LineWidth', 2)
        rlim(rlim_vals)
        rticks([0, 20, 40, 60])
        rticklabels({'0', '20', '40', '60'})
        thetaticks([0, 45, 90, 135, 180, 225, 270, 315])
        annotation('textbox', [0.03, 0.88, 0.2, 0.1], 'String', speed_str, 'EdgeColor', 'none', 'FontSize', 18);
        annotation('textbox', [0.03, 0.82, 0.2, 0.1], 'String', date_str0, 'EdgeColor', 'none', 'FontSize', 14);
    end
end 
