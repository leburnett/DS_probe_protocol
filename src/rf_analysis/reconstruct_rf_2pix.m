% Predict RF from 2 pixel bar stimulus 
% Jin Yong's recordings - Summer 2024

res_files = dir('RES_all_reps*');
load(res_files(1).name, 'data_all_reps')
date_str = strrep(date_str, '_', '-');

n_reps = 5;
% Patterns
pattern_path = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/Patterns';
% functions_path = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/Functions';

% Don't need the functions - just need the frame positon from the processed
% data and the patterns. 
% idx = 1;
% pat_shown = pattern.Pats(:, :, idx);

values = [9, 2 ,10, 1];

pattern_names = {'0011_2pix_V_1bar_4bkg_G4.mat', '0042_2pix_H_bar_1bar_4bkg_G4.mat'};

%  9 = 0011_2pix_V_1bar_4bkg_G4 - pos fn = 0001
%  2 = 0042_2pix_H_bar_1bar_4bkg)G4 - pos fn = 0188
%  10 = 0011_2pix_V_1bar_4bkg_G4 - pos fn = 0002
%  1 = 0042_2pix_H_bar_1bar_4bkg - pos fn = 0187

if plot_n == 1
    % % % OFF
    % 20 dps
    values = [9, 2 ,10, 1];

elseif plot_n == 2
    % 100 dps
    values = [11, 4, 12, 3];
elseif plot_n == 3
    % % % ON
    % 20 dps
    values = [104, 97, 105, 96];
elseif plot_n == 4
    % 100 dps
    values = [106, 99, 107, 98];
end 

pattern_1 = load(fullfile(pattern_path, pattern_names{1}), 'pattern');
pattern_2 = load(fullfile(pattern_path, pattern_names{2}), 'pattern');

% Exp baseline to then
all_voltage_data = squeeze(data_all_reps(values, 3, 1:n_reps));
all_voltage_data = vertcat(all_voltage_data{:}); % reshape and unpack values in cell arrays. 
exp_baseline = nanmedian(all_voltage_data)*10;

% Empty array to add frame data to, to get RF.
rf_data = zeros(48, 192);
n_f_total = 0;

for j = 1:4
    disp(strcat('Stim number: ', string(j)))
    idx = values(j);

    if j == 1 || j == 3
        pattern = pattern_1.pattern;
    else
        pattern = pattern_2.pattern;
    end

    % Sort the voltage and the frame positon data
    voltage_data = squeeze(data_all_reps(idx, 3, 1:n_reps));
    frame_data = squeeze(data_all_reps(idx, 2, 1:n_reps));

    % Go through the repetitions
    for k = 1:n_reps
        disp(strcat('Rep number: ', string(k)))
        % Normalise voltage data to be between 1 and -1. 
        v_data = voltage_data{k, :}*10;
        v_data = v_data(~isnan(v_data));
        v_norm = v_data - exp_baseline;

        f_data = frame_data{k, :};
        n_frames_rep = numel(v_data);
        n_f_total = n_f_total + n_frames_rep;

        for kk = 1:n_frames_rep

            frame_pos = f_data(kk);
            v_val = v_norm(kk);

            % Update in future....................
            if isnan(frame_pos) %|| frame_pos == 0 
                frame_pos = 0; %1;
            end 

            if frame_pos+1 > size(pattern.Pats, 3)
                frame_pos = size(pattern.Pats, 3)-1;
            end 

            f = pattern.Pats(:, :, frame_pos+1);
            % min_val = min(squeeze(min(min(pattern.Pats))));
            % max_val = max(squeeze(max(max(pattern.Pats))));
            % Normalised frame image from 0 to 1. 
            % f_norm = (f - min_val) ./ (max_val - min_val);
            f_norm = mat2gray(f);

            rf_data = rf_data+ (f_norm * v_val);
        end 
    end 
end 

rf_data_av = rf_data/n_f_total;


























