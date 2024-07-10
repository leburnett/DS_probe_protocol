%% Plot data from DS_probe_protocol - THIN BAR stimuli (2 pixel width - 3.75 VA) and EDGES

% Created by Burnett
% July 10th 2024
clear 
close all
clc

%% Initialise parameters that will change
date_str = '05_23_2024';
date_to_process = '05_23_2024'; % when there are subfolders set this to '06_18_2024_1' etc.
cell_type = 'TmY3';
project_folder = strcat('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/', cell_type);

% RUN THIS SCRIPT WITHIN THE DATE FOLDER. 
% Where the 'RES_all_reps...' file is found. 
date_folder = fullfile(project_folder, date_str);
cd(date_folder)

% Set this as true if you would like each repetition to be coloured in a
% different colour, or false if you would like them to all be grey. 
colour_reps = false;

% set save_figs to true if you would like to save the figures, or true if
% you just want to visualise them. 
save_figs = true; 

%% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

if save_figs == true
    save_path = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Results/Figures';

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

% else
%     % If subfolders exist
%     if numel(date_to_process) > 10 
% 
%         % Move into the subfolder
%         subfolder = fullfile(date_folder, date_to_process);
%         cd(subfolder)
% 
%     end 

end 

exp_folders = dir('SS*');
% Number of runs of the protocol:
n_reps = length(exp_folders);

%% 
ylim_vals = [-65 -30]; %[-65 -27];
rlim_vals = [0 30]; %[0 35];

%% % % % % % % % % % % % % % % % % Generate plots for EDGE stimulus % % % % % % % % % %

for edge_or_bar = "edge"
    
    % Line plot + polar plot in the middle
    plot_line_plot_4dir(n_reps, colour_reps, ylim_vals, rlim_vals, edge_or_bar)
    % 
    
    if save_figs == true
    
        % Save the figures:
    
        f = gcf;
        bar_cond = 'ON_100dps';
        % save as MATLAB fig
        savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.fig')))
        % save as PDF
        print(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.pdf')), '-dpdf', '-bestfit')
        saveas(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.pdf')), 'pdf')
        close
    
        % 
        f = gcf;
        bar_cond = 'ON_20dps';
        % save as MATLAB fig
        savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.fig')))
        % save as PDF
        print(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.pdf')), '-dpdf', '-bestfit')
        close
    
        % 
        f = gcf;
        bar_cond = 'OFF_100dps';
        % save as MATLAB fig
        savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.fig')))
        % save as PDF
        print(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.pdf')), '-dpdf', '-bestfit')
        close
    
        % 
        f = gcf;
        bar_cond = 'OFF_20dps';
        % save as MATLAB fig
        savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.fig')))
        % save as PDF
        print(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.pdf')), '-dpdf', '-bestfit')
        close
    end 
    
    
    %% ON - OFF combined
    
    % SLOW 
    % n_reps = 5;
    slow_or_fast = "slow";
    speed_str = '20dps'; 
    fig_str = strcat('ON-OFF-comb_', date_str,'_', speed_str, '_noREPS.fig');
    
    plot_bar_line_ON_OFF_comb_4dir(n_reps, slow_or_fast, ylim_vals, rlim_vals, edge_or_bar)
    
    if save_figs == true
        savefig(gcf, fullfile(fig_save_path, fig_str));
        saveas(gcf, fullfile(fig_save_path, fig_str(1:end-4)), 'pdf')
        close 
    end 
    
    %% FAST 
    
    % n_reps = 5;
    slow_or_fast = "fast";
    speed_str = '100dps';
    fig_str = strcat('ON-OFF-comb_', date_str,'_', speed_str, '_noREPS.fig');
    
    plot_bar_line_ON_OFF_comb_4dir(n_reps, slow_or_fast, ylim_vals, rlim_vals, edge_or_bar)
    
    if save_figs == true
        savefig(gcf, fullfile(fig_save_path, fig_str));
        saveas(gcf, fullfile(fig_save_path, fig_str(1:end-4)), 'pdf')
        close
    end 

end 

%% % % % % % % % % % % % % % % % % Generate plots for BAR stimulus % % % % % % % % % %

for edge_or_bar = "bar"
    
    % Line plot + polar plot in the middle
    plot_line_plot_4dir(n_reps, colour_reps, ylim_vals, rlim_vals, edge_or_bar)
    % 
    
    if save_figs == true
    
        % Save the figures:
    
        f = gcf;
        bar_cond = 'ON_100dps';
        % save as MATLAB fig
        savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.fig')))
        % save as PDF
        print(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.pdf')), '-dpdf', '-bestfit')
        saveas(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.pdf')), 'pdf')
        close
    
        % 
        f = gcf;
        bar_cond = 'ON_20dps';
        % save as MATLAB fig
        savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.fig')))
        % save as PDF
        print(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.pdf')), '-dpdf', '-bestfit')
        close
    
        % 
        f = gcf;
        bar_cond = 'OFF_100dps';
        % save as MATLAB fig
        savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.fig')))
        % save as PDF
        print(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.pdf')), '-dpdf', '-bestfit')
        close
    
        % 
        f = gcf;
        bar_cond = 'OFF_20dps';
        % save as MATLAB fig
        savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.fig')))
        % save as PDF
        print(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.pdf')), '-dpdf', '-bestfit')
        close
    end 
    
    
    %% ON - OFF combined
    
    % SLOW 
    % n_reps = 5;
    slow_or_fast = "slow";
    speed_str = '20dps'; 
    fig_str = strcat('ON-OFF-comb_', date_str,'_', speed_str, '_noREPS.fig');
    
    plot_bar_line_ON_OFF_comb_4dir(n_reps, slow_or_fast, ylim_vals, rlim_vals, edge_or_bar)
    
    if save_figs == true
        savefig(gcf, fullfile(fig_save_path, fig_str));
        saveas(gcf, fullfile(fig_save_path, fig_str(1:end-4)), 'pdf')
        close 
    end 
    
    %% FAST 
    
    % n_reps = 5;
    slow_or_fast = "fast";
    speed_str = '100dps';
    fig_str = strcat('ON-OFF-comb_', date_str,'_', speed_str, '_noREPS.fig');
    
    plot_bar_line_ON_OFF_comb_4dir(n_reps, slow_or_fast, ylim_vals, rlim_vals, edge_or_bar)
    
    if save_figs == true
        savefig(gcf, fullfile(fig_save_path, fig_str));
        saveas(gcf, fullfile(fig_save_path, fig_str(1:end-4)), 'pdf')
        close
    end 

end 


