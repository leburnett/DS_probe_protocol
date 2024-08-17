%% Plot data from DS_probe_protocol - THIN BAR stimuli (2 pixel width - 3.75 VA) and EDGES

% Created by Burnett
% July 10th 2024
clear 
close all
clc

addpath 'C:\Users\hoellerj\Documents\GitHub\DS_probe_protocol\src\plotting'

%% Read in log table with details of all of the experiments conducted. 
git_folder = 'C:\Users\hoellerj\Documents\GitHub\DS_probe_protocol\results\';
log_table = readtable(strcat(git_folder, 'exp_recording_log_JH.xlsx'));
n_exps = height(log_table);

%% load data
% cd('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09');
data_folder0 = 'O:\Burnett\Jinyong\DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09\';
data_folder = 'O:\Burnett\Jinyong\DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09\ProcessedData\';

% Set this as true if you would like each repetition to be coloured in a
% different colour, or false if you would like them to all be grey. 
colour_reps = false;

% set save_figs to true if you would like to save the figures, or true if
% you just want to visualise them. 
save_figs = true;

for exp = 1:n_exps
    
    stim = ["edge", "bar"];

    % Initialise parameters that will change
    date_str = log_table.date_str{exp}; %'05_28_2024';
    date_to_process = log_table.date_to_process{exp}; %'05_28_2024_2'; % when there are subfolders set this to '06_18_2024_1' etc.
    cell_type = log_table.cell_type{exp}; %'TmY3';

    % RUN THIS SCRIPT WITHIN THE DATE FOLDER. 
    % Where the 'RES_all_reps...' file is found. 
    date_folder = fullfile(data_folder, cell_type);
    cd(date_folder)

    for stim_idx = 1:2
    
        edge_or_bar = stim(stim_idx);
        
        if save_figs == true
            save_path = strcat(git_folder, edge_or_bar);
        
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
                fig_save_path = subfolder_fig_save_path;
            end 
        end
        
        if date_to_process(end-1)=='_'
            exp_folders = dir(strcat(data_folder0, date_str, '\', date_to_process(end), '\SS*'));
        else
            exp_folders = dir(strcat(data_folder0, date_str, '\SS*'));
        end

        % Number of runs of the protocol:
        n_reps = length(exp_folders);
        
        %% 
        ylim_vals = [-70 -20]; %[-65 -30];
        rlim_vals = [0 40]; %[0 35];
        
        %% Generate the plots
        
        % Line plot + polar plot in the middle
        plot_line_plot_4dir_JH(n_reps, colour_reps, ylim_vals, rlim_vals, date_to_process, edge_or_bar)
        
        if save_figs == true
        
            for ii = 1:4

                if ii == 1
                    bar_cond = 'ON_100dps';
                elseif ii == 2
                    bar_cond = 'ON_20dps';
                elseif ii == 3
                    bar_cond = 'OFF_100dps';
                elseif ii == 4
                    bar_cond = 'OFF_20dps';
                end 
    
                f = gcf;
                % save as MATLAB fig
                savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.fig')))
                % save as PNG
                saveas(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.png')), 'png')
                close
    
                for jj = 1:4
    
                    f = gcf;
                    % save as MATLAB fig
                    savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '_', int2str(5-jj), '.fig')))
                    % save as PNG
                    saveas(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '_', int2str(5-jj), '.png')), 'png')
                    close
        
                end
            end 
        end
    end
end 
        
        
clear
