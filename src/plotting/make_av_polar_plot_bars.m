function make_av_polar_plot_bars(cell_type, cond_val)
    
% Generate a polar plot from the average responses of all the cells
% recorded. 

% Inputs
% 'cond_val' - whcih condition to plot for. 
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
    % Plot POLAR PLOT:

    angls = 0:45:315;
    angls(9) = angls(1);
    angls = deg2rad(angls); 

    polar_vals_reps = zeros(n_reps, 8);

    figure
    for rep_n = 1:n_reps

        all_angles_for_cell = a(rep_n, :);
        baseline_per_rep =  median(cell2mat(all_angles_for_cell));

        for angle_value = 1:8 
            % Max per angle for each cell. 
            bb = a{rep_n, angle_value};
            max_rep = max(bb);
            pol_val = diff([baseline_per_rep, max_rep]);
            polar_vals_reps(rep_n, angle_value)= pol_val;
        end 
        
        polar_vals_reps(:, 9) = polar_vals_reps(:, 1);
        % Plot polar plot for each cell
        polarplot(angls, polar_vals_reps(rep_n, :), 'Color', [0.8 0.8 0.8], 'LineWidth', 1.2);
        hold on
    end 
    
    % Plot polar plot for average across all cells
    polar_vals_av = mean(polar_vals_reps);
    polarplot(angls, polar_vals_av, 'Color', 'k', 'LineWidth', 3)
    rlim([0 30])
    thetaticks([0, 45, 90, 135, 180, 225, 270, 315])
    ax = gca;
    ax.FontSize = 15;

    if cond_val == 1
        title(strcat(cell_type, ' - OFF - 20 dps')) 
    elseif cond_val == 2
        title(strcat(cell_type, ' - OFF - 100 dps')) 
    elseif cond_val == 3
        title(strcat(cell_type, ' - ON - 20 dps')) 
    elseif cond_val == 4
        title(strcat(cell_type, ' - ON - 100 dps')) 
    end 

    f = gcf; 
    f.Position = [620   555   439   412];
end 



