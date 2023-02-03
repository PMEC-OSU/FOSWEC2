
close all

figure
subplot(211)
plot(output.time,output.motor.aftMeas_A)
hold on
plot(output.time,output.target.aftTarget_A)
ylabel('I(A)')
title('Aft')

subplot(212)
plot(output.time,output.motor.bowMeas_A)
hold on
plot(output.time,output.target.bowTarget_A)
ylabel('I(A)')
xlabel('time(s)')
title('Bow')
sgtitle('Current')

figure
subplot(211)
plot(output.time,output.motor.aftMeas_Nm)
hold on
plot(output.time,output.target.aftTarget_Nm)
ylabel('\tau(Nm)')
title('Aft')

subplot(212)
plot(output.time,output.motor.bowMeas_Nm)
hold on
plot(output.time,output.target.bowTarget_Nm)
ylabel('\tau(Nm)')
xlabel('time(s)')
title('Bow')
sgtitle('Motor Torque')

figure
subplot(211)
plot(output.time,output.motor.aftMotor_rad)
ylabel('\theta(rad)')
title('Aft')

subplot(212)
plot(output.time,output.motor.bowMotor_rad)
hold on
ylabel('\theta(rad)')
xlabel('time(s)')
title('Bow')
sgtitle('Motor Position')

figure
subplot(211)
plot(output.time,output.motor.aftMotor_radpers)
ylabel('\omega(rad/sec)')
title('Aft')

subplot(212)
plot(output.time,output.motor.bowMotor_radpers)
hold on
ylabel('\omega(rad/sec)')
xlabel('time(s)')
title('Bow')
sgtitle('Motor Angular Velocity')

figure
subplot(211)
plot(output.time,output.motor.aftMotor_W)
ylabel('P(W)')
title('Aft')

subplot(212)
plot(output.time,output.motor.bowMotor_W)
hold on
ylabel('P(W)')
xlabel('time(s)')
title('Bow')
sgtitle('Motor Power')

% figure
% subplot(221)
% plot(output.time,output.flap.aftLoadCell(:,1:3))
% ylabel('F(N)')
% title('Aft')
% legend('Fx','Fy','Fz')
% 
% subplot(222)
% plot(output.time,output.flap.aftLoadCell(:,4:6))
% ylabel('\tau(Nm)')
% title('Aft')
% legend('\taux','\tauy','\tauz')

figure
subplot(211)
plot(output.time,output.flap.bowLoadCell(:,1:3))
ylabel('F(N)')
title('Bow')
legend('Fx','Fy','Fz')
grid on

subplot(212)
plot(output.time,output.flap.bowLoadCell(:,4:6))
ylabel('\tau(Nm)')
title('Bow')
legend('\taux','\tauy','\tauz')
grid on
sgtitle('Bow load cell forces and torques')


figure
subplot(211)
plot(output.time,output.flap.aftFlap_rad)
ylabel('\theta(rad)')
title('Aft')

subplot(212)
plot(output.time,output.flap.bowFlap_rad)
hold on
ylabel('\theta(rad)')
xlabel('time(s)')
title('Bow')
sgtitle('Flap Rotation')

figure
subplot(211)
plot(output.time,output.temperature.aftMotorTemp_C)
ylabel('temperature(\circC)')
title('Aft')

subplot(212)
plot(output.time,output.temperature.bowMotorTemp_C)
hold on
ylabel('temperature(\circC)')
xlabel('time(s)')
title('Bow')
sgtitle('Motor Temperature')

figure
plot(output.time,output.pressure.pressAftPort_Pa)
hold on
plot(output.time,output.pressure.pressAftStbd_Pa)
plot(output.time,output.pressure.pressBowPort_Pa)
plot(output.time,output.pressure.pressBowStbd_Pa)
plot(output.time,output.pressure.pressChassis_Pa)
xlabel('time(s)')
ylabel('pressure(Pa)')
legend('Aft Port','Aft Starbord','Bow Port','Bow Starboard','Chassis')
sgtitle('Pressures')

