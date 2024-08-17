%% Plot data from DS_probe_protocol
% Created by Burnett

clear 
close all
clc

addpath 'C:\Users\hoellerj\Documents\GitHub\DS_probe_protocol\src\processing'
addpath 'C:\Users\hoellerj\Documents\GitHub\DS_probe_protocol\src\plotting'

stim_names = ["bar6" "gratings" "bar2" "edge" "flashes"];

%% Read in log table with details of all of the experiments conducted. 
git_folder = 'C:\Users\hoellerj\Documents\GitHub\DS_probe_protocol\results\';
log_table = readtable(strcat(git_folder, 'exp_recording_log_JH.xlsx'));
n_exps = height(log_table);

%% load data
% cd('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09');
data_folder0 = 'O:\Burnett\Jinyong\DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09\';
data_folder = 'O:\Burnett\Jinyong\DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09\ProcessedData2\';

% Set this as true if you would like each repetition to be coloured in a
% different colour, or false if you would like them to all be grey. 
colour_reps = false;

% set save_figs to true if you would like to save the figures, or true if
% you just want to visualise them. 
save_figs = true;

for exp = 22:n_exps

    % Initialise parameters that will change
    date_str = log_table.date_str{exp}; %'05_28_2024';
    date_to_process = log_table.date_to_process{exp}; %'05_28_2024_2'; % when there are subfolders set this to '06_18_2024_1' etc.
    cell_type = log_table.cell_type{exp}; %'TmY3';

    % RUN THIS SCRIPT WITHIN THE DATE FOLDER. 
    % Where the 'RES_all_reps...' file is found. 
    date_folder = fullfile(data_folder, cell_type);
    cd(date_folder)
    
    % Number of runs of the protocol:
    if date_to_process(end-1)=='_'
        exp_folders = dir(strcat(data_folder0, date_str, '\', date_to_process(end), '\SS*'));
    else
        exp_folders = dir(strcat(data_folder0, date_str, '\SS*'));
    end
    n_reps = length(exp_folders);
    
    %% 
    ylim_vals = [-70 -20]; %[-65 -30];
    rlim_vals = [0 40]; %[0 35];
    
    %% 6px bar stimuli
    plot_line_plot_8dir_JH(n_reps, colour_reps, ylim_vals, rlim_vals, date_to_process)

    if save_figs == true
        % create folder to save figures
        fig_save_path = fullfile(strcat(git_folder, 'bar6/', cell_type, '/', date_str));
        if date_to_process(end-1)=='_'
            fig_save_path = fullfile(strcat(fig_save_path, '/', date_to_process));
        end
        if ~isfolder(fig_save_path)
            mkdir(fig_save_path)
        end 
        %loop through figures
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
            for jj = 1:8
                f = gcf;
                % save as MATLAB fig
                savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '_', int2str(9-jj), '.fig')))
                % save as PNG
                saveas(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '_', int2str(9-jj), '.png')), 'png')
                close
            end
        end 
    end 

    %% gratings
    plot_line_plot_8dir_gratings_JH(n_reps, colour_reps, ylim_vals, rlim_vals, date_to_process)    
    if save_figs == true
        % create folder to save figures
        fig_save_path = fullfile(strcat(git_folder, 'gratings/', cell_type, '/', date_str));
        if date_to_process(end-1)=='_'
            fig_save_path = fullfile(strcat(fig_save_path, '/', date_to_process));
        end
        if ~isfolder(fig_save_path)
            mkdir(fig_save_path)
        end 
        %loop through figures
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
            for jj = 1:8
                f = gcf;
                % save as MATLAB fig
                savefig(fullfile(fig_save_path, strcat('Line_plot_per_speed_', bar_cond,'_', cell_type, '_', date_str, '_', int2str(9-jj), '.fig')))
                % save as PNG
                saveas(f, fullfile(fig_save_path, strcat('Line_plot_per_speed_', bar_cond,'_', cell_type, '_', date_str, '_', int2str(9-jj), '.png')), 'png')
                close
            end
        end 
    end 

    %% 2px thin bars
    plot_line_plot_4dir_JH(n_reps, colour_reps, ylim_vals, rlim_vals, date_to_process, 'bar') 
    if save_figs == true
        % create folder to save figures
        fig_save_path = fullfile(strcat(git_folder, 'bar2/', cell_type, '/', date_str));
        if date_to_process(end-1)=='_'
            fig_save_path = fullfile(strcat(fig_save_path, '/', date_to_process));
        end
        if ~isfolder(fig_save_path)
            mkdir(fig_save_path)
        end 
        %loop through figures
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

    %% edge
    plot_line_plot_4dir_JH(n_reps, colour_reps, ylim_vals, rlim_vals, date_to_process, 'edge') 
    if save_figs == true
        % create folder to save figures
        fig_save_path = fullfile(strcat(git_folder, 'edge/', cell_type, '/', date_str));
        if date_to_process(end-1)=='_'
            fig_save_path = fullfile(strcat(fig_save_path, '/', date_to_process));
        end
        if ~isfolder(fig_save_path)
            mkdir(fig_save_path)
        end 
        %loop through figures
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

    %% flash
    plot_line_plot_7speeds_flicker_JH(n_reps, colour_reps, ylim_vals, date_to_process) 
    if save_figs == true
        % create folder to save figures
        fig_save_path = fullfile(strcat(git_folder, 'flashes/', cell_type, '/', date_str));
        if date_to_process(end-1)=='_'
            fig_save_path = fullfile(strcat(fig_save_path, '/', date_to_process));
        end
        if ~isfolder(fig_save_path)
            mkdir(fig_save_path)
        end 
        %loop through figures
        for ii = 1:7
            if ii == 1
                bar_cond = 'flashes-64Hz';
            elseif ii == 2
                bar_cond = 'flashes-32Hz';
            elseif ii == 3
                bar_cond = 'flashes-16Hz';
            elseif ii == 4
                bar_cond = 'flashes-08Hz';
            elseif ii == 5
                bar_cond = 'flashes-04Hz';
            elseif ii == 6
                bar_cond = 'flashes-01Hz';
            elseif ii == 7
                bar_cond = 'flashes-005Hz';
            end 
            f = gcf;
            % save as MATLAB fig
            savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.fig')))
            % save as PNG
            saveas(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_str, '.png')), 'png')
            close
        end 
    end     

end 

clear
