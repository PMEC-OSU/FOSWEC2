close all

%% Control gains

figure("Name",'Damping in flap frame')
subplot(2,2,1)
plot(output.time,output.ctrlGains.aftDamping)
hold on
plot(output.time,output.ctrlGains.bowDamping)
legend('aft','bow')
ylabel('Damping (Nms)')
xlabel('time (s)')
grid on
title('Damping in flap frame')

subplot(2,2,2)
plot(output.time,output.ctrlGains.aftDampCC)
hold on
plot(output.time,output.ctrlGains.bowDampCC)
legend('aft','bow')
ylabel('Damping CC (Nms)')
xlabel('time (s)')
grid on
title('Damping Cross Coupling in flap frame')

subplot(2,2,3)
plot(output.time,output.ctrlGains.aftStiffCC)
hold on
plot(output.time,output.ctrlGains.bowStiffCC)
legend('aft','bow')
ylabel('Stiffness CC (Nm)')
xlabel('time (s)')
grid on
title('Stiffness Cross Coupling in flap frame')

subplot(2,2,4)
plot(output.time,output.ctrlGains.aftStiffness)
hold on
plot(output.time,output.ctrlGains.bowStiffness)
legend('aft','bow')
ylabel('Stiffness (Nm)')
xlabel('time (s)')
grid on
title('Stiffness in flap frame')

%% Shore ADC
figure('Name','wmstart and led')
plot(output.time,output.shoreADC.wmstart)
hold on
plot(output.time,output.shoreADC.led)
legend('wmstart','led')
ylabel('V (V)')
xlabel('time (s)')
grid on
title('Wavemaker start and led signals')

%% Pressure sensors
figure('Name','Pressure Sensors')

plot(output.time,output.pressure.pressChassis_Pa/6894.76)
legend('Chassis')
ylabel('P (psi)')
xlabel('time (s)')
grid on
title('Pressure sensors')

%% Target current and torque
figure('Name','Target current and torque')
subplot(2,1,1)
plot(output.time,squeeze(output.target.aftTarget_A))
hold on
plot(output.time,squeeze(output.target.bowTarget_A),'--')
legend('aft','bow')
ylabel('I(A)')
xlabel('time (s)')
grid on
title('Target Current')

subplot(2,1,2)
plot(output.time,squeeze(output.target.aftTarget_Nm))
hold on
plot(output.time,squeeze(output.target.bowTarget_Nm),'--')
legend('aft','bow')
ylabel('\tau (A)')
xlabel('time (s)')
grid on
title('Target Torque')

%% motor feedback signals
figure('Name','Motor feedback signals')
subplot(2,3,1)
plot(output.time,output.motor.aftCurrent_A)
hold on
plot(output.time,output.motor.bowCurrent_A)
legend('aft','bow')
ylabel('I(A)')
xlabel('time (s)')
grid on
title('Drive Current')
subplot(2,3,4)
plot(output.time,output.motor.aftTorque_Nm)
hold on
plot(output.time,output.motor.bowTorque_Nm)
legend('aft','bow')
ylabel('\tau(A)')
xlabel('time (s)')
grid on
title('Drive Torque')

subplot(2,3,2)
plot(output.time,output.motor.aftPos_rad)
hold on
plot(output.time,output.motor.bowPos_rad)
legend('aft','bow')
ylabel('\theta(rad)')
xlabel('time (s)')
grid on
title('Drive Position')
subplot(2,3,5)
plot(output.time,output.motor.aftRotVel_radpers)
hold on
plot(output.time,output.motor.bowRotVel_radpers)
plot(output.time,output.motor.aftRotVelfromPos_radpers)
plot(output.time,output.motor.bowRotVelfromPos_radpers)
plot(output.time,squeeze(output.motor.aftRotVelFilt_radpers))
plot(output.time,squeeze(output.motor.bowRotVelFilt_radpers))
legend('aft Vel','bow Vel','aft Vel from Pos','bow Vel from Pos','aft Vel Filt','bow Vel Filt')
ylabel('\omega (rad/s)')
xlabel('time (s)')
grid on
title('Drive Velocity')

