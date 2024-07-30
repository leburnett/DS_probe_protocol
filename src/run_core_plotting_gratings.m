%% Plot data from DS_probe_protocol - GRATINGS 
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

for exp = 1:n_exps

    % Initialise parameters that will change
    date_str = log_table.date_str{exp}; %'05_28_2024';
    date_to_process = log_table.date_to_process{exp}; %'05_28_2024_2'; % when there are subfolders set this to '06_18_2024_1' etc.
    cell_type = log_table.cell_type{exp}; %'TmY3';
    project_folder = strcat('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/', cell_type);

    % RUN THIS SCRIPT WITHIN THE DATE FOLDER. 
    % Where the 'RES_all_reps...' file is found. 
    date_folder = fullfile(project_folder, date_str);
    cd(date_folder)

    %% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
    
    if save_figs == true
        save_path = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Results/Figures/gratings';
    
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
    ylim_vals = [-65 -30]; 
    rlim_vals = [0 30];
    
    %% Plot per speed
    % Line plot + polar plot in the middle

    plot_line_plot_8dir_gratings(n_reps, colour_reps, ylim_vals, rlim_vals, date_to_process)
    
    if save_figs == true
    
        for ii = 1:7

            if ii == 1
                bar_cond = 'gratings-64Hz';
            elseif ii == 2
                bar_cond = 'gratings-32Hz';
            elseif ii == 3
                bar_cond = 'gratings-16Hz';
            elseif ii == 4
                bar_cond = 'gratings-08Hz';
            elseif ii == 5
                bar_cond = 'gratings-04Hz';
            elseif ii == 6
                bar_cond = 'gratings-01Hz';
            elseif ii == 7
                bar_cond = 'gratings-005Hz';
            end 

        f = gcf;
        % save as MATLAB fig
        savefig(fullfile(fig_save_path, strcat('Line_plot_per_speed_', bar_cond,'_', cell_type, '_', date_str, '.fig')))
        % save as PNG
        saveas(f, fullfile(fig_save_path, strcat('Line_plot_per_speed_', bar_cond,'_', cell_type, '_', date_str, '.png')), 'png')
        close
        end 

    end 
    
    
    %% Plot per direction 

    plot_line_plot_7speeds_gratings(n_reps, colour_reps, ylim_vals, date_to_process)

    if save_figs == true
    
        for ii = 1:8

            if ii == 8
                bar_cond = 'gratings-000deg';
            elseif ii == 7
                bar_cond = 'gratings-045deg';
            elseif ii == 6
                bar_cond = 'gratings-090deg';
            elseif ii == 5
                bar_cond = 'gratings-135deg';
            elseif ii == 4
                bar_cond = 'gratings-180deg';
            elseif ii == 3
                bar_cond = 'gratings-225deg';
            elseif ii == 2
                bar_cond = 'gratings-270deg';
            elseif ii == 1
                bar_cond = 'gratings-315deg';
            end 

        f = gcf;
        % save as MATLAB fig
        savefig(fullfile(fig_save_path, strcat('Line_plot_per_orient_', bar_cond,'_', cell_type, '_', date_str, '.fig')))
        % save as PNG
        saveas(f, fullfile(fig_save_path, strcat('Line_plot_per_orient_', bar_cond,'_', cell_type, '_', date_str, '.png')), 'png')
        close
        end 

    end 


end 

cd('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09');
clear
