
close all

figure
subplot(211)
plot(output.time,output.motor.aftCurrent_A)
hold on
plot(output.time,output.target.aftTarget_A)
ylabel('I(A)')
title('Aft')

subplot(212)
plot(output.time,output.motor.bowCurrent_A)
hold on
plot(output.time,output.target.bowTarget_A)
ylabel('I(A)')
xlabel('time(s)')
title('Bow')
sgtitle('Current')

figure
subplot(211)
plot(output.time,output.motor.aftTorque_Nm)
hold on
plot(output.time,output.target.aftTarget_Nm)
ylabel('\tau(Nm)')
title('Aft')

subplot(212)
plot(output.time,output.motor.bowTorque_Nm)
hold on
plot(output.time,output.target.bowTarget_Nm)
ylabel('\tau(Nm)')
xlabel('time(s)')
title('Bow')
sgtitle('Motor Torque')

figure
subplot(211)
plot(output.time,output.motor.aftRotation_rad)
ylabel('\theta(rad)')
title('Aft')

subplot(212)
plot(output.time,output.motor.bowRotation_rad)
hold on
ylabel('\theta(rad)')
xlabel('time(s)')
title('Bow')
sgtitle('Motor Position')


figure
plot(output.time,output.motor.aftBus_V)
hold on
plot(output.time,output.motor.bowBus_V)
ylabel('Bus (V)')
xlabel('time(s)')
title('Bus Voltage')
legend('Aft','Bow')

figure
subplot(211)
plot(output.time,output.motor.aftPower_W)
ylabel('P(W)')
title('Aft')

subplot(212)
plot(output.time,output.motor.bowPower_W)
hold on
ylabel('P(W)')
xlabel('time(s)')
title('Bow')
sgtitle('Motor Power')

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


figure
subplot(211)
plot(output.time,output.flap.bowFx)
hold on
plot(output.time,output.flap.bowFy)
plot(output.time,output.flap.bowFz)

ylabel('F(N)')
title('Bow')
legend('Fx','Fy','Fz')
grid on

subplot(212)
plot(output.time,output.flap.bowTx)
hold on
plot(output.time,output.flap.bowTy)
plot(output.time,output.flap.bowTz)

ylabel('\tau(Nm)')
title('Bow')
legend('\taux','\tauy','\tauz')
grid on
sgtitle('Bow load cell forces and torques')

figure
subplot(211)
plot(output.time,output.motor.aftRotVelPos_radpers)
hold on
plot(output.time,output.motor.aftRotVelFilt_radpers)
plot(output.time,output.motor.aftRotVel_radpers)

ylabel('\omega(rad/sec)')
title('Aft')

subplot(212)
plot(output.time,output.motor.bowRotVelPos_radpers)
hold on
plot(output.time,output.motor.bowRotVelFilt_radpers)
plot(output.time,output.motor.bowRotVel_radpers)
ylim([-20 20])
ylabel('\omega(rad/sec)')
xlabel('time(s)')
title('Bow')
sgtitle('Motor Angular Velocity')