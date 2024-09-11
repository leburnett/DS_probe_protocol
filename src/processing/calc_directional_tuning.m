function calc_directional_tuning(n_reps, cell_type, date_str)
    
    res_files = dir('RES_all_reps*');
    load(res_files(1).name, 'data_all_reps')
    
    angls = 0:45:315;
    angls(9) = angls(1);
    angls_rad = deg2rad(angls); 
    
    for plot_n = 1:4
    
        if plot_n == 1
            % % % OFF 20 dps
            values = [13, 21, 6, 17, 14, 22, 5, 18];
            av_col = [0.19, 0.19, 0.19];
        elseif plot_n == 2
            % 100 dps
            values = [15, 23, 8, 19, 16, 24, 7, 20];
            av_col = [0.65, 0.65, 0.65];
        elseif plot_n == 3
            % % % ON 20 dps
            values = [108, 116, 101, 112, 109, 117, 100, 113];
            av_col = [0.32, 0.62, 0.36];
        elseif plot_n == 4
            % 100 dps
            values = [110, 118, 103, 114, 111, 119, 102, 115];
            av_col = [0.70, 0.86, 0.58];
        end 
        
        % Find baseline voltage across all reps and all conditions of the bar
        % stimulus. 
        all_voltage_data = squeeze(data_all_reps(values, 3, 1:n_reps));
        all_voltage_data = vertcat(all_voltage_data{:}); % reshape and unpack values in cell arrays. 
        exp_baseline = nanmedian(all_voltage_data);
        
        for j = 1:8
                idx = values(j);
        
                voltage_data = squeeze(data_all_reps(idx, 3, 1:n_reps));
                frame_data = squeeze(data_all_reps(idx, 2, 1:n_reps));
                time_data = squeeze(data_all_reps(idx, 1, 1:n_reps));
        
                % Find the shortest length of a rep. 
                min_len = 1000000; % use 1000000 as a baseline. 
                for k = 1:n_reps
                    dd = voltage_data{k};
                    len_dd = length(dd);
                    if len_dd<min_len
                        min_len = len_dd;
                    end 
                end 
        
                start_from = 500; % remove 25ms at the beginning.Show 250ms static
                remove_end = 2750; % remove 125ms at end.
                min_len2 = min_len - (start_from+remove_end)+1; 
        
                % Collect voltage data from across the repetitions. 
                data_comb = zeros(n_reps, min_len2);
                frame_comb = zeros(n_reps, min_len2);
                time_comb = zeros(n_reps, min_len2);
        
                % For each rep, extract the relevant voltage data.
                for k = 1:n_reps
                    da = voltage_data{k};
                    fa = frame_data{k};
                    ta = (time_data{k});
                    ta = ta-ta(1); % start time from zero for each rep. 
        
                    data_comb(k, :) = da(start_from:min_len-remove_end);
                    frame_comb(k, :) = fa(start_from:min_len-remove_end);
                    time_comb(k, :) = ta(start_from:min_len-remove_end);
        
                    % Find the maximum voltage value during the direction. Do
                    % not include the 250ms static at the beginning.
                    max_val_rep = max(da(start_from+4500:min_len-remove_end));
                    rad_vals_reps(k, j) = max_val_rep;
                end 
        
                av_resp = mean(data_comb);
                av_frame = mean(frame_comb);
                av_time = mean(time_comb);
                av_time = av_time-av_time(1);
        
                rad_vals_reps2 = abs(exp_baseline - rad_vals_reps);
                % repeat the first value as the 9th value to form a complete circle
                % when plotting. 
                rad_vals_reps2(:, 9) = rad_vals_reps2(:, 1);
        
        end 
        
         mean_rad_values = mean(rad_vals_reps2);
        
        %% Compute the directional tuning as per Groschner et al. 2022
        
        
         % Example Data: Vectors defined by their angles (in radians) and magnitudes
        angles = angls_rad; % [0, pi/4, pi/2, 3*pi/4]; % Vector angles in radians
        magnitudes = mean_rad_values;    % Magnitudes of each vector
        
        % Calculate the components of the individual vectors
        x_components = magnitudes .* cos(angles); % x-components
        y_components = magnitudes .* sin(angles); % y-components
        
        % Calculate the resultant vector's components
        resultant_x = sum(x_components);
        resultant_y = sum(y_components);
        
        % Magnitude of the resultant vector
        resultant_magnitude = sqrt(resultant_x^2 + resultant_y^2);
        
        % Sum of the magnitudes of the individual vectors
        sum_of_magnitudes = sum(magnitudes);
        
        % Directional tuning
        directional_tuning = resultant_magnitude / sum_of_magnitudes;
        
        % Display the result
        disp(cell_type)
        disp(date_str)
        disp(['Plot_n = ', num2str(plot_n)])
        disp(['Directional Tuning: ', num2str(directional_tuning)]);


        %% DS by Seelig and Gruntman method (diff / sum) 

        pd_idx = find(mean_rad_values == max(mean_rad_values));
        
        if numel(pd_idx)>1
            pd_idx = pd_idx(1);
        end 

        % for DS - null direction = 180 deg from PD
        if pd_idx <= 4
            nd_idx = pd_idx +4 ;
        elseif pd_idx > 4 
            nd_idx = pd_idx - 4;
        end 

        pd = mean_rad_values(pd_idx);
        nd = mean_rad_values(nd_idx);

        dsi = (pd - nd)/(pd +nd);
        disp(['DSI: ', num2str(dsi)]);

        % for OS 
        if pd_idx <= 6 
            ortho_idx = pd_idx + 2;
        else 
            ortho_idx = pd_idx - 2;
        end 

        if ortho_idx <= 4 
            o2_idx = ortho_idx + 4;
        else
            o2_idx = ortho_idx - 4;
        end 

        pd_orient = mean(mean_rad_values(pd_idx)+mean_rad_values(nd_idx));
        ortho_orient = mean(mean_rad_values(ortho_idx)+mean_rad_values(o2_idx));

        osi = (pd_orient - ortho_orient)/(pd_orient + ortho_orient);
        disp(['OSI: ', num2str(osi)]);
        
    
    end 


end 







