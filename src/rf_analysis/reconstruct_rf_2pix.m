% Predict RF from 2 pixel bar stimulus 
% Jin Yong's recordings - Summer 2024

% OFF 
%  9 = 0011_2pix_V_1bar_4bkg_G4 - pos fn = 0001
%  2 = 0042_2pix_H_bar_1bar_4bkg)G4 - pos fn = 0188
%  10 = 0011_2pix_V_1bar_4bkg_G4 - pos fn = 0002
%  1 = 0042_2pix_H_bar_1bar_4bkg - pos fn = 0187


%% use AVERAGED voltage data and find the average voltage

% Load the processed data 
res_files = dir('RES_all_reps*');
load(res_files(1).name, 'data_all_reps')

n_reps = size(data_all_reps, 3);

% Patterns
pattern_path = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/Patterns';
% functions_path = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/Functions';

% Don't need the functions - just need the frame positon from the processed
% data and the patterns. 
% idx = 1;
% pat_shown = pattern.Pats(:, :, idx);

pattern_names = {'0011_2pix_V_1bar_4bkg_G4.mat'...
    , '0042_2pix_H_bar_1bar_4bkg_G4.mat'...
    , '0013_2pix_V_12bar_4bkg_G4.mat'...
    , '0044_2pix_H_bar_12bar_4bkg_G4.mat'};

rf_data_all = zeros(48, 192);

for plot_n = 1:4

    if plot_n == 1
        % % % OFF
        % 20 dps
        values = [9, 2 ,10, 1];
        title_str = '20 dps - OFF - 2 pixel bar';
    elseif plot_n == 2
        % OFF
        % 100 dps
        values = [11, 4, 12, 3];
        title_str = '100 dps - OFF - 2 pixel bar';
    elseif plot_n == 3
        % % % ON
        % 20 dps
        values = [104, 97, 105, 96];
        title_str = '20 dps - ON - 2 pixel bar';
    elseif plot_n == 4
        % ON 
        % 100 dps
        values = [106, 99, 107, 98];
        title_str = '100 dps - ON - 2 pixel bar';
    end 
    
    if plot_n <= 2
        pattern_1 = load(fullfile(pattern_path, pattern_names{1}), 'pattern'); % V bar
        pattern_2 = load(fullfile(pattern_path, pattern_names{2}), 'pattern'); % H bar
    elseif plot_n > 2
        pattern_1 = load(fullfile(pattern_path, pattern_names{3}), 'pattern'); % V bar
        pattern_2 = load(fullfile(pattern_path, pattern_names{4}), 'pattern'); % H bar
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
    
        if j == 1 || j == 3 % vertical bar - horizontal movement;
            pattern = pattern_1.pattern;
        else % horizontal bar - vertical movement;
            pattern = pattern_2.pattern;
        end
    
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
title(save_str)











































