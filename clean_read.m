close all;
clc;
    % dir_tmp='/Users/pariasamimi/Documents/PhD/Sainty check/2021-04-27 EEG eye open:close _first Good EEG/raw files';
     dir_tmp='/Users/pariasamimi/Documents/PhD/Sainty check/2021-06-25 Filter on and off EEG';
    % dir_tmp='/Users/pariasamimi/Documents/PhD/Sainty check)';
    cd(dir_tmp);
    A=dir;
%% read .xdf file
streams = load_xdf('sub-Laura_ses-S001_task-ActiveNotchOff_run-001_eeg.xdf');
x=streams{1, 3}.time_series(1,:); % 1 channel
x=double(x);
%% periodogram the amplitude vs frequency characteristics of FIR filters and window functions
rng default
Fs = 250;
t = 0:1/Fs:1-1/Fs;
N = length(x);
w = 2^10; % length of the window for the Hanning window 
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(x):Fs/2;
figure(1)
plot(freq,10*log10(psdx))
grid on
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')
% [pxx,f,pxxc] = periodogram(x,rectwin(length(x)),length(x),Fs);
% plot(f,10*log10(pxx))
periodogram(x,rectwin(N),N,Fs)
%% power spectrum of time and frequency with option frequecncy limitation, power spectrum
hold on 
figure(2)
pspectrum(x,Fs,'FrequencyLimits',[0,100])
hold on
%% power spectrum time(minute)-frequency(Hz)-power(db)
figure(3)
pspectrum(x,Fs,'spectrogram','FrequencyLimits',[0,100],'TimeResolution',1)
hold on
figure(4)
pspectrum(x,Fs)
title('Original PSD')
hold off