clear; clc; close all

%% Set model parameters
disp('*** Setting model parameters')
Ts = 0.001;

%% Define file and model names
appName = 'FOSWEC2app.mlapp';
mdlName = 'FOSWEC2';
buildDir = fullfile('C:','SimulinkBuild');
tgName = 'performance3';

mdlInfo = Simulink.MDLInfo(mdlName);
mdlVersion = mdlInfo.ModelVersion;

%% Open the model
disp('*** Open Simulink Model ***')
open_system(mdlName);

%% Load input signals
disp('*** Load Input Command Signals ***')
load('utils/commandSignals.mat');
waveform = commandSigs;
set_param(mdlName,'ExternalInput','waveform');

%% Load the model
disp('*** Load and Build Simulink Model ***')
set_param(mdlName,'LoadExternalInput','on');
set_param(mdlName,'StopTime','Inf');
load_system(mdlName)
set_param(mdlName,'RTWVerbose','off')

%% Build Model
disp('*** Build Simulink RT model for Speedgoat')
slbuild(mdlName)

%% Open the app
disp('*** Start user app ***')
run(appName)
