%% closing and clearing the previous data

close all %close all previous data
clear all

%%loading data
x = load_open_ephys_data_faster('100_CH12.continuous'); %open channel of interest

%%downsample to fs=3 000 from the original fs=30 000
ds =x(1:10:end);

%% baseline data
Fs = 3000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = length (ds);      % Length of signal
t = (0:L-1)*T;        % Time vector
cf = 0.195;           % conversion factor of EEG = 0.195 

%%amplitude corrected data
y = cf*ds;

%% filtering
%SWD filtering 7-23 Hz

ds_filt_SWD = eegfilt(y',3000,7,23);

%noise filtering 80-90 Hz

ds_filt_80_90 = eegfilt(y',3000,80,90);
 
%% delete outliers
zz=deleteoutliers(ds_filt_80_90,0.05,1);

%% Figures

figure
plot(ds_filt_SWD)
title('filtered SWD (7-25 Hz)')
xlabel('t (milliseconds)')
ylabel('amplitude (mikroV)')

figure
plot(ds_filt_80_90)
title('filtered noise (80-90 Hz)')
xlabel('t (milliseconds)')
ylabel('amplitude (mikroV)')

figure
plot(zz)
title('deleted noise (80-90 Hz)')
xlabel('t (milliseconds)')
ylabel('amplitude (mikroV)')

figure
plot(t,zz+40,t,ds_filt_80_90)
title('deleted noise (80-90 Hz)')
xlabel('t (milliseconds)')
ylabel('amplitude (mikroV)')


figure
plot(t,ds_filt_80_90-zz)
title('deleted noise (80-90 Hz)')
xlabel('t (milliseconds)')
ylabel('amplitude (mikroV)')



