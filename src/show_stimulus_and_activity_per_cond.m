

%% Make animation showing the stimulus that was being presented and the recorded neural response
% create a window around the time of the recording that was happening.
% Log.Frames.Position = frame position.
% Log.Frames.Time = time.
% Log.ADC.Time
% Log.ADC.Volts

figure
subplot(2,1,1)
a = Log.Frames.Position;
at = Log.Frames.Time;
plot(at, a)
subplot(2,1,2)
b = Log.ADC.Volts(2, :);
bt = Log.ADC.Time(2,:);
plot(bt, b)


imagesc(pattern.Pats(:, :, 20))
hold on
plot([81, 81], [-1 49], 'k:');
plot([175, 175], [-1 49], 'k:');
plot([129, 129], [-1 49], 'k');
box off
axis off



%% From 'processed_data.mat'

% 'summaries'
% % Frame position
% figure; plot(summaries(5, :))

% 'timeseries'

rep = 1;
% Frame position per condition
data1 = squeeze(timeseries(1, 1, rep, :));
% voltage per condition
data2 = squeeze(timeseries(2, 1, rep, :));

% since there are no repetitions in this protocol
% 'ts_avg_reps' is the same data as 'timeseries'

% % Frame position per condition
% data1 = squeeze(ts_avg_reps(1, 1, 1,:));
% % voltage per condition
% data2 = squeeze(ts_avg_reps(2, 1, 1,:));

figure; 
subplot(2,1,1); plot(data1);
title('timeseries(1, 1,1,:)')
subplot(2,1,2); plot(data2);
title('timeseries(2, 1,1,:)')

%%
time_vals = Log.ADC.Time(1,:);
% y values
frame_position = Log.ADC.Volts(1,:);
% frame_position = (Log.ADC.Volts(1,:)/8)-60;
% voltage_data = Log.ADC.Volts(2,:)*10;

%% Load the protocol details - this is from the overall experiment G4 folder.
load('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Protocol_details.mat', 'block_trials');

project_folder = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09';
cd(project_folder)

patterns_folder = fullfile(project_folder, 'Patterns');

%% Test run  - this would be in a loop eventually:
close all 

% for condition 1:
cond_idx = 127; 

pat_name = strcat(block_trials{cond_idx,2}, '.mat');
load(fullfile(patterns_folder, pat_name), 'pattern')

% rep will always be 1 because there is only 1 repetition in each
% experiment. 
rep = 1;

% Frame position per condition
frame_data = squeeze(timeseries(1, cond_idx, rep, :));
% seems to be filled with NaNs up until 103 for ~10 conditions checked.

% Voltage per condition
voltage_data = squeeze(timeseries(2, cond_idx, rep, :))*10;

n_frames = sum(~isnan(frame_data));

figure
for idx = 103:n_frames % starts at 103 for some reason... in Lisa's processing?? Buffer period?
    curr_frame = ceil(frame_data(idx))+1;
    % plus one because starts at 0.

    subplot(2,1,1)
    imagesc(pattern.Pats(:, :, curr_frame))
    hold on
    plot([81, 81], [-1 48], 'k:');
    plot([175, 175], [-1 48], 'k:');
    plot([129, 129], [-1 48], 'k');
    box off
    axis off
    hold off

    subplot(2,1,2)
    plot(voltage_data(idx-100:idx+100));
    hold on 
    plot([50 50], [-80 -20], 'r')
    ylim([min(voltage_data)*1.01, max(voltage_data)*1.01])
    xlim([0, 100])
    box off
    hold off

    pause(0.001)

    set(gcf, 'Position', [580   383   298   451]); %[580   600   481   234]); %580   596   912   238]);
end 







%%




















