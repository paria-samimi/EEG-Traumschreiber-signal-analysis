close all;
clear all;
clc;

    dir_tmp='//Users/pariasamimi/Documents/PhD/Sainty check/2021-11-12 Eyes close and open';
    cd(dir_tmp);
    A=dir;
    fs=250;
    %% XDF load 
for j=5
    streams = load_xdf(A(j).name);    
        x=streams{1, 2}.time_series; % all channel
%% for traumschreiber 
    Ch_IDX      = 1:24;% only for traumschreiber 
    Reject_CH   = [24 4 10 11];% only for traumschreiber 
    gg          ={'F7' 'O2' 'T7' 'C3'};
    for i=1:24
        channels{1,i}=streams{1, 2}.info.desc.channels.channel{1, i}.label;
    end
    channels(ismember(channels,gg)) = [];
    Data        = x(Ch_IDX,: );% only for traumschreiber 
    Data(Reject_CH,:)=0;% only for traumschreiber 
    Data(find(Data==isnan(Data)))=0;% only for traumschreiber 
    Data( ~any(Data,2), : ) = [];  % only for traumschreiber 
    x=Data; % only for traumschreiber 
    trig=streams{1, 1}.time_stamps;
%     trig = trig(:,[1:2:end]) ; % odd matrix   %%  WARNING: because we have double here
    trig=double(trig);
    x=double(x);
    selection_idX =streams{1, 2}.time_stamps;     % only for traumschreiber
%     selection_idX = selection_idX(:,[1:2:end]) ; % odd matrix   %%  WARNING: because we have double here
    selection_idx=selection_idX-selection_idX(1,1); % only for traumschreiber sec
    timevec = (selection_idx - 1) / fs;          %for traumschreiber & the -1 is because time is assumed to start at 0
end
%% xdf plot
% 
 for ch =1:24-numel(Reject_CH) 
  plot(  selection_idx ,x(ch,:)+ch*100)
    legend
    ylabel('Amplitute(µV)') 
    xlabel('Time(sec)')     
%     legend("FP1", "FPZ", "FP2", "F7", "F3", "FZ", "F4", "F8", "M1", "T7", "C3", "CZ", "C4", "T8", "M2", "P7", "P3", "PZ", "P4", "P8", "POZ", "O1", "OZ", "O2"); 
    legend('FP1', 'FPZ', 'FP2', 'F3', 'FZ', 'F4', 'F8', 'M1', 'T7', 'C3', 'CZ', 'C4', 'T8', 'M2', 'P7', 'P3', 'PZ', 'P4', 'P8', 'POZ', 'O1', 'OZ');     
    title('xdf file of the eyes open/close experiment with Traumschreiber')
    hold on
 end
hold on 
    Trig=trig-selection_idX(1,1);
    Trig(:,9)=[]; %% only for this one because we have extera triger
    odd = Trig(:,[1:2:end]) ; % odd matrix_close eye
    even = Trig(:,[2:2:end]) ; % even matrix_open eye
    xl=xline(odd,'r','Close');
    hold on
    xL=xline(even,'b','Open' );
hold off  
 %% only one channel
x=x(1,:); % only one channel
 %% PSD Periodogram Using FFT
rng default
t = 0:1/fs:1-1/fs;
N = length(x);
w = 2^10; % length of the window for the Hanning window 
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/length(x):fs/2;
figure()
plot(freq,10*log10(psdx))
grid on
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')
%% power spectrum of time and frequency with option frequecncy limitation, power spectrum
hold on 
figure()
pspectrum(x,fs,'FrequencyLimits',[0,100],'Leakage',0.85)
hold on
%% power spectrum time(minute)-frequency(Hz)-power(db) with triggers

figure()
pspectrum(x,fs,'spectrogram','FrequencyLimits',[0,100],'TimeResolution',1,'Leakage',0.85)
title('Spectrogram')
hold on
odd=odd/60;
xl=xline(odd,'r','Close');
hold on
even=even/60;
xL=xline(even,'b','Open' );
hold on
figure()
pspectrum(x,fs)
title('Original PSD')

%% the persistence spectrum of the signal. 
figure()
pspectrum(x,fs,'persistence', 'FrequencyLimits',[0 100],'TimeResolution',1)
title('persistence spectrum')
hold on
figure()
%%
set(groot,'defaulttextinterpreter','latex');
win=[ceil(0.25*fs) ceil(1*fs)  ceil(5*fs)];
col = {'r', 'k', 'b'};
for i=1:1:size(win,2)
nfft = win(i);
noverlap = 0.5*win(i);
[pxx,f] = pwelch(x,win(i),noverlap,nfft,fs,'onesided');
length(f);
semilogy(f, pxx, col{i});
hold on
grid on
legend('0.25 sec', '1 sec', '5 sec', 'FontSize', 24);
end
