function make_av_line_plot_bars(cell_type, cond_val)
    
% Generate a line plot from the average responses of all the cells
% recorded. 

% Inputs
% 'cond_val' - which condition to plot for. 
% 1 - OFF 20 dps
% 2 - OFF - 100 dps
% 3 - ON 20 dps
% 4 - ON - 100 dps

    % Move into the correct directory:
    processed_data_folder = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/ProcessedData';
    folder_to_look_in = fullfile(processed_data_folder, cell_type);
    cd(folder_to_look_in)
    
    % Load the file with the data from all cells
    av_resp_file = dir('ALL_RES*');
    load(fullfile(av_resp_file(1).folder, av_resp_file(1).name), 'av_resp_comb')

    % Load the relevant data for the relevant condition. 
    % In 'a' - rows = repetitions, columns = angles. 
    a = squeeze(av_resp_comb(cond_val, :, :));
    n_reps = size(a, 1);

    subplot_values = [15, 9, 3, 7, 11, 17, 23, 19];

    figure
    
    for angle_value = 1:8 
        
        subplot(5,5,subplot_values(angle_value))
        
        % Combine data from all cells
        mean_vals = nan(n_reps, 1000000);

        for rep_value = 1:n_reps
            bb = a{rep_value, angle_value};

            len_data = numel(bb);
            mean_vals(rep_value, 1:len_data) = bb;

            plot(bb, 'Color', [0.7 0.7 0.7]); hold on
        end 

        data_all_cells = mean(mean_vals);
        hold on; plot(data_all_cells, 'k', 'LineWidth', 3)
        box off
        ylim([-65 -25])
        ax = gca;
        ax.TickDir = 'out';
        ax.LineWidth = 1; 
    end 

    f = gcf;
    f.Position = [236 74 1124 973];

    end 

