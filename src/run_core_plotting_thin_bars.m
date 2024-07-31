%% Plot data from DS_probe_protocol - THIN BAR stimuli (2 pixel width - 3.75 VA) and EDGES

% Created by Burnett
% July 10th 2024
clear 
close all
clc

cd('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09');

% Set this as true if you would like each repetition to be coloured in a
% different colour, or false if you would like them to all be grey. 
colour_reps = false;

% set save_figs to true if you would like to save the figures, or true if
% you just want to visualise them. 
save_figs = false;

%% Read in log table with details of all of the experiments conducted. 

log_table = readtable('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/exp_recording_log.xlsx');
n_exps = height(log_table);

for exp = 1:n_exps
    
    stim = ["edge", "bar"];

    % Initialise parameters that will change
    date_str = log_table.date_str{exp}; %'05_28_2024';
    date_to_process = log_table.date_to_process{exp}; %'05_28_2024_2'; % when there are subfolders set this to '06_18_2024_1' etc.
    cell_type = log_table.cell_type{exp}; %'TmY3';
    project_folder = strcat('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/', cell_type);
        
    
    for stim_idx = 1:2
    
        edge_or_bar = stim(stim_idx);
        
        % RUN THIS SCRIPT WITHIN THE DATE FOLDER. 
        % Where the 'RES_all_reps...' file is found. 
        date_folder = fullfile(project_folder, date_str);
        cd(date_folder)
        
        %% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
        
        % if save_figs == true
            save_path = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Results/Figures/';
            if edge_or_bar == "edge"
                save_path = fullfile(save_path, edge_or_bar);
            elseif edge_or_bar == "bar"
                save_path = fullfile(save_path, "bar2");
            end 
        
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
        
        % end 
        
        exp_folders = dir('SS*');
        % Number of runs of the protocol:
        n_reps = length(exp_folders);
        
        %% 
        ylim_vals = [-65 -30]; %[-65 -27];
        rlim_vals = [0 30]; %[0 35];
        
        %% Generate the plots
        
        % Line plot + polar plot in the middle
        plot_line_plot_4dir(n_reps, colour_reps, ylim_vals, rlim_vals, date_to_process, edge_or_bar)
        
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
            end 

        end 
        
        
        %% ON - OFF combined
        
        % SLOW 
        % n_reps = 5;
        slow_or_fast = "slow";
        speed_str = '20dps'; 
        fig_str = strcat('ON-OFF-comb_', date_str,'_', speed_str, '_noREPS.fig');
        
        plot_bar_line_ON_OFF_comb_4dir(n_reps, slow_or_fast, ylim_vals, rlim_vals, date_to_process, edge_or_bar)
        
        if save_figs == true
            savefig(gcf, fullfile(fig_save_path, fig_str));
            saveas(gcf, fullfile(fig_save_path, fig_str(1:end-4)), 'png')
            close 
        end 
        
        %% FAST 
        
        % n_reps = 5;
        slow_or_fast = "fast";
        speed_str = '100dps';
        fig_str = strcat('ON-OFF-comb_', date_str,'_', speed_str, '_noREPS.fig');
        
        plot_bar_line_ON_OFF_comb_4dir(n_reps, slow_or_fast, ylim_vals, rlim_vals, date_to_process, edge_or_bar)
        
        if save_figs == true
            savefig(gcf, fullfile(fig_save_path, fig_str));
            saveas(gcf, fullfile(fig_save_path, fig_str(1:end-4)), 'png')
            close

        end 

    end 

end 

cd('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09');
clear
