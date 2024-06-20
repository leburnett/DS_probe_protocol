%% Plot data from DS_probe_protocol - BAR stimuli
% Created by Burnett
% June 20th 2024

% Number of runs of the protocol:
n_reps = 4;

colour_reps = false;

%% Polar plot 
% plot_polar_plot(n_reps, colour_reps)
% 
% % Save the figure
% f = gcf;
% % save as MATLAB fig
% savefig(fullfile(fig_save_path, strcat('Polar_plot_4BarCond_', cell_type, '_', date_folder, '.fig')))
% % save as PDF
% print(f, fullfile(fig_save_path, strcat('Polar_plot_4BarCond_', cell_type, '_', date_folder, '.pdf')), '-dpdf', '-bestfit')
% % saveas(f, fullfile(fig_save_path, strcat('Polar_plot_4BarCond_', cell_type, '_', date_folder, '.pdf')), 'pdf')


%% Line plots
% plot_line_plot_8dir(n_reps, colour_reps)
% 
% 
% % Save the figure
% f = gcf;
% bar_cond = 'ON_100dps';
% % save as MATLAB fig
% savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_folder, '.fig')))
% % save as PDF
% print(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_folder, '.pdf')), '-dpdf', '-bestfit')
% saveas(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_folder, '.pdf')), 'pdf')
% close
% 
% f = gcf;
% bar_cond = 'ON_20dps';
% % save as MATLAB fig
% savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_folder, '.fig')))
% % save as PDF
% print(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_folder, '.pdf')), '-dpdf', '-bestfit')
% close
% 
% f = gcf;
% bar_cond = 'OFF_100dps';
% % save as MATLAB fig
% savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_folder, '.fig')))
% % save as PDF
% print(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_folder, '.pdf')), '-dpdf', '-bestfit')
% close
% 
% f = gcf;
% bar_cond = 'OFF_20dps';
% % save as MATLAB fig
% savefig(fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_folder, '.fig')))
% % save as PDF
% print(f, fullfile(fig_save_path, strcat('Line_plot_', bar_cond,'_', cell_type, '_', date_folder, '.pdf')), '-dpdf', '-bestfit')
% close



%% CHECK TIMING
% figure; plot(Log.ADC.Time(1,:), ((Log.ADC.Volts(1,:)/10)-50))
% hold on;
% plot(Log.ADC.Time(2,:), Log.ADC.Volts(2,:)*10)
% 
% for jj = 1:127
%     plot([cond_start_times(jj), cond_start_times(jj)], [-70, -30], 'k');
%     hold on
% end 

%% 
% 
% concat_processed_bars_line(cell_type)
% 
% %% Plot polar plots for each cell and the average across all cells. 
% for cond_val = 1:4
%     make_av_polar_plot_bars(cell_type, cond_val)
% end 
% 
% %% Plot line plots for each cell, and average over all cells. 
% for cond_val = 1:4 
%     make_av_line_plot_bars(cell_type, cond_val)
% end 



%% ON - OFF combined

% SLOW 
n_reps = 5;
slow_or_fast = "slow";
speed_str = '20dps'; 
fig_str = strcat('ON-OFF-comb_', date_folder,'_', speed_str, '_noREPS.fig');

plot_bar_line_ON_OFF_comb(n_reps, slow_or_fast)
savefig(gcf, fullfile(date_save_path, fig_str));
saveas(gcf, fullfile(date_save_path, fig_str(1:end-4)), 'pdf')
close 

%% FAST 

n_reps = 5;
slow_or_fast = "fast";
speed_str = '100dps';
fig_str = strcat('ON-OFF-comb_', date_folder,'_', speed_str, '_noREPS.fig');

plot_bar_line_ON_OFF_comb(n_reps, slow_or_fast)
savefig(gcf, fullfile(date_save_path, fig_str));
saveas(gcf, fullfile(date_save_path, fig_str(1:end-4)), 'pdf')
close
