% Run through functions for processing DS_probe_protocol data
% Created by Burnett - 21 May 2024

% % Run through all experiment folders and process the data. 
project_folder = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09';
date_folder = '06_03_2024';

processing_settings_path = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/processing_settings.mat';

%% Process the data - Lisa's script

date_folder_path = fullfile(project_folder, date_folder); 
cd(date_folder_path)

% List the experiment folders for that day
exp_folders = dir('SS*');
n_exps = height(exp_folders);

for idx = 1:n_exps
    % move into the experiment directory
    exp_name  = exp_folders(idx).name;
    exp_folder_path = fullfile(date_folder_path, exp_name);
    cd(exp_folder_path)
    % process data - generate 'processed_data.mat' file. 
    process_data(exp_folder_path, processing_settings_path)

end 

%% Process data for polar plots 

process_1REP_DS_data(project_folder, date_folder);

% process_ds_probe_protocol_data(date_folder);