%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BME705: Rehabilitation Engineering
% Lab 4: Balance Analysis
%
% Created by: Matija Milosevic, 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name:
% Student ID:
%
%
%%

clear all
close all

load sway_data1.mat
fs=2000;

% analyze slow and fast data seperately

%% Force plate Analysis
% This seciton should follow the first part of the analysysis from Lab 3
% you should obtain the COPnet from Winter et al. 2003 paper

% analyzeFP function: "Given" (do not edit): converst raw forceplate data
% INPUT = 16 channels of raw forceplate data;
% OUTPUT: xCOPL, yCOPL, xCOPR, yCOPR, Fz_R, Fz_L
% Note: Rv_R and Rv_L are vertical forces of right and left forceplate 
% Repeat for esEO_fp
[xCOPL, yCOPL, xCOPR, yCOPR, Rv_R, Rv_L] = analyzeFP2(fp_fast);
[xCOPL2, yCOPL2, xCOPR2, yCOPR2, Rv_R2, Rv_L2] = analyzeFP2(fp_slow);

%%% Calcualte the COPnet
% 1st: Define the global center of pressure coodinate & use these to compute COPnet
% Shift X-coordinates to the middle of the split force plate by +/- 12.5825cm
xCOPLnew = xCOPL - 12.5825;
xCOPRnew = xCOPR + 12.5825;

xCOPLnew2 = xCOPL2 - 12.5825;
xCOPRnew2 = xCOPR2 + 12.5825;

%% Calculate COP for overall system using Winter et al., 2003 [1]: 
% Equation 1 (same Equation 1 in the Lab 4 manual).

xCOP  = xCOPLnew .*(Rv_L)./(Rv_R+Rv_L)+ xCOPRnew.*(Rv_R)./(Rv_R+Rv_L);
yCOP  = yCOPL .* (Rv_L)./(Rv_R+Rv_L) + yCOPR.*(Rv_R)./(Rv_R+Rv_L);

xCOP2  = xCOPLnew2 .*(Rv_L2)./(Rv_R2+Rv_L2)+ xCOPRnew2.*(Rv_R2)./(Rv_R2+Rv_L2);
yCOP2 = yCOPL2 .* (Rv_L2)./(Rv_R2+Rv_L2) + yCOPR2.*(Rv_R2)./(Rv_R2+Rv_L2);


%%% Filter all data
%% Low-pass filter: Butterworth, fc=10Hz
fc=10;
on=4;

[b,a]=butter(on,fc/(fs/2));

xCOPLnewfilt=filtfilt(b,a,xCOPLnew);
xCOPRnewfilt=filtfilt(b,a,xCOPRnew);

yCOPLfilt=filtfilt(b,a,yCOPL);
yCOPRfilt=filtfilt(b,a,yCOPR);

xCOPfilt=filtfilt(b,a,xCOP);
yCOPfilt=filtfilt(b,a,yCOP);



xCOPLnewfilt2=filtfilt(b,a,xCOPLnew2);
xCOPRnewfilt2=filtfilt(b,a,xCOPRnew2);

yCOPLfilt2=filtfilt(b,a,yCOPL2);
yCOPRfilt2=filtfilt(b,a,yCOPR2);

xCOPfilt2=filtfilt(b,a,xCOP2);
yCOPfilt2=filtfilt(b,a,yCOP2);


%% Define AP: y-axis; ML: x-axis

AP = yCOPfilt;
ML = xCOPfilt;

AP2 = yCOPfilt2;
ML2 = xCOPfilt2;


figure;
plot (ML, AP);
figure;
plot (ML2,AP2);






%% EMG Analysis
% This seciton should follow your analysis from Lab 1 to obtain 
% the "evnelope" of the EMG signals.
% Analyze both Sol. and TA muscles.

G=1000; % for "sway_data"; change G to match the gain from your experiment
f = 2000;

% Convert units - express EMG in miliVolts (mV) 
x1 = (sol_fast/g*1000);
x2 = (sol_slow/g*1000);
x3 = (ta_fast/g*1000);
x4 = (ta_slow/g*1000);


% Define time
len1 = length (x1);
len2 = length (x2);
len3 = length (x3);
len4 = length (x4);

t1 = [1:len1]/f;
t2 = [1:len2]/f;
t3 = [1:len3]/f;
t4 = [1:len4]/f;


% Define Envelope filter - Low-pass filter, Butterworth, 4th order, fc=2.5Hz

n=4;
fc=2.5;
[b,a]=butter(n,fc/(f/2));

x_filt = filtfilt(b,a,x_reshape);
janna = rms (x_filt);


% Processing: 1) Rectify; 2) Envelope




%% Plotting the Data
% Considerer the timing of activation of the Sol. and TA muscles with
% respect to the COP sway in the AP direction.

% Define time

