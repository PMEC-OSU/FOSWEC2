clear; clc; close all

%% Set model parameters
addpath(genpath('utils'))
disp('*** Setting model parameters')
load('FOSWECparameters.mat');
Ts = 0.001;
Tsin = 3; % period for sine wave

%% Define file and model names
appName = 'FOSWEC2app.mlapp';
mdlName = 'FOSWEC2';
buildDir = fullfile('C:','simulink_build');
tgName = 'performance3';

%% === load excel gains =======================================
gainTstep = 1.55*20; % time between change in gains (s) (Represents the wave period times 20 waves)
ExcelGains = readtable('utils/ExcelGains/dampOnly_20230327_2.xlsx');  % read from excel spreadsheet gain values
ExcelGains = table2array(ExcelGains);

mdlInfo = Simulink.MDLInfo(mdlName);
mdlVersion = mdlInfo.ModelVersion;

%% Open the model
disp('*** Open Simulink Model ***')
open_system(mdlName);

%% Load input signals
load('refSigs.mat')



%% Load the model
disp('*** Load and Build Simulink Model ***')
set_param(mdlName,'LoadExternalInput','on');
set_param(mdlName,'StopTime','Inf');
tg = slrealtime();
load_system(mdlName)
set_param(mdlName,'RTWVerbose','off')

%% Build Model
disp('*** Build Simulink RT model for Speedgoat')
slbuild(mdlName)

%% Open the app
disp('*** Start user app ***')
run(appName)



function commandSigs = modifySine(commandSigs,period)

sineDuration = 180;
initLength = 10;
fs = 1000;
amp = 1;  % Leave this at 1 and change in App
t = 1/fs:1/fs:sineDuration;
sine = amp .* sin(2*pi./period*t);
r = 40/t(end);
r_win = tukeywin(length(t),r)';
sine = sine.*r_win;
sine = [zeros(1,fs*initLength) sine zeros(1,fs*initLength)];
t = 1/fs:1/fs:length(sine)/fs;
sig.Sine = timeseries(sine,t);
commandSigs = commandSigs.setElement(2,sig.Sine,'Sine');
end