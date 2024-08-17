function process_gratings(date_folder, st_idx, stop_idx, pixel_width, stim_type, orient_str)
    % Generate dataframe of each recorded repetition of the bar
    % stimulus, and the average voltage across all repetitions. 
    
    %% 
    project_folder = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_05-20-24_16-30-23';
    date_folder_path = fullfile(project_folder, date_folder); 
    % Move into the appropriate date_folder.
    cd(date_folder_path)

    % List the experiment folders for that day
    exp_folders = dir('SS*');
    n_exps = height(exp_folders);

    data_all_reps = zeros(14, 6077, n_exps); 

    for idx = 1:n_exps
        exp_name  = exp_folders(idx).name;
        exp_folder_path = fullfile(date_folder_path, exp_name);
        % Move into the appropriate experiment folder. 
        cd(exp_folder_path)

        load('processed_data.mat', 'ts_avg_reps')

        data = squeeze(ts_avg_reps(2, st_idx:stop_idx, :));
        len_data = length(data);
        data_all_reps(1:14, 1:len_data, idx) = data;
    end 

    data_avg = mean(data_all_reps, 3);

    %% Generate figure: 

    figure;
    % Plot all repetitions in light grey
    for j = 1:n_exps
        data2 = data_all_reps(:, :, j);
        for i = 1:14
            subplot(7,2,i)
            plot(data2(i, :), 'Color', [0.8 0.8 0.8], 'LineWidth', 1)
            hold on 
        end 
    end
    % plot the mean in black
    for i = 1:14
        subplot(7,2,i)

        frames_with_data = find(~isnan(data_avg(i, :)));
        st_fr = frames_with_data(1);
        end_fr = frames_with_data(end); 

        plot(data_avg(i, :), 'k', 'LineWidth', 2)
        ylim([-6.5, -4.5])
        if i == 1 || i == 2
            speed_str = '0-5';
        elseif i == 3 || i == 4
            speed_str = '1';
        elseif i == 5 || i == 6
            speed_str = '4';
        elseif i == 7 || i == 8
            speed_str = '8';
        elseif i == 9 || i == 10
            speed_str = '16';
        elseif i == 11 || i == 12
            speed_str = '32';
        elseif i == 13 || i == 14
            speed_str = '64';
        end
        title(strcat(orient_str,'-',stim_type,'-',pixel_width,'pixels-', speed_str,'Hz'))
        xlim([st_fr end_fr])
        box off
        ax = gca;
        ax.TickDir = 'out';
    end 
    
    f = gcf;
    f.Position = [213    69   798   968];


end 

