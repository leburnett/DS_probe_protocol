
% After having found out the centre of the RF after computing the 
% spatial RF for all conditions, then plot the temporal RF for each of the
% 8 directions separately. 

% SPATIOTEMPORAL RF FOR EACH DIRECTION SEPARATELY. 

function est_tempRF_8dir(cell_type, date_str, peak_x, peak_y)

% Load the protocol details:
load('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Protocol_details.mat', 'block_trials');

% Load the processed data 
res_files = dir('RES_all_reps*');
load(res_files(1).name, 'data_all_reps')
n_reps = size(data_all_reps, 3);
date_str = strrep(date_str, '_', '-');

% Patterns
pattern_path = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/Patterns';
    
    % Loop through the 8 directions for this stimulus. 
    for j = 1:8
    
        for plot_n = 1:4

            rf_data_t = zeros(192, 20);
            rf_data_all = zeros(48, 192);

            for f_dt = -10:1:10
        
                % rf_data_t = []; 
            
                if plot_n == 1
                    % % % OFF 20 dps
                    values = [13, 21, 6, 17, 14, 22, 5, 18];
                elseif plot_n == 2
                    % OFF 100 dps
                    values = [15, 23, 8, 19, 16, 24, 7, 20];
                elseif plot_n == 3
                    % % % ON 20 dps
                    values = [108, 116, 101, 112, 109, 117, 100, 113];
                elseif plot_n == 4
                    % ON 100 dps
                    values = [110, 118,103, 114, 111, 119, 102, 115];
                end 
                
                % Exp baseline to then
                all_voltage_data = squeeze(data_all_reps(values, 3, 1:n_reps));
                all_voltage_data = vertcat(all_voltage_data{:}); % reshape and unpack values in cell arrays. 
                exp_baseline = nanmedian(all_voltage_data);
               
                %% Empty array to add frame data to, to get SPATIAL RF.
                rf_data = zeros(48, 192);
                
                % disp(strcat('Stim number: ', string(j)))
                idx = values(j);
            
                % Load the appropriate pattern. 
                pat_file = block_trials{idx, 2};
                load(fullfile(pattern_path, pat_file), 'pattern');
            
                % Sort the voltage and the frame positon data
                voltage_data = squeeze(data_all_reps(idx, 3, 1:n_reps));
                frame_data = squeeze(data_all_reps(idx, 2, 1:n_reps));
            
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
                
                % For each rep, extract the relevant voltage data.
                for k = 1:n_reps
                    da = voltage_data{k};
                    fa = frame_data{k};
                    data_comb(k, :) = da(1:min_len);
                    frame_comb(k, :) = fa(1:min_len);
                end
                
                av_resp = nanmean(data_comb);
                % Normalise response to baseline. 
                av_resp = av_resp - exp_baseline;
            
                av_frame = ceil(nanmean(frame_comb)); % Make sure there are no floating values
            
                % Remove the first 250ms and last 125ms.
                av_resp = av_resp(5000:end-2500);
                av_frame = av_frame(5000:end-2500);
            
                av_resp = av_resp(~isnan(av_resp));
                % Could also remove 200ms at the end....
            
                % Can't have 'frame 0'... should check where this comes from and why. 
                % Check to see if I should add 1 to each frame position. 
                av_frame(av_frame==0)=1;
                av_frame= av_frame(~isnan(av_frame));
            
                % Aim is to reduce the number of loops I have to compute for. 
                % The same frame is being presented for many timepoints.
                % Find the frame being presented and find an average for the time over
                % which the frame is being presented. 
                frame_changes = find(abs(diff(av_frame))>0);
                % frame delta t - see what the RF would be like if you used the
                % next frame instead.
                % f_dt = 10;
            
                % % Computed per FRAME CHANGE (group all frames with the same image
                % % being shown)
                % for fc = 1:numel(frame_changes)
                % 
                %     % voltage data
                %     if fc < abs(f_dt)+1
                %         v_data = av_resp(1:frame_changes(1));
                %     elseif fc >= numel(frame_changes)-f_dt
                %         v_data = av_resp(frame_changes(fc):end);
                %     else
                %         v_data = av_resp(frame_changes(fc+f_dt):frame_changes(fc+f_dt)+1);
                %     end 
                % 
                %     % Find the average voltage over the time this frame was being
                %     % presented.
                %     v_mean = nanmean(v_data);
                % 
                %     % What frame was being shown during this time? 
                %     f_data = pattern.Pats(:, :, av_frame(frame_changes(fc)));
                %     f_norm = mat2gray(f_data);
                %     % if plot_n <= 2 % OFF BAR - flip so that plots are bright for positive responses. 
                %     %     f_norm = double(~f_norm);
                %     % end 
                %     f_norm(f_norm==0)=-1;
                % 
                %     % rf_data = rf_data + flipud(f_norm * v_mean);
                %     % rf_data_all = rf_data_all  + flipud(f_norm * v_mean); 
                %     rf_data_t(:, :, fc) = flipud((f_norm * v_mean));
                % end 
    
                % Computed per FRAME CHANGE (group all frames with the same image
                % being shown)
                for fc = 1:numel(frame_changes)
        
                    % voltage data
                    % if fc < abs(f_dt)+1
                    %     v_data = av_resp(1:frame_changes(1));
                    % elseif fc >= numel(frame_changes)-f_dt
                    %     v_data = av_resp(frame_changes(fc):end);
                    % else
                    %     v_data = av_resp(frame_changes(fc+f_dt):frame_changes(fc+f_dt)+1);
                    % end 
                    v_data = av_resp(frame_changes(fc):frame_changes(fc)+1);
        
                    % Find the average voltage over the time this frame was being
                    % presented.
                    v_mean = mean(v_data);
        
                    % What frame was being shown during this time? 
                    % f_data = pattern.Pats(:, :, av_frame(frame_changes(fc)));
                    f_id = fc+f_dt;
                    if f_id<1
                        f_id = 1;
                    elseif f_id > numel(frame_changes)
                        f_id = numel(frame_changes);
                    end 
                    f_data = pattern.Pats(:, :, av_frame(frame_changes(f_id)));

                    f_norm = mat2gray(f_data);
                    % if plot_n <= 2 % OFF BAR - flip so that plots are bright for positive responses. 
                    %     f_norm = double(~f_norm);
                    % end 
                    f_norm(f_norm==0)=-1;
        
                    % f_norm1 = mat2gray(f_data);
                    % if plot_n <= 2 % OFF BAR - flip so that plots are bright for positive responses. 
                    %     f_norm1 = double(~f_norm1);
                    % end 
                    % f_norm1(f_norm1==0)=-1;
        
                    rf_data = rf_data + flipud(f_norm * v_mean); % image flipped to be from fly's view.
                    rf_data_all = rf_data_all  + flipud(f_norm * v_mean); 
                    % rf_data_all1 = rf_data_all1  + flipud(f_norm1 * v_mean); 
                end 
        
                rf_data_t(:,f_dt+11) = squeeze(mean(rf_data,1));

            end 






            if plot_n ==1 
                a = rf_data_t;
            elseif plot_n ==2 
                b = rf_data_t;
            elseif plot_n ==3
                c = rf_data_t;
            elseif plot_n == 4
                d = rf_data_t;
            end 
    
        end 
    
     % Generate the plots.  
    limm = numel(frame_changes);
    
    % Plotting the pixel in 'centre of RF' over time. 
    figure; 
    subplot(1,4,1)
    imagesc(squeeze(a(peak_y, peak_x, :)));
    title('OFF20')
    ylim([0 limm])
    ax = gca; ax.XAxis.Visible = 'off';

    subplot(1,4,3)
    imagesc(squeeze(b(peak_y, peak_x, :)));
    title('OFF100')
    ylim([0 limm])
    ax = gca; ax.XAxis.Visible = 'off';

    subplot(1,4,2)
    imagesc(squeeze(c(peak_y, peak_x, :)));
    title('ON20')
    ylim([0 limm])
    ax = gca; ax.XAxis.Visible = 'off';
    subplot(1, 4,4)
    imagesc(squeeze(d(peak_y, peak_x, :)));
    title('ON100')
    ylim([0 limm])
    ax = gca; ax.XAxis.Visible = 'off';
    set(gcf, "Position", [1 294 380 753])
    sgtitle(strcat(cell_type, '-', date_str, '- j=', string(j)))
    
    % figure; 
    % subplot(4,1,1)
    % plot(squeeze(a(peak_y, peak_x, :)));
    % title('OFF20')
    % xlim([0 limm])
    % % ax = gca; ax.YAxis.Visible = 'off';
    % xticklabels({''})
    % 
    % subplot(4,1,3)
    % plot(squeeze(b(peak_y, peak_x, :)));
    % title('OFF100')
    % xlim([0 limm])
    % % ax = gca; ax.YAxis.Visible = 'off';
    % xticklabels({''})
    % 
    % subplot(4,1,2)
    % plot(squeeze(c(peak_y, peak_x, :)));
    % title('ON20')
    % xlim([0 limm])
    % % ax = gca; ax.YAxis.Visible = 'off';
    % xticklabels({''})
    % 
    % subplot(4,1,4)
    % plot(squeeze(d(peak_y, peak_x, :)));
    % title('ON100')
    % xlim([0 limm])
    % % ax = gca; ax.YAxis.Visible = 'off';
    % set(gcf, "Position", [384 671 1036 376])
    % sgtitle(strcat(cell_type, '-', date_str, '- j=', string(j)))

    figure; 
    subplot(2,1,1)
    plot(squeeze(a(peak_y, peak_x, :)), 'k', 'LineWidth', 1.2);
    hold on
    % title('OFF20')
    xlim([0 limm])
    % ax = gca; ax.YAxis.Visible = 'off';
    xticklabels({''})
    
    subplot(2,1,2)
    plot(squeeze(b(peak_y, peak_x, :)), 'k', 'LineWidth', 1.2);
    hold on
    % title('OFF100')
    xlim([0 limm])
    % ax = gca; ax.YAxis.Visible = 'off';
    xticklabels({''})
    
    subplot(2,1,1)
    plot(squeeze(c(peak_y, peak_x, :)), 'g', 'LineWidth', 1.2);
    title('20dps')
    xlim([0 limm])
    % ax = gca; ax.YAxis.Visible = 'off';
    xticklabels({''})
    
    subplot(2,1,2)
    plot(squeeze(d(peak_y, peak_x, :)), 'g', 'LineWidth', 1.2);
    title('100dps')
    xlim([0 limm])
    % ax = gca; ax.YAxis.Visible = 'off';
    set(gcf, "Position", [384 671 1036 376])
    sgtitle(strcat(cell_type, '-', date_str, '- j=', string(j),' - f-dt:', string(f_dt)))
     
    end 

end 






























