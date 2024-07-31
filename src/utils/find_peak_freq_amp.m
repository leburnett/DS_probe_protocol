function pk_data = find_peak_freq_amp(data, data_rate, stim_freq)
    % Simple FFT analysis of patch data to flicker stimuli at different frequencies. 
    % Frequencies are 0.5, 1, 4, 8, 16, 32, 64 Hz. 
    % data_rate = 20000
    
    n_x = numel(data);
    
    dT = 1/data_rate; % Set sampling interval
    
    X1 = data(1:n_x-1); % Extract the data segment. Exlcude the last. 
    L1 = length(X1); % Length of data
    
    Y1 = fft(X1); % Perform FFT
    
    p2a = abs(Y1/L1); % Compute two-sided spectrum
    
    p1a = p2a(1:L1/2+1); % Compute sinlge-sided spectrum
    
    p1a(2:end-1) = 2*p1a(2:end-1); % Adjust amplitude of single-sided spectrum
    
    f1 = (1/dT)*(0:(L1/2))/L1; % Generate frequency vector
    % This line creates a frequency vector f1 that corresponds to the frequencies of the FFT result.
    % It ranges from 0 to the Nyquist frequency (half the sampling rate)
    
    %% Plot the amplitude spectrum of the data
    figure
    freq_data = f1(2:100);
    pow_data = p1a(2:100);
    plot(freq_data, pow_data) % Plot the spectrum. 
    title(strcat('Amplitude Spectrum: ', string(stim_freq), 'Hz'))
    xlabel('f (Hz)')
    ylabel('|p1(f)|')
    
    %% Find the frequencies and amplitudes of the peaks.
    % pk_data contains the power amplitudes of the peaks in the first column 
    % and the frequency values of the peaks in the second column. 
    
    [pk_data(:,1), pk_data(:,2)] = findpeaks(pow_data, freq_data, "MinPeakWidth", 0.25);
    pk_data = sortrows(pk_data, 1, "descend"); % Sort based on the peak values with the highest first. 

    hold on 
    % highlight the 3 highest peaks
    plot(pk_data(1,2), pk_data(1,1), 'r.', 'MarkerSize', 15);
    plot(pk_data(2,2), pk_data(2,1), 'r.', 'MarkerSize', 15);
    plot(pk_data(3,2), pk_data(3,1), 'r.', 'MarkerSize', 15);
end 














