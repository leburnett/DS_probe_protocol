% Core script for running functions from

%% Run preprocessing
project_folder = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_05-20-24_16-30-23';
date_folder = '05_06_2024';

process_ds_probe_protocol_data(project_folder, date_folder)

% Number of runs of the protocol:
n_reps = 5;

%% Polar plot 
plot_polar_plot(n_reps)


%% Line plots
plot_line_plot_8dir(n_reps)


%% CHECK TIMING
figure; plot(Log.ADC.Time(1,:), ((Log.ADC.Volts(1,:)/10)-50))
hold on;
plot(Log.ADC.Time(2,:), Log.ADC.Volts(2,:)*10)

for jj = 1:127
    plot([cond_start_times(jj), cond_start_times(jj)], [-70, -30], 'k');
    hold on
end 
