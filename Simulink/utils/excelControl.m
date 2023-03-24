clear; clc; close all
dateStr = datestr(now,'yyyymmdd');

numParameters = 8;  % stiffness and damping values

numValues = 80;     % number of pairs to generate
rng(23);             % set random generator seed
lhs = lhsdesign(numValues,numParameters);   % Latin hypercube sample 
%        aftStiff, aftDamp, aftStiffCC, aftDampCC, bowStiffCC, bowDampCC, bowStiff, bowDamp, , 
PIlim = [0         0        0           0          0           0          0           0         ; ...       % lower limit of kp, kd
         0         100      0           0          0           0          0           100       ];          % upper limit of kp, kd

% scale lhs to be in the desired range of values
rr = PIlim(2,:)-PIlim(1,:); 
ofst = PIlim(1,:);
lhs = lhs.*rr + ofst;

writematrix(lhs,['ExcelGains/','dampOnly_',dateStr,'.xlsx']);