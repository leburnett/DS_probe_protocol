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
