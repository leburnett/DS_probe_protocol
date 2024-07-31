function [pk_data, amp_freq, loc_freq] = find_peak_freq_amp(data, data_rate, stim_freq, col)
    % Simple FFT analysis of patch data to flicker stimuli at different frequencies. 
    % Frequencies are 0.5, 1, 4, 8, 16, 32, 64 Hz. 
    % data_rate = 20000
    
    n_x = numel(data);
    
    dT = 1/data_rate; % Set sampling interval
    
    X1 = data(1:n_x-1); % Extract the data segment. Exlcude the last. 
    X1 = X1(~isnan(X1));
    L1 = length(X1); % Length of data
    
    Y1 = fft(X1); % Perform FFT
    
    p2a = abs(Y1/L1); % Compute two-sided spectrum
    
    p1a = p2a(1:ceil(L1/2)+1); % Compute sinlge-sided spectrum
    
    p1a(2:end-1) = 2*p1a(2:end-1); % Adjust amplitude of single-sided spectrum
    
    f1 = (1/dT)*(0:(L1/2))/L1; % Generate frequency vector
    % This line creates a frequency vector f1 that corresponds to the frequencies of the FFT result.
    % It ranges from 0 to the Nyquist frequency (half the sampling rate)
    
    %% Plot the amplitude spectrum of the data
    figure
    freq_data = f1(2:200);
    pow_data = p1a(2:200);
    plot(freq_data, pow_data, 'Color', col, 'LineWidth', 1) % Plot the spectrum. 
    title(strcat('Amplitude Spectrum: ', string(stim_freq)))
    xlabel('f (Hz)')
    ylabel('|p1(f)|')
    
    %% Find the frequencies and amplitudes of the peaks.
    % pk_data contains the power amplitudes of the peaks in the first column 
    % and the frequency values of the peaks in the second column. 
    
    [pk_data(:,1), pk_data(:,2)] = findpeaks(pow_data, freq_data, "MinPeakWidth", 0.25);
    pk_data = sortrows(pk_data, 1, "descend"); % Sort based on the peak values with the highest first. 

    hold on 
    % highlight the 3 highest peaks

    if length(pk_data)<5
        n_dots = length(pk_data); 
    else 
        n_dots = 5;
    end 

    for i = 1:n_dots
    plot(pk_data(i,2), pk_data(i,1), 'k.', 'MarkerSize', 15);
    end 

    stim_freq_val = str2double(stim_freq(1:end-2));
    [~, idx] = min(abs(pk_data(:,2) - stim_freq_val));
    % ampl_of_peak_closest_to_freq
    amp_freq = pk_data(idx, 1);
    % loc_of_peak_closest_to_freq
    loc_freq = pk_data(idx, 2);

end 














