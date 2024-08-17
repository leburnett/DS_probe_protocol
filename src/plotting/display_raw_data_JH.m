clear 
close all
clc

addpath(genpath('C:\Users\hoellerj\Documents\GitHub\G4_Display_Tools'))

%converts seconds to microseconds (TDMS timestamps are in micros)
time_conv = 1000000;

%load log file
git_folder = 'C:\Users\hoellerj\Documents\GitHub\DS_probe_protocol\results\';
log_table = readtable(strcat(git_folder, 'exp_recording_log_JH.xlsx'));

exp = 1;
date_str = log_table.date_str{exp}; %'05_28_2024';
date_to_process = log_table.date_to_process{exp}; %'05_28_2024_2'; 
cell_type = log_table.cell_type{exp}; %'TmY3';

data_folder0 = 'O:\Burnett\Jinyong\DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09\';
if date_to_process(end-1)=='_'
    exp_folders = dir(strcat(data_folder0, date_str, '\', date_to_process(end), '\SS*'));
else
    exp_folders = dir(strcat(data_folder0, date_str, '\SS*'));
end

%% plot full experiment (downsampled)
% n_sample = 100000;

% figure
% xlabel('time (s)')
% ylabel('voltage (uV)')
% title('Full experiment overview')
% for i=1:length(exp_folders)
% 
%     files = dir(strcat(exp_folders(i).folder, '\', exp_folders(i).name));
%     TDMSfiles = files(contains({files.name},{'G4_TDMS_Logs'}));
%     load(fullfile(TDMSfiles.folder,TDMSfiles.name),'Log');
%     
%     times = squeeze(Log.ADC.Time(2,:));
%     volts = squeeze(Log.ADC.Volts(2,:));
%     times_down = downsample(times,n_sample);
%     volts_down = downsample(volts,n_sample);
%     
%     plot(double(times_down)/time_conv, volts_down)
%     
%     hold on
% end
% xlim([double(times(1))/time_conv, double(times(end))/time_conv])


%% plot snipped of experiment (all frames)
%ON 20dps: 108, 116, 101, 112, 109, 117, 100, 113
i_cond = 108; 

n_init = 10*20; %20 corresponds to 1 ms
n_final = n_init;
t_max = 0;
 
figure
xline(0, 'r:')
hold on
xlabel('time (s)')
ylabel('voltage (mV)')
date_display = strrep(date_to_process, '_', '-');
title(strcat('Condition ',int2str(i_cond),' (raw), ', date_display))
for i=1:length(exp_folders)

    files = dir(strcat(exp_folders(i).folder, '\', exp_folders(i).name));
    TDMSfiles = files(contains({files.name},{'G4_TDMS_Logs'}));
    load(fullfile(TDMSfiles.folder,TDMSfiles.name),'Log');

    [start_idx, stop_idx, start_times, stop_times] = get_start_stop_times(Log, 'start-display', 0);
    [frame_movement_start_times] = get_pattern_movement_times(start_times, Log);
    
    times = double(squeeze(Log.ADC.Time(2,:)));
    volts = squeeze(Log.ADC.Volts(2,:));

    idx_start1 = find(times>frame_movement_start_times(i_cond),1,'first');
    idx_start2 = find(times>frame_movement_start_times(i_cond+1),1,'first');

    time_int = times(idx_start1-n_init:idx_start2+n_final)-times(idx_start1);
    t_max = max([t_max, time_int(end)]);

    plot(time_int/time_conv, 10*volts(idx_start1-n_init:idx_start2+n_final))
    xline(time_int(end-n_final)/time_conv, 'r:')
end
xlim([time_int(1)/time_conv, t_max/time_conv])

git_folder = 'C:\Users\hoellerj\Documents\GitHub\DS_probe_protocol\results\';
fig_save_path = fullfile(strcat(git_folder, '\', cell_type, '\', date_str));
savefig(fullfile(fig_save_path, strcat('voltage_', cell_type, '_', date_to_process, '_cond', int2str(i_cond), '_raw.fig')))