subplot(2,3,3)
plot(output.time,output.motor.aftBus_V)
hold on
plot(output.time,output.motor.bowBus_V)
legend('aft','bow')
ylabel('V (V)')
xlabel('time (s)')
grid on
title('Drive Bus Voltage')
subplot(2,3,6)
plot(output.time,output.motor.aftPower_W)
hold on
plot(output.time,output.motor.bowPower_W)
legend('aft','bow')
ylabel('P (W)')
xlabel('time (s)')
grid on
title('Drive Power')

%% Flap signals assuming lossless drivetrain
figure('Name','Flap signals')
subplot(2,1,1)
plot(output.time,output.flap.aftFlap_deg)
hold on
plot(output.time,output.flap.bowFlap_deg)
legend('aft','bow')
ylabel('\theta (\circ)')
xlabel('time (s)')
grid on
title('Flap position')

subplot(2,1,2)
plot(output.time,output.flap.aftFlap_Nm)
hold on
plot(output.time,output.flap.bowFlap_Nm)
legend('aft','bow')
ylabel('\tau (Nm)')
xlabel('time (s)')
grid on
title('Flap Torque')

%% Power analyzer inverter
figure('Name','Power Analyzer Inverter')
ax(1) = subplot(3,2,1);
plot(output.time,output.motor.aftPower_W)
hold on
% plot(output.time,output.inverter.aft_W)
plot(output.time,-output.inverter.aft_sigma_W)
plot(output.time,output.capacitor.aft_W)

legend('aft motor shaft power','aft inverter power','aft capacitor power')
ylabel('Power (W)')
grid on

ax2(1) = subplot(3,2,2);
plot(output.time,output.motor.bowPower_W)
hold on
% plot(output.time,output.inverter.bow_W)
plot(output.time,-output.inverter.bow_sigma_W)
plot(output.time,output.capacitor.bow_W)
legend('bow motor shaft power','bow inverter power','bow capacitor power')
ylabel('Power (W)')
grid on

ax(2) = subplot(3,2,3);
plot(output.time,output.inverter.aft_sigma_A)
ylabel('Current (A)')
grid on

ax2(2) = subplot(3,2,4);
plot(output.time,output.inverter.bow_sigma_A)
ylabel('Current (A)')
grid on

ax(3) = subplot(3,2,5);
plot(output.time,output.inverter.aft_sigma_V)
ylabel('Voltage (V)')
grid on

ax2(3) = subplot(3,2,6);
plot(output.time,output.inverter.bow_sigma_V)
ylabel('Voltage (V)')
grid on

xlabel('time(s)')

linkaxes(ax, 'x')
linkaxes(ax2, 'x')

%% Power analyzer capacitor
figure('Name','Power Analyzer Capacitor')
ax(1) = subplot(3,2,1);
plot(output.time,output.motor.aftPower_W)
hold on
plot(output.time,output.capacitor.aft_W)

legend('aft motor shaft power','aft capacitor power')
ylabel('Power (W)')
grid on

ax2(1) = subplot(3,2,2);
plot(output.time,output.motor.bowPower_W)
hold on
plot(output.time,output.capacitor.bow_W)
legend('bow motor shaft power','bow capacitor power')
ylabel('Power (W)')
grid on

ax(2) = subplot(3,2,3);
plot(output.time,output.capacitor.aft_mean_A)
ylabel('Current (A)')
grid on

ax2(2) = subplot(3,2,4);
plot(output.time,output.capacitor.bow_mean_A)
ylabel('Current (A)')
grid on

ax(3) = subplot(3,2,5);
plot(output.time,output.capacitor.aft_mean_V)
ylabel('Voltage (V)')
grid on

ax2(3) = subplot(3,2,6);
plot(output.time,output.capacitor.bow_mean_V)
ylabel('Voltage (V)')
grid on

xlabel('time(s)')

linkaxes(ax, 'x')
linkaxes(ax2, 'x')