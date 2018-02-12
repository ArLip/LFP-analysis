%% preprcessing
% closing and clearing the previous data
close all %close all previous data
clear all

%loading data
x = load_open_ephys_data_faster('100_CH19.continuous'); %open channel of interest

%downsample to fs=3 000 from the original fs=30 000
ds =x(1:10:end);

%% baseline information

Fs = 3000;            % Sampling frequency  is also the max frequency of the FFT                   
T = 1/Fs;             % Sampling period       
L = length (ds);      % Length of signal 
t = (0:L-1)*T;        % Time vector 
cf = 0.195;           % conversion factor of EEG = 0.195  

%amplitude corrected data
y = cf*ds;            % cf = 0.195 conversion factor (1483572x1)

%% filtering
%theta filtering 4-12 Hz
filt_theta = eegfilt(y',3000,4,12);

%% delete and detect outliers
[B,idx,outliers]=deleteoutliers(filt_theta,0.05,1);     %B=outliers deleted (NaN), idx=index of outliers, outliers=values detected as outliers

%% reshape the data into matrix each column presenting 4 sec epoch 
balan= (B (1:(100*12000)));
redata = reshape(balan,12000,[]); 

%% the abs mean of each column
M = mean(abs(redata));

%% find the maximal peaks
pks = findpeaks(M); 
findpeaks(M);

[psor,lsor] = findpeaks(M,'SortStr','descend');  %psor is the amplitude value in descending order and lsor is the id of the corresponding column in the same descending order as psor
findpeaks(M);
text(lsor+.02,psor,num2str((1:numel(psor))'))

%% choose only the first 20 column with highest mean theta amplitude values
s_20 = lsor(1:20);                      % The first 20 colums 

y_short=y (1:(100*12000));              % original data fs=3000
y_reshape = reshape(y_short,12000,[]);
M_20 = y_reshape(:,[s_20]); 

%% spectrum analysis vs2 (Signal proecessing for neuroscientist)
fs=3000; % sample rate
pt=3000; % points (2n) for the FFT
range=(pt/2); % range for the spectral plot
t2=0:1/fs:0.6; % time axis
f2=fs*(0:range-1)/pt; % frequency axis
% starts at 0!

Y2=fft(M_20,pt); % do a 3000 pt FFT, 1 value corresponds 1 Hz
Pyy=Y2.*conj(Y2)/pt; % Power spectrum


%% makes a grand average of FFT

S = sum(Pyy,2);



figure % Plot result
plot(f2,S(1:range)); % Pyy starts at 1 and f(1)=0
title('Powerspectrum')
xlabel('Frequency (Hz)')
ylabel('Power (mV2)')

figure % mV2/Hz
xx = f2;       
yy = S(1:range);
yyy = yy';
div = f2./yyy; %mV2/Hz
loglog(xx,div); % Pyy starts at 1 and f(1)=0
title('Powerspectrum')
xlabel('Frequency (Hz)')
ylabel('Power (mV2)')

%%
% for further analysis

%raw data
x_axis=f2(:,1:150);       % f2=fs*(0:range-1)/pt; % frequency axis
y_axis = div (1:150);       % div = f2./yyy; %mV2/Hz

%smoothed data
yy_axis=smooth(y_axis);

figure      %smoothed data
loglog(x_axis,yy_axis); % Pyy starts at 1 and f(1)=0
title('Smoothed powerspectrum')
xlabel('Frequency (Hz)')
ylabel('Power (mV2)')
