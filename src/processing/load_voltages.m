function [time_comb_all, frame_comb_all, data_comb_all] = load_voltages(n_reps, date_str, values)

    res_files = dir('RES_all_reps*');
    i0 = -1;
    for i=1:length(res_files)
        if contains(res_files(i).name, date_str)
            i0 = i;
        end
    end
    if i0==-1
        print('No date with ', date_str)
        return 
    end

    load(res_files(i0).name, 'data_all_reps')

    n_values = length(values);
    % Collect voltage data from across conditions
    min_len0 = 1000000;
    data_comb_all = NaN(n_values, n_reps, min_len0);
    frame_comb_all = NaN(n_values, n_reps, min_len0);
    time_comb_all = NaN(n_values, n_reps, min_len0);
    for j = 1:n_values
        voltage_data = squeeze(data_all_reps(values(j), 3, 1:n_reps));
        frame_data = squeeze(data_all_reps(values(j), 2, 1:n_reps));
        time_data = squeeze(data_all_reps(values(j), 1, 1:n_reps));

        % Find the shortest length of a rep. 
        min_len = min_len0;
        for k = 1:n_reps
            if length(voltage_data{k})<min_len
                min_len = length(voltage_data{k});
            end 
        end 

        % For each rep, extract the relevant voltage data.
        for k = 1:n_reps
            da = voltage_data{k};
            fa = frame_data{k};
            ta = (time_data{k});
            ta = ta-ta(1); % start time from zero for each rep. 

            data_comb_all(j, k, 1:min_len) = da(1:min_len);
            frame_comb_all(j, k, 1:min_len) = fa(1:min_len);
            time_comb_all(j, k, 1:min_len) = ta(1:min_len);
        end
    end
end
