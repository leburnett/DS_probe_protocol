function plot_fft_flashes(hz_val, n_reps)

% Load the data
res_files = dir('RES_all_reps*');
load(res_files(1).name, 'data_all_reps')

if hz_val == 0.5
    val = 89;
elseif hz_val == 1
    val = 90;
elseif hz_val == 4
    val = 91;
elseif hz_val == 8
    val = 92;
elseif hz_val == 16
    val = 93;
elseif hz_val == 32
    val = 94;
elseif hz_val == 64
    val = 95;
end 

voltage_data = squeeze(data_all_reps(val, 3, 1:n_reps));

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

% For each rep, extract the relevant voltage data.
for k = 1:n_reps
    da = voltage_data{k};
    data_comb(k, :) = da(1:min_len);
end 
av_resp = mean(data_comb);
        
title_str = strcat(string(hz_val), 'Hz');

% 1 - plot the average response 
figure
subplot(4, 1, 1)
plot(av_resp)
ylabel('voltage (mV)')
xlabel('time')
title(title_str)

data_size = numel(av_resp);
% data_size = numel(data_comb(1,:));
% data = reshape(data_comb, [1, data_size*5]);

Y = fft(av_resp);
% Y = fft(data);

Fs = 20000;            % Sampling frequency                    
% T = 1/Fs;             % Sampling period       
L = data_size;             % Length of signal
% t = (0:L-1)*T; 

% figure
% plot(Fs/L*(0:L-1),abs(Y),"LineWidth",3)
% title("Complex Magnitude of fft Spectrum")
% xlabel("f (Hz)")
% ylabel("|fft(X)|")

% To find the amplitudes of the three frequency peaks, convert the fft spectrum in Y to the single-sided amplitude spectrum. 
% Because the fft function includes a scaling factor L between the original and the transformed signals, rescale Y by dividing by L. 
% Take the complex magnitude of the fft spectrum. 
% The two-sided amplitude spectrum P2, where the spectrum in the positive frequencies is the complex conjugate of the spectrum 
% in the negative frequencies, has half the peak amplitudes of the time-domain signal. 
% To convert to the single-sided spectrum, take the first half of the two-sided spectrum P2. 
% Multiply the spectrum in the positive frequencies by 2. You do not need to multiply P1(1) and P1(end) by 2 because these amplitudes
% correspond to the zero and Nyquist frequencies, respectively, and they do not have the complex conjugate pairs in the negative frequencies.

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs/L*(0:(L/2));

subplot(4, 1, 2:4)
plot(f,P1,"LineWidth",3) 
% title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")

max_val = 5;

xlim([0.1 (hz_val*2.1)])
ylim([-0.1 max_val])

hold on
plot([hz_val, hz_val], [-0.5, max_val], 'k', 'LineWidth', 0.5)
plot([hz_val*2, hz_val*2], [-0.5, max_val], 'k', 'LineWidth', 0.5)

f = gcf; 
f.Position = [499   484   386   543];

%%
% Ts = 1/20000;
% y = fft(data);
% fs = 1/Ts;
% f = (0:length(y)-1)*fs/length(y);
% 
% plot(f,abs(y))
% xlabel('Frequency (Hz)')
% ylabel('Magnitude')
% title('Magnitude')
