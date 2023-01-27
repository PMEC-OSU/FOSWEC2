%% Generate all constants needed for FOSWEC model
clear; clc; close all
Ts = 0.001;
%% Load cell calibration data from ATI for flap load cells

addpath('ATI_loadcells\')
CalFileBow = parseXML('ATI_loadcells/FT30648.cal');
% this needs to change when we get load cell back!!!!
CalFileAft = parseXML('ATI_loadcells/FT30648.cal');

bow.LCmatrix = zeros(6);
bow.LCmatrix = str2num(CalFileBow.FTSensor.Calibration.UserAxis.values);
aft.LCmatrix = zeros(6);
aft.LCmatrix = str2num(CalFileAft.FTSensor.Calibration.UserAxis.values);

for i = 1:5
    bow.LCmatrix(i+1,:) = str2num(CalFileBow.FTSensor.Calibration.(['UserAxis',num2str(i)]).values);
    aft.LCmatrix(i+1,:) = str2num(CalFileAft.FTSensor.Calibration.(['UserAxis',num2str(i)]).values);
end

%% Gear ratios
aft.N = 75/20;
bow.N = 75/20;

%% Motor constants
aft.Kt = 0.9636; % from report and pendulum branch of FOSWEC2Update git
bow.Kt = 0.9438;

%% bandpass filter for motor position signals
bandpass_dt = c2d(tf([1 0],[1 2*pi/100])*tf(2*pi*200,[1 2*pi*200]),Ts,'impulse');


save('../FOSWECparameters.mat','bow','aft','bandpass_dt')

