function process_flashes(date_folder, st_idx, stop_idx, stim_type)
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

    data_all_reps = zeros(7, 6077, n_exps); 

    for idx = 1:n_exps
        exp_name  = exp_folders(idx).name;
        exp_folder_path = fullfile(date_folder_path, exp_name);
        % Move into the appropriate experiment folder. 
        cd(exp_folder_path)

        load('processed_data.mat', 'ts_avg_reps')

        data = squeeze(ts_avg_reps(2, st_idx:stop_idx, :));
        len_data = length(data);
        data_all_reps(1:7, 1:len_data, idx) = data;
    end 

    data_avg = mean(data_all_reps, 3);

    %% Generate figure: 

    figure;
    % Plot all repetitions in light grey
    for j = 1:n_exps
        data2 = data_all_reps(:, :, j);
        for i = 1:7
            subplot(7,1,i)
            plot(data2(i, :), 'Color', [0.8 0.8 0.8], 'LineWidth', 1)
            hold on 
        end 
    end
    % plot the mean in black
    for i = 1:7
        subplot(7,1,i)

        frames_with_data = find(~isnan(data_avg(i, :)));
        st_fr = frames_with_data(1);
        end_fr = frames_with_data(end); 

        plot(data_avg(i, :), 'k', 'LineWidth', 2)
        ylim([-6.5, -4.5])
        if i == 1 
            speed_str = '0-5';
        elseif i == 2 
            speed_str = '1';
        elseif i == 3
            speed_str = '4';
        elseif i == 4
            speed_str = '8';
        elseif i == 5
            speed_str = '16';
        elseif i == 6
            speed_str = '32';
        elseif i == 7
            speed_str = '64';
        end
        title(strcat(stim_type,'-', speed_str,'Hz'))
        xlim([st_fr end_fr])
        box off
        ax = gca;
        ax.TickDir = 'out';
    end 
    
    f = gcf;
    f.Position = [213   210   422   827];


end 

