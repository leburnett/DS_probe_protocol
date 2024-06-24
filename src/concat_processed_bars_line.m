function concat_processed_bars_line(cell_type)

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
                values = [110, 118,103, 114, 111, 119, 102, 115];
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
    save(fullfile(strcat('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/ProcessedData/', cell_type), 'ALL_RES_av_res_comb.mat'), 'av_resp_comb');

end 



