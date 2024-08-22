function [peak_x, peak_y] = reconstruct_rf_8dir(cell_type, date_str, f_dt, on_off, cond_to_use)
% Predict RF from 6 pixel bar stimulus 
% Jin Yong's recordings - Summer 2024

% Load the protocol details:
load('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Protocol_details.mat', 'block_trials');

% Load the processed data 
res_files = dir('RES_all_reps*');
load(res_files(1).name, 'data_all_reps')
n_reps = size(data_all_reps, 3);
date_str = strrep(date_str, '_', '-');

% Patterns
pattern_path = '/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09/Patterns';

rf_data_all = zeros(48, 192);
rf_data_all1 = zeros(48, 192);

% cond_to_use = [1,3];

for plot_n = cond_to_use

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
    
    % Empty array to add frame data to, to get RF.
    rf_data = zeros(48, 192);
    
    % Loop through the 8 directions for this stimulus. 
    for j = 1:8
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
        % f_dt = 0;
    
        % Computed per FRAME CHANGE (group all frames with the same image
        % being shown)
        for fc = 1:numel(frame_changes)
            if fc == 1
                v_data = av_resp(1:frame_changes(fc));
            else
                v_data = av_resp(frame_changes(fc-1)+1:frame_changes(fc));
            end 

            % Find the average voltage over the time this frame was being
            % presented.
            v_mean = nanmean(v_data);

            % What frame was being shown during this time? 
            f_id = fc+f_dt;
            if f_id<1
                continue
            elseif f_id > numel(frame_changes)
                continue
            end 

            % Image that was shown. 
            f_data = pattern.Pats(:, :, av_frame(frame_changes(f_id)));

            f_norm = mat2gray(f_data); % Normalises image so that peak value = 1 and min value = 0
            if plot_n <= 2 
                % when dark bar, flip so that bar = 1 and bkg = 0; 
                f_norm = double(~f_norm);
                % also make dark bar = -1 
                f_norm=f_norm*-1;
            end 

            % f_norm1 = mat2gray(f_data);
            % if plot_n <= 2 % OFF BAR - flip so that plots are bright for positive responses. 
            %     f_norm1 = double(~f_norm1);
            % end 
            % f_norm1(f_norm1==0)=-1;

            rf_data = rf_data + flipud(f_norm * v_mean); % image flipped to be from fly's view.
            rf_data_all = rf_data_all  + flipud(f_norm * v_mean); 
            % rf_data_all1 = rf_data_all1  + flipud(f_norm1 * v_mean); 
        end 

    end 
   
end 

n_frames = numel(frame_changes)*8*numel(cond_to_use);
rf_data_all = rf_data_all/n_frames;
% rf_data_all1 = rf_data_all1/numel(frame_changes)*8*numel(cond_to_use);

% Plot spatial receptive field over all 4 conditions:
comb_title = strcat('RF est - bar6 - ', cell_type, ' - ', date_str, ' - ', on_off, '-dt: ', string(f_dt));
% % comb_title = strcat('RF est - bar6 - ', cell_type, ' - ', date_str, ' - ', on_off, '- ', string(cond_to_use));

% if on_off == "sum"
%     % Estimate the centre of the RF using the +1 +1 version. 
%     max_value = max(rf_data_all1(:));
%     [peak_y, peak_x] = find(rf_data_all1 == max_value);
%     val_centre = rf_data_all1(peak_y, peak_x);
% elseif on_off == "diff"
%     % Estimate the centre of the RF using the +1 +1 version.
%     if plot_n<3
%         min_value = min(rf_data_all(:));
%         [peak_y, peak_x] = find(rf_data_all == min_value);
%     else
%         max_value = max(rf_data_all(:));
%         [peak_y, peak_x] = find(rf_data_all == max_value);
%     end 
%     % Find out what the value of this pixel is in +1 -1 version
%     val_centre = rf_data_all(peak_y, peak_x);
% end 

min_value = min(rf_data_all(:));
max_value = max(rf_data_all(:));
if abs(min_value)>max_value
    [peak_y, peak_x] = find(rf_data_all == min_value);
    mm='min';
    min_val = min_value;
    max_val = min_value*-1;
else
    [peak_y, peak_x] = find(rf_data_all == max_value);
    mm='max';
    min_val = max_value*-1;
    max_val = max_value;
end 
val_centre = rf_data_all(peak_y, peak_x);

% Generate figure:
figure; 

% Plot the position of the centre of the RF wrt the whole screen.
subplot(1, 4, 1:3)

if on_off == "sum" % use +1 for both on and off bar
    imagesc(rf_data_all1); hold on; plot(peak_x, peak_y, 'k.', 'MarkerSize', 15)
elseif on_off == "diff" % Use +1 for on and -1 for off
    imagesc(rf_data_all); hold on; plot(peak_x, peak_y, 'k.', 'MarkerSize', 15)
end 

magma = cmap_magma();
colormap(redblue)
set(gca, "TickDir", 'out', "TickLength", [0.01 0.01], "FontSize", 12, "LineWidth", 1.2);
% colormap(redblue)
% min_val = min(min(rf_data_all));
% max_val = max(max(rf_data_all));
clim([min_val max_val])

colorbar
box off
set(gca, "TickDir", 'out');
xlabel('Pixel - azimuth')
ylabel('Pixel - elevation')

subplot(1,4,4)
% plot crop close up of the RF. 
% +/- 16 pixels, +/-18 deg VA. 

xcrp1 = peak_x - 16; 
if xcrp1 <1
    x1 = 1;
else
    x1 = xcrp1;
end 
xcrp2 = peak_x + 16; 
if xcrp2 > 192
    x2 = 192;
else 
    x2 = xcrp2;
end 
ycrp1 = peak_y - 16;
if ycrp1 < 1
    y1 = 1;
else
    y1 = ycrp1;
end 
ycrp2 = peak_y + 16;
if ycrp2 > 48
    y2 = 48;
else
    y2 = ycrp2;
end 

crop_im = rf_data_all(y1:y2, x1:x2);
% % crop_im2 = rf_data_all1(y1:y2, x1:x2);
% if on_off == "sum"
%     imagesc(crop_im2)
%     [ymax, xmax] = find(crop_im2 == max(crop_im2(:)));
% elseif on_off == "diff"
imagesc(crop_im)
if mm == "min"
    [ymax, xmax] = find(crop_im == min(crop_im(:)));
elseif mm == "max" 
    [ymax, xmax] = find(crop_im == max(crop_im(:)));
end 
% end 

xlim([xmax-16 xmax+16])
ylim([ymax-16 ymax+16])

set(gca, "TickDir", 'out', "TickLength", [0.03 0.03], "FontSize", 12, "LineWidth", 1.2);
xticks([xmax-16, xmax, xmax+16])
yticks([ymax-16, ymax, ymax+16])
xticklabels({'-16', '0', '16'})
yticklabels({'-16', '0', '16'})
xlabel('Degrees from centre')
ylabel('Degrees from centre')
clim([min_val max_val])

yyaxis right 
yticks([])
ylabel(strcat('X:', string(peak_x), ', Y:', string(peak_y), ', C:', string(val_centre)))
sgtitle(comb_title)
set(gcf, "Position", [1 837 897 210])

end 











































