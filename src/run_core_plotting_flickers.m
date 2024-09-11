%% Plot data from DS_probe_protocol - FLICKERS 
% Created by Burnett

clear 
close all
clc

cd('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09');

%% Read in log table with details of all of the experiments conducted. 

log_table = readtable('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/exp_recording_log.xlsx');
n_exps = height(log_table);

% Set this as true if you would like each repetition to be coloured in a
% different colour, or false if you would like them to all be grey. 
colour_reps = false;

% set save_figs to true if you would like to save the figures, or true if
% you just want to visualise them. 
save_figs = true;

for exp = 32:39 %1:n_exps

    % Initialise parameters that will change
    date_str = log_table.date_str{exp}; %'05_28_2024';
    date_to_process = log_table.date_to_process{exp}; %'05_28_2024_2'; % when there are subfolders set this to '06_18_2024_1' etc.
    cell_type = log_table.cell_type{exp}; %'TmY3';
    project_folder = strcat('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/', cell_type);

    % RUN THIS SCRIPT WITHIN THE DATE FOLDER. 
    % Where the 'RES_all_reps...' file is found. 
    date_folder = fullfile(project_folder, date_str);
    cd(date_folder)

    data_save_path = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Results/data/flickers';
    if ~isfolder(data_save_path)
       mkdir(data_save_path)
    end 

    cell_type_save_path = strcat(data_save_path, '/', cell_type);
    date_data_save_path = fullfile(cell_type_save_path, date_str);
    if ~isfolder(date_data_save_path)
       mkdir(date_data_save_path)
    end 

    % If subfolders exist
    if numel(date_to_process) > 10 

        % Make subfolder for saving:
        subfolder_data_save_path = fullfile(date_data_save_path, date_to_process);

        % If this folder doesn't exist yet, make it. 
        if ~isfolder(subfolder_data_save_path)
            mkdir(subfolder_data_save_path)
        end 

        % Move into the subfolder
        subfolder = fullfile(date_folder, date_to_process);
        cd(subfolder)

        % Set the save path as the subfolder save path
        date_data_save_path = subfolder_data_save_path;
    else
         % If subfolders exist
        if numel(date_to_process) > 10 
    
            % Move into the subfolder
            subfolder = fullfile(date_folder, date_to_process);
            cd(subfolder)
        end 
    end 

    %% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    
    if save_figs == true
        save_path = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Results/Figures/flickers';
        
        % Initialise path to save figures 
        cell_type_fig_save_path = strcat(save_path, '/', cell_type);
        date_fig_save_path = fullfile(cell_type_fig_save_path, date_str);
        
        % If this folder doesn't exist yet, make it. 
        if ~isfolder(date_fig_save_path)
            mkdir(date_fig_save_path)
        end 
        
        % Set the save path as the date save path
        fig_save_path = date_fig_save_path;
    
        % If subfolders exist
        if numel(date_to_process) > 10 
    
            % Make subfolder for saving:
            subfolder_fig_save_path = fullfile(date_fig_save_path, date_to_process);
    
            % If this folder doesn't exist yet, make it. 
            if ~isfolder(subfolder_fig_save_path)
                mkdir(subfolder_fig_save_path)
            end 
    
            % Move into the subfolder
            subfolder = fullfile(date_folder, date_to_process);
            cd(subfolder)
    
            % Set the save path as the subfolder save path
            fig_save_path = subfolder_fig_save_path;
        end 
    
    else
        % If subfolders exist
        if numel(date_to_process) > 10 
    
            % Move into the subfolder
            subfolder = fullfile(date_folder, date_to_process);
            cd(subfolder)
    
        end 
    
    end 
    
    exp_folders = dir('SS*');
    % Number of runs of the protocol:
    n_reps = length(exp_folders);
    
    %% 
    ylim_vals = [-65 -45]; 
    rlim_vals = [0 15];
    
    %% Plot 

    plot_line_plot_7speeds_flicker(n_reps, colour_reps, ylim_vals, date_str)

    if save_figs == true
        f = gcf;
        % save as MATLAB fig
        savefig(fullfile(fig_save_path, strcat('Line_plot_flicker_', cell_type, '_', date_str, '.fig')))
        % save as PNG
        saveas(f, fullfile(fig_save_path, strcat('Line_plot_flicker_', cell_type, '_', date_str, '.png')), 'png')
        close    
    end 

    % fft_analysis_flicker(n_reps, date_str, date_data_save_path)
    % close all

end 

cd('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09');
clear
