
clear 
close all
clc

%% Initialise parameters that will changes

date_to_process = '05_23_2024';
cell_type = 'TmY3';

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

%% Path to cell type folder
protocol_folder = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/';
project_folder = strcat(protocol_folder, cell_type);
cd(project_folder)

%% Path to date folder

% List all of the date folders
date_folder_dir = dir(); 

% remove 'DS_Store, '.' and '..'. 
% If you are not using a Mac then you won't have DS_Store and this should
% be: 'date_folder_dir(1:2, :) = [];'
date_folder_dir(1:3, :) = []; 
n_days = length(date_folder_dir);

if isempty(date_to_process)
    % update this so that if this argument is empty it will run through the
    % entire folder. 
    % dates_to_process = 
else
    date_str = date_to_process;
end 

cd(fullfile(project_folder, date_str))

n_subfolders = 0; % set as 0 to begin with. 

experiment_folder_dir = dir('SS*');

if isempty(experiment_folder_dir)
    % means that there is a subfolder structure where there is >1 cell or
    % 2 recording sessions in one day. 
    sub_folder_dir = dir();
    sub_folder_dir(1:3, :) = []; 

    n_subfolders = length(sub_folder_dir);
    subfolder_names = '';
    for idx = 1:n_subfolders
        subfolder_names{idx} = string(sub_folder_dir(idx).name);
    end 
end 


%% Process the data and create 'RES_all_reps...' .mat file in the date folder. 

if n_subfolders ==0 
    date_folder = date_str;
    process_ds_probe_protocol_data(project_folder, date_folder, date_str, cell_type)

elseif n_subfolders > 0 

    for idx = 1:n_subfolders
        
        subfolder_str = subfolder_names{idx};

        % % Make subfolder for saving:
        % subfolder_fig_save_path = fullfile(date_fig_save_path, subfolder_str);
        % 
        % % If this folder doesn't exist yet, make it. 
        % if ~isfolder(subfolder_fig_save_path)
        %     mkdir(subfolder_fig_save_path)
        % end 

        subfolder = strcat(date_str, '/', subfolder_str);
        process_ds_probe_protocol_data(project_folder, subfolder, subfolder_str, cell_type)
    end 
end 


