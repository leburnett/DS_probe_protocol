function process_1REP_DS_data(project_folder, date_folder, date_str, cell_type)
% Process the data from the 1REP protocol, where each saved file is one
% repetition of the DS Probe Protocol. Uses the output from Lisa's
% 'process_data' script. 

% Created by Burnett - 24 May 2024 - updated 25 July 2024

    %% Run through experiment folders
    date_folder_path = fullfile(project_folder, date_folder); 
    cd(date_folder_path)

    processed_data_path = '/Users/burnettl/Documents/Projects/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/ProcessedData2';
    cell_type_processed_folder = fullfile(processed_data_path, cell_type);
    
    % If this folder doesn't exist yet, make it. 
    if ~isfolder(cell_type_processed_folder)
        mkdir(cell_type_processed_folder)
    end 

    n_conditions = 127; % This is fixed for this protocol. FIXME - to be updated in the future. 
    n_data_types = 3; % times, frames, voltage

    % List the experiment folders for that day
    exp_folders = dir('42*'); %dir('SS*');
    n_reps = height(exp_folders);

    data_all_reps = cell(n_conditions, n_data_types, n_reps); 

    for idx = 1:n_reps

        % move into the experiment directory
        exp_name  = exp_folders(idx).name;
        exp_folder_path = fullfile(date_folder_path, exp_name);
        cd(exp_folder_path)

        % Load the start times of the conditions. 
        load(fullfile(exp_folder_path, 'processed_data.mat'), 'timestamps', 'ts_avg_reps')

        for i = 1:n_conditions
            cond_frame_data = squeeze(ts_avg_reps(1, i, :));
            cond_volt_data = squeeze(ts_avg_reps(2, i, :))*10;

            data_all_reps{i, 1, idx} = timestamps;
            data_all_reps{i, 2, idx} = cond_frame_data;
            data_all_reps{i, 3, idx} = cond_volt_data;
        end 

    end 

    % save local copy within date folder
    save(fullfile(date_folder_path, strcat('RES_all_reps_', date_str, '.mat')), 'data_all_reps');
    % save copy in 'processed_data' folder
    save(fullfile(cell_type_processed_folder, strcat('RES_all_reps_', date_str, '.mat')), 'data_all_reps');

    cd(date_folder_path)
end 


































