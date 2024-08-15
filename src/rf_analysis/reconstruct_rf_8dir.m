function reconstruct_rf_8dir(cell_type, date_str)
% Predict RF from 6 pixel bar stimulus 
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
        values = [13, 21, 6, 17, 14, 22, 5, 18];
        title_str = strcat('20 dps - OFF - bar6 - ', cell_type, ' - ', date_str);
    elseif plot_n == 2
        % OFF 100 dps
        values = [15, 23, 8, 19, 16, 24, 7, 20];
        title_str = strcat('100 dps - OFF - bar6 - ', cell_type, ' - ', date_str);
    elseif plot_n == 3
        % % % ON 20 dps
        values = [108, 116, 101, 112, 109, 117, 100, 113];
        title_str = strcat('20 dps - ON - bar6 - ', cell_type, ' - ', date_str);
    elseif plot_n == 4
        % ON 100 dps
        values = [110, 118,103, 114, 111, 119, 102, 115];
        title_str = strcat('100 dps - ON - bar6 - ', cell_type, ' - ', date_str);
    end 
    
    % Exp baseline to then
    all_voltage_data = squeeze(data_all_reps(values, 3, 1:n_reps));
    all_voltage_data = vertcat(all_voltage_data{:}); % reshape and unpack values in cell arrays. 
    exp_baseline = nanmedian(all_voltage_data);
    

    %% Empty array to add frame data to, to get SPATIAL RF.
    rf_data = zeros(48, 192);
    
    % Loop through the 8 directions for this stimulus. 
    for j = 1:8
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
    
        % Remove the first 250ms and last 125ms.
        av_resp = av_resp(5000:end-2500);
        av_frame = av_frame(5000:end-2500);
    
        av_resp = av_resp(~isnan(av_resp));
        % Could also remove 200ms at the end....
    
        % Can't have 'frame 0'... should check where this comes from and why. 
        % Check to see if I should add 1 to each frame position. 
        av_frame(av_frame==0)=1;
        av_frame= av_frame(~isnan(av_frame));
    
        % Aim is to reduce the number of loops I have to compute for. 
        % The same frame is being presented for many timepoints.
        % Find the frame being presented and find an average for the time over
        % which the frame is being presented. 
        frame_changes = find(abs(diff(av_frame))>0);
        % frame delta t - see what the RF would be like if you used the
        % next frame instead.
        f_dt = 0;
    
        % Computed per FRAME CHANGE (group all frames with the same image
        % being shown)
        for fc = 1:numel(frame_changes)

            % voltage data
            if fc < abs(f_dt)+1
                v_data = av_resp(1:frame_changes(1));
            elseif fc >= numel(frame_changes)-f_dt
                v_data = av_resp(frame_changes(fc):end);
            else
                v_data = av_resp(frame_changes(fc+f_dt):frame_changes(fc+f_dt)+1);
            end 

            % Find the average voltage over the time this frame was being
            % presented.
            v_mean = nanmean(v_data);

            % What frame was being shown during this time? 
            f_data = pattern.Pats(:, :, av_frame(frame_changes(fc)));
            f_norm = mat2gray(f_data);
            if plot_n <= 2 % OFF BAR - flip so that plots are bright for positive responses. 
                f_norm = double(~f_norm);
            end 
            f_norm(f_norm==0)=-1;

            rf_data = rf_data + (f_norm * v_mean);
            rf_data_all = rf_data_all  + (f_norm * v_mean); 
        end 

        % % Computed per 20kHz sampling frame. 
        % for f = 1:numel(av_resp) % through all data points
        %    v_val = av_resp(f);
        %    f_data = pattern.Pats(:, :, av_frame(f));
        %    f_norm = mat2gray(f_data);
        %    f_norm(f_norm==0)=-1;
        % 
        %    rf_data = rf_data + (f_norm * v_val);
        %    rf_data_all = rf_data_all  + (f_norm * v_val);
        % end 
    
    end 
    
    % % Plot figure for each type of stimulus.
    % % Flip image to be seen as if from fly view. Arena mounted
    % % upside down. 
    figure; imagesc(flipud(rf_data))
    title(title_str)
    box off
    % colormap(redblue)
    colorbar
    ax = gca;
    ax.TickDir = 'out';

end 

% figure; imagesc(flipud(rf_data_all))
% comb_title = strcat('RF est - - bar6 - ', cell_type, ' - ', date_str, 'f-dt - ', string(f_dt));
% title(comb_title)
% box off
% colorbar
% ax = gca;
% ax.TickDir = 'out';
% colormap(redblue)


end 











































