clear 
close all
clc

%converts seconds to microseconds (TDMS timestamps are in micros)
time_conv = 1000000;

%% load data
git_folder = 'C:\Users\hoellerj\Documents\GitHub\DS_probe_protocol\results\';
log_table = readtable(strcat(git_folder, 'exp_recording_log_JH.xlsx'));

exp = 25;
date_str = log_table.date_str{exp}; %'05_28_2024';
date_to_process = log_table.date_to_process{exp}; %'05_28_2024_2'; 
cell_type = log_table.cell_type{exp}; %'TmY3';
sprintf(date_to_process)

data_folder0 = 'O:\Burnett\Jinyong\DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09\';
data_folder = 'O:\Burnett\Jinyong\DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09\ProcessedData2\';
if date_to_process(end-1)=='_'
    exp_folders = dir(strcat(data_folder0, date_str, '\', date_to_process(end), '\SS*'));
else
    exp_folders = dir(strcat(data_folder0, date_str, '\SS*'));
end
n_reps = length(exp_folders);
n_half = floor(n_reps/2);
date_folder = fullfile(data_folder, cell_type);

res_files = dir(strcat(date_folder,'\','RES_all_reps*'));
i0 = -1;
for i=1:length(res_files)
    if contains(res_files(i).name, date_to_process)
        i0 = i;
    end
end
load(strcat(res_files(i0).folder, '\', res_files(i0).name), 'data_all_reps')

%% find data across repetitions for each stimulus
voltage_data = squeeze(data_all_reps(1:end, 3, 1:n_reps));
frame_data = squeeze(data_all_reps(1:end, 2, 1:n_reps));
time_data = squeeze(data_all_reps(1:end, 1, 1:n_reps));

% Find the shortest length of a rep. 
n_stim = 127;
min_len0 = 1000000; % use as a baseline. 
min_len_per_stim =  zeros(n_stim);
data_comb = zeros(n_stim, n_reps, min_len0);
frame_comb = zeros(n_stim, n_reps, min_len0);
time_comb = zeros(n_stim, n_reps, min_len0);
av_resp = zeros(n_stim, min_len0);
av_frame = zeros(n_stim, min_len0);
av_time = zeros(n_stim, min_len0);
av_resp_mean = zeros(n_stim,1);
av_resp_std = zeros(n_stim,1);
av_corr_half = zeros(n_stim,1);
for j = 1:n_stim

    min_len = min_len0; 
    for k = 1:n_reps
        dd = voltage_data{j,k};
        len_dd = 9+find(isnan(dd(10:end)), 1, 'first');
        if len_dd<min_len
            min_len = len_dd;
        end 
    end 
    min_len_per_stim(j) = min_len;
    
    % For each rep, extract the relevant voltage data.
    for k = 1:n_reps
        da = voltage_data{j,k}(10:min_len-10+1);
        fa = frame_data{j,k}(10:min_len-10+1);
        ta = (time_data{j,k}(10:min_len-10+1));
        ta = ta-ta(1); % start time from zero for each rep. 
    
        data_comb(j, k, 1:min_len-18) = da;
        frame_comb(j, k, 1:min_len-18) = fa;
        time_comb(j, k, 1:min_len-18) = ta;
    end 
    
    av_resp(j, 1:min_len-18) = mean(data_comb(j, :, 1:min_len-18));
    av_frame(j, 1:min_len-18) = mean(frame_comb(j, :, 1:min_len-18));
    time_comb(j, :) = time_comb(j, :)./time_conv; % convert to seconds
    av_time(j, 1:min_len-18) = mean(time_comb(j, :, 1:min_len-18));

    av_resp_mean(j) = mean(av_resp(j, 1:min_len-18));
    av_resp_std(j) = std(av_resp(j, 1:min_len-18));

    av_resp_mean_1 = mean(data_comb(j, 1:n_half, 1:min_len-18));
    av_resp_mean_2 = mean(data_comb(j, n_half+1:2*n_half, 1:min_len-18));
    R = corrcoef(av_resp_mean_1, av_resp_mean_2);
    av_corr_half(j) = R(1,2);
end

sprintf('Mean correlation: %.2f', mean(av_corr_half))

%6bar
val_bar = [13, 21, 6, 17, 14, 22, 5, 18, 15, 23, 8, 19, 16, 24, 7, 20, 108, 116, 101, 112, 109, 117, 100, 113, 110, 118,103, 114, 111, 119, 102, 115];
sprintf('Mean correlation 6-width bars: %.2f', mean(av_corr_half(val_bar)))

%gratings
val_grat = [33, 76, 48, 62, 34, 75, 47, 61, 35, 78, 50, 64, 36, 77, 49, 63, 37, 80, 52, 66, 38, 79, 51, 65, 39, 82, 54, 68, 40, 81, 53, 67, 41, 84, 56, 70, 42, 83, 55, 69, 43, 86, 58, 72, 44, 85, 57, 71, 45, 88, 60, 74, 46, 87, 59, 73];
sprintf('Mean correlation gratings: %.2f', mean(av_corr_half(val_grat)))

%flicker
val_flick = [89, 90, 91, 92, 93, 94, 95];
sprintf('Mean correlation flicker: %.2f', mean(av_corr_half(val_flick)))


figure
xline(25-.5,'r:')
hold on
annotation('textbox', [0.17, 0.8, 0.2, 0.1], 'String', 'OFF bar', 'EdgeColor', 'none', 'FontSize', 18);
xline(33-.5,'r:')
annotation('textbox', [0.27, 0.8, 0.2, 0.1], 'String', 'OFF edge', 'EdgeColor', 'none', 'FontSize', 18);
xline(89-.5,'r:')
annotation('textbox', [0.47, 0.8, 0.2, 0.1], 'String', 'gratings', 'EdgeColor', 'none', 'FontSize', 18);
xline(96-.5,'r:')
annotation('textbox', [0.66, 0.8, 0.2, 0.1], 'String', 'flashes', 'EdgeColor', 'none', 'FontSize', 18);
xline(120-.5,'r:')
annotation('textbox', [0.76, 0.8, 0.2, 0.1], 'String', 'ON bar', 'EdgeColor', 'none', 'FontSize', 18);
annotation('textbox', [0.85, 0.8, 0.2, 0.1], 'String', 'ON edge', 'EdgeColor', 'none', 'FontSize', 18);
bar(av_resp_mean-mean(av_resp_mean))
title('Mean (over time) of mean (over rep) membrane potential')
ylabel('voltage - mean (mV)')
xlabel('stimulus id')
saveas(gca, fullfile(git_folder, cell_type, strcat('Mean_vs_stim_', cell_type,'_', date_to_process, '.fig')))
close

figure
xline(25-.5,'r:')
hold on
annotation('textbox', [0.17, 0.8, 0.2, 0.1], 'String', 'OFF bar', 'EdgeColor', 'none', 'FontSize', 18);
xline(33-.5,'r:')
annotation('textbox', [0.27, 0.8, 0.2, 0.1], 'String', 'OFF edge', 'EdgeColor', 'none', 'FontSize', 18);
xline(89-.5,'r:')
annotation('textbox', [0.47, 0.8, 0.2, 0.1], 'String', 'gratings', 'EdgeColor', 'none', 'FontSize', 18);
xline(96-.5,'r:')
annotation('textbox', [0.66, 0.8, 0.2, 0.1], 'String', 'flashes', 'EdgeColor', 'none', 'FontSize', 18);
xline(120-.5,'r:')
annotation('textbox', [0.76, 0.8, 0.2, 0.1], 'String', 'ON bar', 'EdgeColor', 'none', 'FontSize', 18);
annotation('textbox', [0.85, 0.8, 0.2, 0.1], 'String', 'ON edge', 'EdgeColor', 'none', 'FontSize', 18);
bar(av_resp_std)
title('Std (over time) of mean (over rep) membrane potential')
ylabel('voltage (mV)')
xlabel('stimulus id')
saveas(gca, fullfile(git_folder, cell_type, strcat('Std_vs_stim_', cell_type,'_', date_to_process, '.fig')))
close

figure
xline(25-.5,'r:')
hold on
annotation('textbox', [0.17, 0.8, 0.2, 0.1], 'String', 'OFF bar', 'EdgeColor', 'none', 'FontSize', 18);
xline(33-.5,'r:')
annotation('textbox', [0.27, 0.8, 0.2, 0.1], 'String', 'OFF edge', 'EdgeColor', 'none', 'FontSize', 18);
xline(89-.5,'r:')
annotation('textbox', [0.47, 0.8, 0.2, 0.1], 'String', 'gratings', 'EdgeColor', 'none', 'FontSize', 18);
xline(96-.5,'r:')
annotation('textbox', [0.66, 0.8, 0.2, 0.1], 'String', 'flashes', 'EdgeColor', 'none', 'FontSize', 18);
xline(120-.5,'r:')
annotation('textbox', [0.76, 0.8, 0.2, 0.1], 'String', 'ON bar', 'EdgeColor', 'none', 'FontSize', 18);
annotation('textbox', [0.85, 0.8, 0.2, 0.1], 'String', 'ON edge', 'EdgeColor', 'none', 'FontSize', 18);
bar(av_corr_half)
title('Correlation (over time) between mean (over half rep) membrane potential')
ylabel('corr (1)')
xlabel('stimulus id')
saveas(gca, fullfile(git_folder, cell_type, strcat('Corr_vs_stim_', cell_type,'_', date_to_process, '.fig')))
close

figure
plot(av_resp_std, av_corr_half, 'o', 'MarkerSize', 5, 'MarkerEdgeColor',[0.5,0.5,0.5], 'MarkerFaceColor',[0.5,0.5,0.5])
xlabel('std (mV)')
xlim([0,7])
ylabel('corr (1)')
ylim([-0.5,1])
saveas(gca, fullfile(git_folder, cell_type, strcat('Std_vs_corr_', cell_type,'_', date_to_process, '.png')), 'png')
close

mdl = fitlm(av_resp_std, av_corr_half);
anova(mdl,'summary')
plot(mdl)
