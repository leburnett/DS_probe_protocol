% Core script for running functions from

%% Run preprocessing
project_folder = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/TmY13';
date_folder = '06_07_2024';

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


%% 
cell_type = 'TmY13';

concat_processed_bars_line(cell_type)

%% Plot polar plots for each cell and the average across all cells. 
for cond_val = 1:4
    make_av_polar_plot_bars(cell_type, cond_val)
end 

%% Plot line plots for each cell, and average over all cells. 
for cond_val = 1:4 
    make_av_line_plot_bars(cell_type, cond_val)
end 