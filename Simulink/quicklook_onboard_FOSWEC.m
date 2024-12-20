

%% Temperature

figure
plot(output.time,output.temperature.aftMotorTemp_C)
hold on
plot(output.time,output.temperature.bowMotorTemp_C)
legend('aft','bow')
ylabel('temp (\circC)')
xlabel('time (s)')
grid on
title('Motor Temperature')

%% Control gains

figure
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
figure
plot(output.time,output.shoreADC.wmstart)
hold on
plot(output.time,output.shoreADC.led)
legend('wmstart','led')
ylabel('V (V)')
xlabel('time (s)')
grid on
title('Wavemaker start and led signals')

%% Pressure sensors
figure
plot(output.time,output.pressure.pressBowPort_Pa/6894.76)
hold on
plot(output.time,output.pressure.pressBowStbd_Pa/6894.76)
plot(output.time,output.pressure.pressAftPort_Pa/6894.76)
plot(output.time,output.pressure.pressAftStbd_Pa/6894.76)
plot(output.time,output.pressure.pressChassis_Pa/6894.76)
legend('Bow Port','Bow Starboard','Aft Port','Aft Starboard','Chassis')
ylabel('P (psi)')
xlabel('time (s)')
grid on
title('Pressure sensors')

%% Target current and torque
figure
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
figure
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
figure
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

