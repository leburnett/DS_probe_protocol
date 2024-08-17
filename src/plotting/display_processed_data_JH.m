clear 
close all
clc

%converts seconds to microseconds (TDMS timestamps are in micros)
time_conv = 1000000;

%load log file
git_folder = 'C:\Users\hoellerj\Documents\GitHub\DS_probe_protocol\results\';
log_table = readtable(strcat(git_folder, 'exp_recording_log_JH.xlsx'));

exp = 9+2;
date_str = log_table.date_str{exp}; %'05_28_2024';
date_to_process = log_table.date_to_process{exp}; %'05_28_2024_2'; 
cell_type = log_table.cell_type{exp}; %'TmY3';
sprintf(date_to_process)

data_folder0 = 'O:\Burnett\Jinyong\DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09\';
data_folder = 'O:\Burnett\Jinyong\DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09\ProcessedData\';
if date_to_process(end-1)=='_'
    exp_folders = dir(strcat(data_folder0, date_str, '\', date_to_process(end), '\SS*'));
else
    exp_folders = dir(strcat(data_folder0, date_str, '\SS*'));
end
n_reps = length(exp_folders);
date_folder = fullfile(data_folder, cell_type);

res_files = dir(strcat(date_folder,'\','RES_all_reps*'));
i0 = -1;
for i=1:length(res_files)
    if contains(res_files(i).name, date_to_process)
        i0 = i;
    end
end
load(strcat(res_files(i0).folder, '\', res_files(i0).name), 'data_all_reps')

%ON 20dps: 108, 116, 101, 112, 109, 117, 100, 113
i_cond = 108; 

voltage_data = squeeze(data_all_reps(i_cond, 3, 1:n_reps));
frame_data = squeeze(data_all_reps(i_cond, 2, 1:n_reps));
time_data = squeeze(data_all_reps(i_cond, 1, 1:n_reps));

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
time_comb = zeros(n_reps, min_len);

% For each rep, extract the relevant voltage data.
figure
xline(0, 'r:')
hold on
xlabel('time (s)')
ylabel('voltage (mV)')
date_display = strrep(date_to_process, '_', '-');
title(strcat('Condition ',int2str(i_cond),' (processed), ', date_display))
for k = 1:n_reps
    da = voltage_data{k};
    fa = frame_data{k};
    ta = (time_data{k});
    ta = ta-ta(1); % start time from zero for each rep. 

    data_comb(k, :) = da(1:min_len);
    frame_comb(k, :) = fa(1:min_len);
    time_comb(k, :) = ta(1:min_len);

    plot(time_comb(k, :)/time_conv, data_comb(k, :))
end
xlim([time_comb(1)/time_conv, time_comb(end)/time_conv])
ylim([-70,-20])

git_folder = 'C:\Users\hoellerj\Documents\GitHub\DS_probe_protocol\results\';
fig_save_path = fullfile(strcat(git_folder, '\', cell_type, '\', date_str));
if ~isfolder(strcat(git_folder, '\', cell_type))
    mkdir(strcat(git_folder, '\', cell_type))
    mkdir(strcat(git_folder, '\', cell_type, '\', date_str))
elseif ~isfolder(strcat(git_folder, '\', cell_type, '\', date_str))
    mkdir(strcat(git_folder, '\', cell_type, '\', date_str))    
end 
savefig(fullfile(fig_save_path, strcat('voltage_', cell_type, '_', date_to_process, '_cond', int2str(i_cond), '_proc.fig')))
