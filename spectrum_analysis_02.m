% closing and clearing the previous data

close all %close all previous data
clear all

%loading data
x = load_open_ephys_data_faster('100_CH12.continuous'); %open channel of interest

%downsample to fs=3 000 from the original fs=30 000
ds =x(1:10:end);

%% baseline information
Fs = 3000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = length (ds);      % Length of signal
t = (0:L-1)*T;        % Time vector
cf = 0.195;           % conversion factor of EEG = 0.195  

%amplitude corrected data
y = cf*ds;

% plot raw data 

plot (t,y); 
title('raw')
%plot(1000*t(1:50),X(1:50))
%title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('t (milliseconds)')
ylabel('amplitude (mikroV)')

%% spectrum analysis vs1
Y = fft(y);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of downsampled data')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%% spectrum analysis vs2

fs=3000; % sample rate
pt=512; % points (2n) for the FFT
range=(pt/2); % range for the spectral plot
t2=0:1/fs:0.6; % time axis
f2=fs*(0:range-1)/pt; % frequency axis
% starts at 0!

Y2=fft(y,pt); % do a 512 pt FFT
Pyy=Y2.*conj(Y2)/pt; % Power spectrum

figure % Plot result
plot(f2,Pyy(1:range)); % Pyy starts at 1 and f(1)=0
title('Powerspectrum')
xlabel('Frequency (Hz)')
ylabel('Power (mV2)')

figure % mV2/Hz

xx = f2;
yy = Pyy(1:range);
yyy = yy';
div = f2./yyy; %mV2/Hz
loglog(xx,div); % Pyy starts at 1 and f(1)=0
title('Powerspectrum')
xlabel('Frequency (Hz)')
ylabel('Power (mV2)')
