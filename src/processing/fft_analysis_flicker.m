function fft_analysis_flicker(n_reps, date_str, save_path)
% Generate plots of FFT amplitude analysis for responses to the flicker
% stimulus.
% Uses average response across all reps for one cell. 

res_files = dir('RES_all_reps*');
load(res_files(1).name, 'data_all_reps')
date_str = strrep(date_str, '_', '-');

stim_freq_all = {'0.5Hz', '1Hz', '4Hz', '8Hz', '16Hz', '32Hz', '64Hz'};
   
values = [89, 90, 91, 92, 93, 94, 95];

data_rate = 20000;

pk_data_all = zeros(5, 14);
freq_ampl = zeros(3, 7);

for j = 1:7 % 7 speeds 

            if j == 1
                av_col = [0.6, 0.0, 0.5];
            elseif j == 2
                av_col = [0, 0, 0.5];
            elseif j == 3
                av_col = [0.58, 0.75, 0.8];
            elseif j == 4
                av_col = [0.13, 0.55, 0.13];
            elseif j == 5
                av_col = [1, 0.65, 0.7];
            elseif j == 6
                av_col = [1, 0.65, 0];
            elseif j == 7
                av_col = [1, 0, 0];
            end 

            idx = values(j);
            stim_freq = stim_freq_all{j};

            voltage_data = squeeze(data_all_reps(idx, 3, 1:n_reps));

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

            % For each rep, extract the relevant voltage data.
            for k = 1:n_reps
                da = voltage_data{k};
                data_comb(k, :) = da(1:min_len);
            end 

            av_resp = mean(data_comb);

        % FFT ampl analysis 
        [pk_data, amp_freq, loc_freq] = find_peak_freq_amp(av_resp, data_rate, stim_freq, av_col);
    
        if ~isempty(pk_data)
            pk_data_all(:, j*2-1:j*2) = pk_data(1:5, :);
        end 

        pk_data_all_tbl = array2table(pk_data_all, 'VariableNames', {'05_amp', '05_loc', '1_amp', '1_loc', '4_amp', '4_loc', '8_amp', '8_loc', '16_amp', '16_loc', '32_amp', '32_loc', '64_amp', '64_loc'});

       freq_ampl(1, j) = str2double(stim_freq(1:end-2));
       freq_ampl(2, j) = loc_freq;
       freq_ampl(3, j) = amp_freq;

       save(fullfile(save_path, strcat(date_str, '_fft_freq_analysis.mat')), 'pk_data_all_tbl', 'freq_ampl');
end 























end 