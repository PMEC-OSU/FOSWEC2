%% Generate all constants needed for FOSWEC model
clear; clc; close all

tgName = 'performance3';

Ts = 0.001;

%% Gear ratios
aft.N = 75/20;
bow.N = 75/20;

%% Motor constants
aft.Kt = 0.9636; % from report and pendulum branch of FOSWEC2Update git
bow.Kt = 0.9438;

%% bandpass filter for motor position signals
bandpass_dt = c2d(tf([1 0],[1 2*pi/100])*tf(2*pi*200,[1 2*pi*200]),Ts,'impulse');

T = 5;
Ts = 0.001;
Tsin = 2;
stepTime = 10;
t = 25:25:200;


save('FOSWECparameters.mat','bow','aft','bandpass_dt','T','Ts','Tsin','stepTime','t')

