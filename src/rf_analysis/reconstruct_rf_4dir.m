function reconstruct_rf_4dir(edge_or_bar, cell_type, date_str)
% Predict RF from 2 pixel bar stimulus 
% Jin Yong's recordings - Summer 2024

% Load the protocol details:
load('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Protocol_details.mat', 'block_trials');

% Load the processed data 
res_files = dir('RES_all_reps*');
load(res_files(1).name, 'data_all_reps')

n_reps = size(data_all_reps, 3);
date_str = strrep(date_str, '_', '-');

% Patterns
pattern_path = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/Patterns';

rf_data_all = zeros(48, 192);

for plot_n = 1:4

    if plot_n == 1
        % % % OFF 20 dps
        if edge_or_bar == "bar"
            values = [9, 2 ,10, 1];
        elseif edge_or_bar == "edge"
            values = [25, 29, 26, 30];
        end
        title_str = strcat('20 dps - OFF - ', edge_or_bar, ' - ', cell_type, ' - ', date_str);
    elseif plot_n == 2
        % OFF 100 dps
        if edge_or_bar == "bar"
                values = [11, 4, 12, 3];
        elseif edge_or_bar == "edge"
            values = [27, 31, 28, 32];
        end
        title_str = strcat('100 dps - OFF - ', edge_or_bar, ' - ', cell_type, ' - ', date_str);
    elseif plot_n == 3
        % % % ON 20 dps
        if edge_or_bar == "bar"
                values = [104, 97, 105, 96];
        elseif edge_or_bar == "edge"
            values = [120, 124, 121, 125];
        end
        title_str = strcat('20 dps - ON - ', edge_or_bar, ' - ', cell_type, ' - ', date_str);
    elseif plot_n == 4
        % ON 100 dps
        if edge_or_bar == "bar"
            values = [106, 99, 107, 98];
        elseif edge_or_bar == "edge"
            values = [122, 126, 123, 127];
        end 
        title_str = strcat('100 dps - ON - ', edge_or_bar, ' - ', cell_type, ' - ', date_str);
    end 
    
    % Exp baseline to then
    all_voltage_data = squeeze(data_all_reps(values, 3, 1:n_reps));
    all_voltage_data = vertcat(all_voltage_data{:}); % reshape and unpack values in cell arrays. 
    exp_baseline = nanmedian(all_voltage_data);
    
    % Empty array to add frame data to, to get RF.
    rf_data = zeros(48, 192);
    
    % Loop through the 4 directions for this stimulus. 
    for j = 1:4
        % disp(strcat('Stim number: ', string(j)))
        idx = values(j);
    
        % Load the appropriate pattern. 
        pat_file = block_trials{idx, 2};
        load(fullfile(pattern_path, pat_file), 'pattern');
    
        % Sort the voltage and the frame positon data
        voltage_data = squeeze(data_all_reps(idx, 3, 1:n_reps));
        frame_data = squeeze(data_all_reps(idx, 2, 1:n_reps));
    
        % Find the shortest length of a rep. 
        min_len = 1000000; % use 1000000 as a baseline. 
        for k = 1:n_reps
            dd = voltage_data{k};
            len_dd = length(dd);
            if len_dd<min_len
                min_len = len_dd;
            end 
        end
    
        % Collect voltage data from across the repetitions. 
        data_comb = zeros(n_reps, min_len);
        frame_comb = zeros(n_reps, min_len);
        
        % For each rep, extract the relevant voltage data.
        for k = 1:n_reps
            da = voltage_data{k};
            fa = frame_data{k};
            data_comb(k, :) = da(1:min_len);
            frame_comb(k, :) = fa(1:min_len);
        end
        
        av_resp = nanmean(data_comb);
        % Normalise response to baseline. 
        av_resp = av_resp - exp_baseline;
    
        av_frame = ceil(nanmean(frame_comb)); % Make sure there are no floating values
    
        % Remove the first 250ms
        av_resp = av_resp(5000:end-2500);
        av_frame = av_frame(5000:end-2500);
    
        % Could also remove 200ms at the end....
    
        % Can't have 'frame 0'... should check where this comes from and why. 
        av_frame(av_frame==0)=1;
    
        % Aim is to reduce the number of loops I have to compute for. 
        % The same frame is being presented for many timepoints.
        % Find the frame being presented and find an average for the time over
        % which the frame is being presented. 
        frame_changes = find(abs(diff(av_frame))>0);
    
        for fc = 1:numel(frame_changes)
    
            % voltage data
            if fc == 1
                v_data = av_resp(1:frame_changes(1));
            elseif fc == numel(frame_changes)
                v_data = av_resp(frame_changes(fc):end);
            else
                v_data = av_resp(frame_changes(fc):frame_changes(fc)+1);
            end 
    
            % Find the average voltage over the time this frame was being
            % presented.
            v_mean = nanmean(v_data);
    
            % What frame was being shown during this time? 
            f_data = pattern.Pats(:, :, av_frame(frame_changes(fc)));
            f_norm = mat2gray(f_data);
            % if plot_n <= 2 % OFF BAR - flip so that plots are bright for positive responses. 
            %     f_norm = f_norm*-1;
            % end 
            f_norm(f_norm==0)=-1;
    
            rf_data = rf_data + (f_norm * v_mean);
            rf_data_all = rf_data_all  + (f_norm * v_mean);
        end 
    
    end 
    
    % Plot figure; Flip image to be seen as if from fly view. Arena mounted
    % upside down. 
    figure; imagesc(flipud(rf_data))
    title(title_str)

end 

figure; imagesc(flipud(rf_data_all))
comb_title = strcat('RF est - - ', edge_or_bar, ' - ', cell_type, ' - ', date_str);
title(comb_title)

end 











































