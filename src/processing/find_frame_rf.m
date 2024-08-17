clear 
close all
clc

%converts seconds to microseconds (TDMS timestamps are in micros)
time_conv = 1000000;

%% load data
git_folder = 'C:\Users\hoellerj\Documents\GitHub\DS_probe_protocol\results\';
log_table = readtable(strcat(git_folder, 'exp_recording_log_JH.xlsx'));

exp = 1;
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
min_len_per_stim =  zeros(n_stim,1);
data_comb = zeros(n_stim, n_reps, min_len0);
frame_comb = zeros(n_stim, n_reps, min_len0,'uint32');
time_comb = zeros(n_stim, n_reps, min_len0);
av_resp = zeros(n_stim, min_len0);
av_frame = zeros(n_stim, min_len0,'uint32');
av_time = zeros(n_stim, min_len0);
for j = 1:n_stim

    min_len = min_len0; 
    for k = 1:n_reps
        dd = voltage_data{j,k};
        len_dd = length(dd);
        if len_dd<min_len
            min_len = len_dd;
        end 
    end 
    min_len_per_stim(j) = min_len;
    
    % For each rep, extract the relevant voltage data.
    for k = 1:n_reps
        da = voltage_data{j,k};
        fa = frame_data{j,k};
        ta = (time_data{j,k});
        ta = ta-ta(1); % start time from zero for each rep. 
    
        data_comb(j, k, 1:min_len) = da(1:min_len);
        frame_comb(j, k, 1:min_len) = fa(1:min_len);
        time_comb(j, k, 1:min_len) = ta(1:min_len);
    end 
    
    av_resp(j, 1:min_len) = mean(data_comb(j, :, 1:min_len));
    av_frame(j, 1:min_len) = mean(frame_comb(j, :, 1:min_len));
    time_comb(j, :) = time_comb(j, :)./time_conv; % convert to seconds
    av_time(j, 1:min_len) = mean(time_comb(j, :, 1:min_len));
end


%% make frames unique across stimuli, then binning
%remove flicker
good_stim = 1:n_stim;
good_stim = good_stim([1:88, 96:end]);
av_resp = av_resp(good_stim,:);
av_frame = av_frame(good_stim,:);
av_time = av_time(good_stim,:);
n_stim = length(good_stim);

tot_frames = 0;
for j=1:n_stim
    max_j = max(av_frame(j,:))+1;
    av_frame(j,:) = av_frame(j,:)+tot_frames;
    tot_frames = tot_frames+max_j;
end
sprintf('Number of frames: %d', tot_frames)
sprintf('Number of unique frames: %d', length(unique(reshape(av_frame,1,[]))))

n_avg = 5;
min_samp = floor(min(min_len_per_stim)/n_avg/2);
n_train = 1200;
n_test = 50;
av_time_train = zeros(n_stim, n_train);
av_frame_train = zeros(n_stim, n_train);
av_resp_train = zeros(n_stim, n_train);
av_time_test = zeros(n_stim, n_test);
av_frame_test = zeros(n_stim, n_test);
av_resp_test = zeros(n_stim, n_test);
for j = 1:n_stim
    n_j = floor(min_len_per_stim(j)/n_avg);
    m  = min_len_per_stim(j) - mod(min_len_per_stim(j), n_avg);

    %average over every n_avg elements
    y  = reshape(av_frame(j,1:m), n_avg, []); 
    y_avg = transpose(sum(y, 1) / n_avg); 
    y_avg = y_avg(1:2:end);
    i0 = find(rem(y_avg,1)==0);
    i_rand = randperm(length(i0));
    av_frame_train(j,:) = y_avg(i0(i_rand(1:n_train)));
    av_frame_test(j,:) = y_avg(i0(i_rand(n_train+1:n_train+n_test)));

    y  = reshape(av_time(j,1:m), n_avg, []); 
    y_avg = transpose(sum(y, 1) / n_avg); 
    y_avg = y_avg(1:2:end);
    av_time_train(j,:) = y_avg(i0(i_rand(1:n_train)));
    av_time_test(j,:) = y_avg(i0(i_rand(n_train+1:n_train+n_test)));

    y  = reshape(av_resp(j,1:m), n_avg, []); 
    y_avg = transpose(sum(y, 1) / n_avg); 
    y_avg = y_avg(1:2:end);
    av_resp_train(j,:) = y_avg(i0(i_rand(1:n_train)));
    av_resp_test(j,:) = y_avg(i0(i_rand(n_train+1:n_train+n_test)));
end

length(unique(reshape(av_frame_train,1,[])))
length(unique(reshape(av_frame_test,1,[])))
