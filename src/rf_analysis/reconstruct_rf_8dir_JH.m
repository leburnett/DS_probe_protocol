% Predict RF from 6 pixel bar stimulus 
% Jin Yong's recordings - Summer 2024

git_folder = 'C:\Users\hoellerj\Documents\GitHub\DS_probe_protocol\results\';
log_table = readtable(strcat(git_folder, 'exp_recording_log_JH.xlsx'));
n_exps = height(log_table);

%% load data
% cd('/Users/burnettl/Documents/Janelia/G4/2405_Jinyong_Experiments/Data/DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09');
data_folder0 = 'O:\Burnett\Jinyong\DS_probe_protocol_1REP_RightHemi_20Hz_05-22-24_09-09-09\';
data_folder = strcat(data_folder0,'ProcessedData2\');

exp = 1;

% Initialise parameters that will change
date_str = log_table.date_str{exp}; %'05_28_2024';
date_to_process = log_table.date_to_process{exp}; %'05_28_2024_2'; % when there are subfolders set this to '06_18_2024_1' etc.
cell_type = log_table.cell_type{exp}; %'TmY3';

% RUN THIS SCRIPT WITHIN THE DATE FOLDER. 
% Where the 'RES_all_reps...' file is found. 
date_folder = fullfile(data_folder, cell_type);
cd(date_folder)

% Number of runs of the protocol:
if date_to_process(end-1)=='_'
    exp_folders = dir(strcat(data_folder0, date_str, '\', date_to_process(end), '\SS*'));
else
    exp_folders = dir(strcat(data_folder0, date_str, '\SS*'));
end
n_reps = length(exp_folders);

rf_data_all = zeros([4, 48, 192]);
values_all = [13, 21, 6, 17, 14, 22, 5, 18; 15, 23, 8, 19, 16, 24, 7, 20;
    108, 116, 101, 112, 109, 117, 100, 113; 110, 118,103, 114, 111, 119, 102, 115];
[time_comb_all, frame_comb_all, data_comb_all] = load_voltages(n_reps, date_str, values_all);
exp_baseline = nanmean(squeeze(data_comb_all([3,11,19,27],:,1:5000)));
exp_max = nanmax(squeeze(abs(nanmean(data_comb_all)-exp_baseline)));
for plot_n = 1:4
    if plot_n == 1
        % % % OFF 20 dps
        title_str = strcat('20 dps - OFF - bar6 - ', cell_type, ' - ', date_str);
        rfmap = [64,0,75;118,42,131;153,112,171;194,165,207;231,212,232;217,240,211;166,219,160;90,174,97;27,120,55;0,68,27]./255;
    elseif plot_n == 2
        % OFF 100 dps
        title_str = strcat('100 dps - OFF - bar6 - ', cell_type, ' - ', date_str);
        rfmap = [84,48,5;140,81,10; 191,129,45;223,194,125;246,232,195;199,234,229;128,205,193;53,151,143;1,102,94; 0,60,48]./255;
    elseif plot_n == 3
        % % % ON 20 dps
        title_str = strcat('20 dps - ON - bar6 - ', cell_type, ' - ', date_str);
        rfmap = [142,1,82;197,27,125;222,119,174;241,182,218;253,224,239;230,245,208;184,225,134;127,188,65;77,146,33;39,100,25]./255;
    elseif plot_n == 4
        % ON 100 dps
        title_str = strcat('100 dps - ON - bar6 - ', cell_type, ' - ', date_str);
        rfmap = [165,0,38;215,48,39;244,109,67;253,174,97;254,224,139;217,239,139;166,217,106;102,189,99;26,152,80;0,104,55]./255;
    end 
    values = values_all(plot_n,:);

    [time_comb_all, frame_comb_all, data_comb_all] = load_voltages(n_reps, date_str, values);
    % Loop through the 8 directions
    for j = 1:8
        idx = values(j);
    
        % Load the appropriate pattern. 
        pat_file = block_trials{idx, 2};
        load(fullfile(pattern_path, pat_file), 'pattern');
        
        % Collect voltage data from across the repetitions. 
        data_comb = data_comb_all(j,:,:);
        frame_comb = time_comb_all(j,:,:);
        
        av_resp = nanmean(data_comb);
        av_resp = (av_resp - exp_baseline./exp_max;   
        av_frame = ceil(nanmean(frame_comb)); % Make sure there are no floating values
    
        % Remove the first 250ms
        av_resp = av_resp(5000:end-2500);
        av_frame = av_frame(5000:end-2500);
        
        % Can't have 'frame 0'... should check where this comes from and why. 
        % Check to see if I should add 1 to each frame position. 
        av_frame(av_frame==0)=1;
    
        % Aim is to reduce the number of loops I have to compute for. 
        % The same frame is being presented for many timepoints.
        % Find the frame being presented and find an average for the time over
        % which the frame is being presented. 
        frame_changes = find(abs(diff(av_frame))>0);
        % frame delta t - see what the RF would be like if you used the
        % next frame instead.
        f_dt = 0; %-15;
    
        for fc = 1:numel(frame_changes)
    
            % voltage data
            if fc < abs(f_dt)+1
                v_data = av_resp(1:frame_changes(1));
            elseif fc >= numel(frame_changes)-f_dt
                v_data = av_resp(frame_changes(fc):end);
            else
                v_data = av_resp(frame_changes(fc+f_dt):frame_changes(fc+f_dt)+1);
            end 
    
            % Find the average voltage over the time this frame was being
            % presented.
            v_mean = nanmean(v_data);
    
            % What frame was being shown during this time? 
            f_data = pattern.Pats(:, :, av_frame(frame_changes(fc)));
            f_norm = mat2gray(f_data);
            f_norm(f_norm==0)=-1;
    
            rf_data_all(plot_n,:,:) = rf_data_all  + (f_norm * v_mean);
        end     
    end 
    rf_data_all = rf_data_all./frame_changes./8;
    
    % Plot figure for each type of stimulus.
    % Flip image to be seen as if from fly view. Arena mounted
    % upside down. 
    figure; imagesc(flipud(rf_data_all(plot_n,:,:)))
    title(title_str)
    if plot_n<3
        colormap(gca,flipud(rfmap));
    else
        colormap(gca,rfmap);
    end
end 










































