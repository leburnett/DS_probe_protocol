% function plot_line_plot_8dir_all_reps(cell_type)

% Move through all of the experiment folders and read in the data.
% Save the data from all repetitions as a large overall matrix and plot
% this data. 

%% Read through all experiment folders. 
processed_data_folder = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/ProcessedData';

% Move into the appropriate results folder for the cell type
cell_type_folder = fullfile(processed_data_folder, string(cell_type));
cd(cell_type_folder)

% Find the results files within the folder
res_files = dir('RES_all_reps*');
n_results_files = length(res_files);

for idx = 1:n_results_files

    % Load the processed data
    load(res_files(idx).name, 'data_all_reps')
    n_reps = size(data_all_reps, 3);

    % For the 4 different conditions (on-slow, on-fast, off-slow, off-fast)
    for cond_n = 1:4

        if cond_n == 1
            % OFF - 20 dps
            values = [13, 21, 6, 17, 14, 22, 5, 18];
        elseif cond_n == 2
            % OFF - 100 dps
            values = [15, 23, 8, 19, 16, 24, 7, 20];
        elseif cond_n == 3
            % ON - 20 dps
            values = [108, 116, 101, 112, 109, 117, 100, 113];
        elseif cond_n == 4
            % ON - 100 dps
            values = [110, 118,103, 114, 111, 119, 101, 115];
        end 

        for j = 1:8
        
            ang_idx = values(j);
            voltage_data = squeeze(data_all_reps(ang_idx, 3, 1:n_reps));

            % 1 - find the minimum length of one rep, to be able to
            % concatenate all reps together. 
            min_len = 1000000;
            for k = 1:n_reps
                dd = voltage_data{k};
                len_dd = length(dd);
                if len_dd<min_len
                    min_len = len_dd;
                end 
            end 
        
            % Collect voltage data from across the repetitions. 
            data_comb = zeros(n_reps, min_len);
            for k = 1:n_reps
                da = voltage_data{k};
                data_comb(k, :) = da(1:min_len);
            end 
            
            % Find the average response over the repetitions for each
            % direction. 
            av_resp = mean(data_comb);
            av_resp_comb(cond_n, idx, j, :) = {av_resp}; 
        end

    end 
   
end 


% ON - 20 dps
a = squeeze(av_resp_comb(3, :, :));
% In 'a' - rows = repetitions, columns = angles. 

for angle_value = 1:8 
    bb = a(:, angle_value);
    
    figure;
    for jj = 1:8
        plot(bb{jj}, 'Color', [0.7 0.7 0.7]); hold on
    end 
    
    % plot average 
    mean_vals = nan(8, 100000);
    for jjj= 1:8
        data = bb{jjj};
        len_data = numel(data);
        mean_vals(jjj, 1:len_data) = data;
    end 
    c = nanmean(mean_vals);
    hold on; plot(c, 'k', 'LineWidth', 3)
end 






% 
%     angls = 0:45:315;
%     % angls(9) = angls(1);
%     % angls = deg2rad(angls); 
% 
%     for plot_n = 1:4
%         figure
%         if plot_n == 1
%             % % % OFF
%             % 20 dps
%             values = [13, 21, 6, 17, 14, 22, 5, 18];
%         elseif plot_n == 2
%             % 100 dps
%             values = [15, 23, 8, 19, 16, 24, 7, 20];
%         elseif plot_n == 3
%             % % % ON
%             % 20 dps
%             values = [108, 116, 101, 112, 109, 117, 100, 113];
%         elseif plot_n == 4
%             % 100 dps
%             values = [110, 118, 103, 114, 111, 119, 101, 115];
%         end 
% 
%         % Find baseline voltage across all reps and all conditions of the bar
%         % stimulus. 
%         % all_voltage_data = squeeze(data_all_reps(values, 3, 1:n_reps));
%         % all_voltage_data = horzcat(all_voltage_data{:}); % reshape and unpack values in cell arrays. 
%         % exp_baseline = median(all_voltage_data);
% 
%         for j = 1:8
%             subplot(4, 2, j)
% 
%             idx = values(j);
%             voltage_data = squeeze(data_all_reps(idx, 3, 1:n_reps));
%             % Find the shortest length of a rep. 
%             min_len = 1000000; % use 1000000 as a baseline. 
%             for k = 1:n_reps
%                 dd = voltage_data{k};
%                 len_dd = length(dd);
%                 if len_dd<min_len
%                     min_len = len_dd;
%                 end 
%             end 
% 
%             % Collect voltage data from across the repetitions. 
%             data_comb = zeros(n_reps, min_len);
%             % For each rep, extract the relevant voltage data.
%             for k = 1:n_reps
%                 da = voltage_data{k};
%                 data_comb(k, :) = da(1:min_len);
%             end 
%             av_resp = mean(data_comb);
% 
%             % PLOT REPS
%             for ii = 1:n_reps
%                 if ii == 1
%                     col = 'r';
%                 elseif ii == 2
%                     col = [1, 0.71, 0.76];
%                 elseif ii == 3
%                     col = [0.68, 0.85, 0.9];
%                 elseif ii == 4
%                     col = 'b';
%                 elseif ii == 5
%                     col = [0.6 0.6 0.6];
%                 end 
%                 plot(data_comb(ii, :), 'Color', col, 'LineWidth', 0.6); hold on
%                 ylim([-65 -20])
%                 box off 
%                 ax = gca;
%                 ax.TickDir = 'out';                
%             end 
% 
%             % PLOT AVERAGE 
%             plot(av_resp, 'Color', 'k', 'LineWidth', 2.5)
% 
%             title(angls(j))
%         end
% 
%         if plot_n == 1
%             sgtitle('OFF - 20 dps') 
%         elseif plot_n == 2
%             sgtitle('OFF - 100 dps') 
%         elseif plot_n == 3
%             sgtitle('ON - 20 dps') 
%         elseif plot_n == 4
%             sgtitle('ON - 100 dps') 
%         end 
% 
%         f = gcf;
%         f.Position = [563   428   468   619];
%     end 
% 
% end
% 
% 
% % f = gcf;
% % f.Position = [440   303   842   744];






