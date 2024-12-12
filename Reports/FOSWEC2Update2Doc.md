# FOSWEC2 Repair and Upgrade

7/25/2023

# Contents

[Introduction 3](#_Toc137717433)

[Encoder swap 5](#_Toc137717434)

[Pendulum tests 5](#_Toc137717435)

[Encoder Comparison 8](#_Toc137717436)

[EtherCAT network definition 10](#_Toc137717437)

[Motor checkout with flaps disconnected 10](#_Toc137717438)

[Flap tensioning 11](#_Toc137717439)

[Flap Load cell checkout 11](#_Toc137717440)

[Flap SSI encoder checkout 11](#_Toc137717441)

[Pressure sensor checkout 11](#_Toc137717442)

[Motor temperature checkout 13](#_Toc137717443)

[VRU accelerometer checkout 13](#_Toc137717444)

[Inverted dry flap reference command 13](#_Toc137717445)

[Inverted dry flap feedback 16](#_Toc137717446)

[Graphical User Interface (GUI) development 24](#_Toc137717447)

[Wave Basin Deployment 26](#_Toc137717448)

[Wave Basin Testing 27](#_Toc137717449)

[Encoder Feedback Filter Design 32](#_Toc137717450)

[Shaft failures 33](#_Toc137717451)

[Summary of FOSWEC2 updates 38](#_Toc137717452)

[Future Work 39](#_Toc137717453)

[Appendix A 39](#_Toc137717454)

# Introduction

This report documents the efforts in repairing and upgrading the FOSWEC2 device. Major efforts include:

- Replacement of motor encoders from analog to digital based design
- Pendulum testing of motors and new encoders to establish torque constants
- Comparison of encoder noise pre and post encoder swap
- EtherCAT network definition and motor checkout without flaps
- Dry tests of flaps in an upside-down orientation of the FOSWEC2
- Repair and recalibration of aft flap 6DOF load cell whose cable was compromised
- Complete update to MATLAB/Simulink operating software to update to new Speedgoat operating system and user interface
- Wave basin testing of the FOSWEC2

Updated system diagram shown in Figure 1.

![FOSWEC2_signalDiagramOSU](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/06239213-2808-4c4b-a724-913d889dfca2)

_Figure 1: Updated FOSWEC2 system diagram_

#

# Encoder swap

A feedback stability issue with the FOSWEC2 deployment in February 2020 was identified and potential solutions explored. One issue identified was encoder noise. The original absolute encoder used on the FOSWEC2 was the Sick SKS36-HFA0-K02 with Hyperface interface. The encoder specs include 128 sine/cosine periods per revolution and 4096 total number of steps. As this is a hybrid analog/digital transducer, it is possibly susceptible to noise from the surrounding environment.

The Heidenhain ECN 1123 512 with EnDat2.2 interface was chosen as a fully digital replacement absolute encoder. This encoder has 23 bits per revolution or 8388608 position values per revolution. Custom adapter pieces were designed and fabricated by Sandia National Laboratories to allow for integration of the new encoder. A cad rendering of these pieces is shown in Figure 2

![image002](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/b16b3acc-fbdb-4119-a5e1-37b38c04eb57)![image003](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/ea30efc9-7dce-4163-addf-3d79a134ed0b)

_Figure 2: Custom adapter parts for new encoders_

# Pendulum tests

Pendulum tests were used to verify functionality of the new encoders and verify the torque constant for the motors. These tests are designed to determine the relationship between torque and current. This is necessary and relevant because most motor drives have current as their input and a relationship between commanded current and actual torque measured is desired. For these tests a custom coupler needed to be fabricated connecting the motor to the torque transducer. The rest of the test stand was repurposed from another project. The bench test setup is shown in Figure 3.

![image004](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/dac749a1-a333-4dfb-ad5d-965a264bb3eb)

_Figure 3: Bench setup of pendulum tests_

Ramp tests were conducted to estimate the torque constant with a maximum current of 20A achieved. The test consisted of four ramp events two clockwise and two counterclockwise alternating as shown in Figure 4.

![image005](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/296d8e5b-bf63-4dbe-a84b-6ef925f918bb)

_Figure 4: Torque vs. Time for pendulum ramp tests_

The torque-current relationship was plotted for each ramp segment as shown in Figure 5.

![image006](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/ad62b1cf-1390-4dfb-b0d6-b692bfa92bdd)

_Figure 5: Torque vs. Current relationship used to estimate torque constant_

and the MATLAB polyfit command was used to estimate the torque constant. This was done for the four ramp segments and the Kt values averaged. This was then repeated for the Bow motor and the results are summarized in Table 1.

_Table 1: Kt estimates from pendulum tests_

| **Motor** | **Kt (Nm/A)** |
| --- | --- |
| **Aft** | 0.9636 |
| **Bow** | 0.9438 |

The datasheet for the motor (MF0150025 with the 300V winding) lists a torque constant of 1.021 Nm/A +/- 10%, which gives limits of 0.9189 Nm/A and 1.1231 Nm/A. The measured torque constants for the bow and aft motors fall within these limits.

# Encoder Comparison

Initial evaluation of the noise characteristics comparing the old and new encoders position is detailed in this section. Ten seconds of data from dry testing on 12/18/2019 at 12:32:30 was used for the old encoder data. A section of test period where no commands were being issued to the drive was used. For the new encoders a pendulum bench test (aft20amps.mat and bow20amps.mat) from 9/1/2022 and 8/29/2022 respectively was used. Comparison of the time series of the two encoder signals are shown in Figure 6. Time from the two tests have been shifted to be on the same axis. Also, the means have been subtracted from both signals to be on the same rotation scales.

![image007](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/872aaeba-0701-42ef-86e3-f23b7cf04846)

_Figure 6: Comparison of old and new FOSWEC encoders_

Comparison of the variance of the signals is shown in Figure 7. While this result is very encouraging, the true test will be when we are applying feedback in an in-water test.

![image008](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/1434fb02-03f2-4646-95d3-c9ca996ffc10)

_Figure 7: Variance comparison_

# EtherCAT network definition

Because of changes in the Beckhoff module configuration due to changes in encoder needs and redundant modules, the EtherCAT network needed to be redefined. Additionally, addition of the Mini-DAQ to the EtherCAT network will require re-definition. This proved to be a challenge, as getting the TwinCAT software to recognize the network with the two motor drives present and customizing the motor drive inputs and outputs took a lot of trial and error. AMC\_AppNote\_017.pdf was used as a guide for customizing the AMC EtherCAT network ESI, and eventually a custom network configuration adding drive bus voltage was achieved.

# Motor checkout with flaps disconnected

A Simulink model was created that configures and sends commands to the motors. Timeout errors were present when trying to set the operation mode of both motors at the same time through Simulink, so configuration was set to operation mode 10 which is cyclic torque mode through the DriveWare software. Code was left in Simulink model but commented out. A sinusoidal torque signal of 1A at 1s was sent to both motors with oscillating motion on both motors confirmed. Scaling on motor position was confirmed by commanding zero and manually rotating each motor one rotation and recording position data.

# Flap tensioning

Figure 8 details the methodology for adjusting the belt tension. Any time the belts get removed, the tension should be adjusted upon replacement. It doesn't need to be real tight, just snug. As you move the flap back and forth, make sure the return side doesn't have any slack.

![image009](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/c6cbc22b-b2f3-455a-8632-8156f249470f)

_Figure 8: Methodology for belt tensioning_

# Flap Load cell checkout

Checkout of FT30648 on the bow flap indicated a large negative offset in z (~-2500N). The flap and FOSWEC was disconnected from the load cell. While recording, compression force was applied by hand and the offset flipped to positive (~700N). Known weights were applied to the load cell on the bench and reasonable readings around this positive offset were observed. Flap was reconnected and similar positive offset was observed. Simulink model was updated to translate the coordinate system of the load cell into HWRL basin coordinate system.

FT17382 was returned to ATI for repair and calibration, was integrated, but ultimately abandoned.

# Flap SSI encoder checkout

Efforts to incorporate the Flap SSI encoder outputs in the model failed. Configuration in TwinCAT failed to create a scenario where the LED's indicating valid data on the EL5002 module would light up. Many different configurations were attempted without satisfactory results. I hooked up an oscilloscope to the clock and data signals and they are both showing signals, however movement of the encoder does not induce changes in the count values. Needs further evaluation or change of sensor.

# Pressure sensor checkout

Nominal gains and offsets were used for the pressure gauges due to lack of factory calibration data. A pressure gauge calibration study was undertaken to get an understanding for these nominal gains and offsets.

There is one absolute pressure gauge inside the submerged enclosure. The main purpose of this gauge is monitoring and maintaining pressure inside the submerged enclosure and providing a reference for the gauge sensors in the enclosure. Its model number is TD1200BBA005003D002X and the range is 0-50psi. It is connected to a Beckhoff module EL3154, 4-20mA input. The EL3154 outputs a 16-bit integer. The sign bit is ignored and the range of 0-2^15 corresponds to 4-20mA. Therefore, the conversion from counts to psi is 50/2^15 with no offset.

There are four gauge style pressure sensors measuring the pressure between the inside and outside of the enclosure. These have a model number TDH41BGV01503Q005. Despite the data sheet indicating a range of Vac-15psi for this model number, the range listed on the sensor is -14.7-15 psi. These are connected to a Beckhoff module EL3154, 4-20mA input. The EL3154 outputs a 16-bit integer. The sign bit is ignored and the range of 0-2^15 corresponds to 4-20mA. To verify proper scaling for the sensors a study was conducted. First the performance of the EL3154 was tested. A decade resistance box was connected to the input of the EL3154 and was changed to input a 4-20mA input. The signal read in TwinCAT3 was then verified to be in the range of 0-2^15-1 for this current range as shown in Figure 9.

Next we hooked up one of the pressure sensors to a Fluke 2700G Series Reference Pressure Gauge and a pump and increased the pressure to 15 psi. Pressure was read into Simulink via the EL3154 and displayed in real-time on the screen. A video was taken of both the calibration and Simulink screen as shown in Figure 10. Appendix A gives a summary of the data analyzed. It was determined that using nominal gains was good enough at this time and were assumed as a slope of 29.7/2^15-1, and offset of -14.7.

![image010](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/0efb4cc6-ccbc-4324-8d00-95e9016f4c33)

_Figure 9: Testing the EL3154 by inputting 4-20mA and verifying output in TwinCAT3._

![image011](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/a32e6459-eb89-4392-982f-c15c3522bf61)

_Figure 10: Recording pressure on calibrator and with Simulink to verify scaling and offset values._

# Motor temperature checkout

Motor temperature was logged using the Beckhoff EL3692 modules and values seemed in a reasonable range and increased when the motor was loaded.

# VRU accelerometer checkout

VRU unit was disconnected from enclosure housing and manually rotated to verify angular positions.

# Inverted dry flap reference command

Current reference signals were sent to the drives to command ramps, sine, white noise, and chirp signals. All were verified to work on the flaps within the range of the flap endstops. Data was collected and stored in the DryReference1 experiment on the HWRL share. Figure 11 shows the inverted dry flap test in progress.

![image012](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/bfe7069c-4c1a-462b-ad63-b294bc435ae5)

_Figure 11: Inverted flap reference input test_

Figure 12 shows the target and actual reported current signal from the motor drive. Motor drive control of current as reported is quite good.

![image013](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/7d5183e3-0be4-45ec-9dca-80ea50d329ed)

_Figure 12: Reference Current Ramps_

Figure 13 shows the target and actual sine wave response from the motor drive. Target matches actual quite well.

![image014](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/3f9c07f4-1a79-4a2f-ab13-fea146885952)

_Figure 13: Reference Current Sine_

Figure 14 shows the target and actual current for a white noise input. Motor drive controller tracks well.

![image015](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/dbf5933d-63d5-4d69-af7f-8adef21e02cc)

_Figure 14: Reference Current White Noise_

Figure 15 shows the target and actual current fort a chirp input. Motor drive current control tracking well.

![image016](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/08b7079e-d693-4ad1-8446-ff36b411d904)

_Figure 15: Reference Current Chirp_

# Inverted dry flap feedback

Feedback control was implemented to enable the application of velocity and position proportional torque commands. In the control software, conversion from the motor frame to the flap frame is implemented so that damping and stiffness terms are input in the flap frame.

The encoders on the motors are directly connected to the motor drives and the motor drives report the "Position Actual Value". The software then takes a discrete-time derivative to calculate a velocity. Because of noise in the position signal, both position and velocity feedback signals need to be filtered. Starting with the velocity feedback signal, a 15Hz cutoff frequency first order low pass filter via the discrete transfer function block in Simulink. A second order bandpass filter is applied to the position signal. Velocity proportional feedback control is implemented by sending a current command to the motor drive. Calculation of the current is done with the following:

where is the commanded motor torque, is the velocity proportional damping term at the flap, is the angular velocity at the motor, is the gear ratio , and is the torque constant.

An inverted flap dry test was completed by testing the velocity proportional feedback loop. The flaps were actuated manually with a broomstick as shown in Figure 16. The control loop was activated with an increasing damping value starting at 1 Nms/rad and increasing to 7 Nms/rad. For each damping value the flap was manually actuated several cycles with a broomstick. This test was repeated for the aft and bow flaps and results are shown in Figure 17. Plotted are both the derivative of the drive reported position, and the filtered version of this signal. It is notable that as the applied damping increases, the noise on the motor velocity increases.

![image024](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/996f40d0-1be0-461c-8877-71002a9e4a02)

_Figure 16: Manual flap actuation to test active feedback_

![image025](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/77887ed1-ca54-4001-a07c-a5cfa55f7a10)

_Figure 17: Inverted flap velocity proportional feedback test_

Zooming into one cycle of the bow motor velocity for B = 7 Nms is shown in Figure 18. Even with a fairly aggressive low pass filter, the noise is being transferred through. This results in mechanical resonance in the structure that appears to increase with applied damping.

![image026](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/0311271b-4362-463f-85e6-07f8d6c1f9c9)

_Figure 18: Zoomed in bow velocity for B=7 Nms_

A longer test with a damping of 7 Nms applied was done and results analyzed in the frequency domain as shown in Figure 19.

![image027](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/6177f30a-9909-4531-8972-8d9f39dda651)

_Figure 19: Feedback low pass filter with cutoff 15Hz_

The Digital Filter Design block in Simulink was employed to generate a better filter for the velocity feedback. A low pass IIR Maximally Flat filter of 8th order with a sampling frequency of 1 kHz and a cutoff frequency of 10 Hz was chosen as shown in Figure 20. The test was then repeated with the same conditions with the new filter with the results shown in Figure 21.

![image028](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/2a9e8a65-3bb2-4ba2-a077-9c7c2eb51983)

_Figure 20: Digital Filter design in Simulink_

![image029](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/0baa6a08-bc8b-4ed6-947e-82217139aaf5)

_Figure 21: Updated feedback filter results_

The settings for the Digital Filter Design block in Simulink were then modified to try and decrease the phase lag between the filtered and unfiltered velocities. Decreasing the filter order to two for the numerator and denominator seemed a good tradeoff of stability and phase delay. Filter design shown in Figure 22. The resulting frequency plots are shown in Figure 23. The phase lag is significantly decreased while continuing to eliminate the high frequency noise.

![image030](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/974673b1-0bf9-43b8-8a82-e32945af0567)

_Figure 22: Reducing the filter order to 2 to improve phase lag_

![image031](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/b0d680a2-fbd7-4001-b3d8-1e2874164062)

_Figure 23: Reduced numerator and denominator filter order to 2 and fc = 10 Hz_

A notch filter was then employed to focus on the peak around 54Hz introduced by the second order filter. The "Notch-Peak Filter" block was used with a center frequency of 54.8 Hz and a 3dB Bandwidth specification of 5 Hz.

![image032](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/04beb0e0-635d-4a81-8651-934eb3b18c91)

_Figure 24: Notch plus lowpass filter results_

# Graphical User Interface (GUI) development

A graphical user interface was developed using the Matlab toolbox App Designer. This tool allows for creating a user interface that allows for interacting with a model without having to interact with the underlying code. Inputs are available in convenient forms such as sliders, spinners, and text fields and real time monitoring of signals from the output of the system can be displayed in convenient forms including axes, gauges, indicators, etc… As part of the GUI development, at the finish of running the model, the data is retrieved from the Speedgoat system and archived for post processing. A snapshot of the GUI in operation is shown in Figure 25.

![image033](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/519f87d0-bfc2-4e84-bad5-290f3e73d707)

_Figure 25: GUI snapshot after white noise reference command_

#

# Wave Basin Deployment

FOSWEC2 was fixed to the basin floor using threaded rod extending through hollow tubes.

![image034](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/56f5e24a-3a6a-4d46-b544-a7ea03c84a71)

_Figure 26: FOSWEC2 being lowered down over threaded rods_

![image035](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/d52b9f07-c56e-4639-a3db-f5d943c10125)

_Figure 27: Threaded rods pass through steel plates and wingnuts are used to secure the FOSWEC2 to the basin floor_

# Wave Basin Testing

System Identification no wave tests were conducted first. Small improvements to the data collection and GUI were performed throughout with changes tracked in git.

Experiment Reference1 was conducted to characterize the system using input output methods. Three white noise realizations of drive current command were used to excite the flap with a drive measured torque while encoder position was recorded. An admittance model was then estimated using the MATLAB system identification toolbox. Admittance is assumed here to be the ratio of flap position and flap torque

where is the admittance, is the angular position at the flap, is the torque at the flap, is the angular position at the motor, is the torque at the motor, and is the gear ratio between the motor and flap which is . Figure 28 shows this admittance estimate for trials two through seven of the Reference1 experiment.

![image043](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/a5c5803a-a39f-45f8-83f2-4aa9abf6b607)

_Figure 28: FOSWEC2 flap admittance, estimated flap rotational position to flap torque_

From previous experimental testing we encountered a resonance in the structure that occurs in higher frequencies than the wave frequencies of interest. This limits the gains for feedback, particularly in the velocity feedback. To identify this resonance frequency with the hope of designing a filter to mitigate it a bandlimited white noise block in Simulink was employed. Two heights of PSD of white noise were used, namely 0.003 W and 0.006 W. Because the feedback signal of interest is velocity, the resulting angular velocity of each flap was analyzed individually and then together. Figure 29 shows the resulting velocity power spectral density with the strongest component at ~50 Hz. This could be used to fairly quickly identify resonance frequencies to target with filters on a feedback loop.

![image044](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/418c4135-80f7-4788-a5c4-3938a52c52e0)

_Figure 29: Rotational velocity PSD for Bandlimited white noise current input_

A chirp current reference input was given to one flap at a time and the resulting position was logged. This time-domain data was used to create a transfer function representing a single input single output (SISO) system with current the input and angular motor position the output. This SISO system was then fed the input time series with the results shown in Figure 30.

![image045](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/8af2abda-4570-4e28-9862-8f5bf8e4d4db)

_Figure 30: tfest was used to create a 4th order transfer function describing the system_

The same transfer function was then used with a white noise input and compared to experimental output as shown in Figure 31.

![image046](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/31511f77-89c8-4ef5-ba63-e005823ed934)

_Figure 31: Comparison of experimental results with transfer function results for chirp identification_

Next, an estimate of the excitation force frequency domain relationship was the goal. A wave input of bandlimited pink noise with a frequency range of f0 = 0.05 Hz to f1 = 1.5 Hz was run while a white noise flap input with a frequency range of f0 = 0.05 Hz to f1 = 1 Hz was commanded on the flaps. This was repeated for three phase realizations of the pink noise and three phase realizations of the white noise for a total of 9 trials. From the resulting data a frequency domain model was estimated with wave surface elevation at the device as the input and torque at the individual flaps as the output. A bode plot, shown in Figure 32, shows the estimated excitation frequency response from experimental data. The solid lines are the averaged data from the nine trials and the dashed lines are the smoothed data given by the spa command in MATLAB.

![image047](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/312c2533-a6a1-447f-a370-462ea0632ad9)

_Figure 32: Excitation force transfer function estimation showing average and smoothed models._

# Encoder Feedback Filter Design

A series of eight regular wave tests were conducted with a wave height of 0.136 m and a period of 3.89 s. Noise in the encoder feedback signal gets amplified by the damping value implemented and becomes the current command for the motor. Greater noise in the feedback signal turns into greater noise in the commanded current command and the reinforces itself to a point of instability. Inserting a filter in the feedback path helps to mitigate the commanded noise and therefore allows for a greater damping value to be implemented before instability happens. The first trial was with no filter, then filters were implemented starting with a notch, progressing to two notch filters of varying frequencies and bandwidths, then settling on a notch and lowpass combination. The final filter design has a 50 Hz notch filter with a 3 dB bandwidth of 10 Hz and a second order lowpass filter using the filter designer in Simulink with a cutoff frequency is 10 Hz and is of the type IIR maximally flat. Figure 33 shows the power spectral density of the angular frequency of the aft and bow shafts before and after filtering.

![image048](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/ed5cbdb3-fd21-426b-86db-e0f42d736adc)

_Figure 33: Power spectral density of angular frequency before and after filtering_

# Shaft failures

During testing a failure of the flap shafts occurred and was noticed on the position signal as shown in Figure 34. This is likely due to exceeding the strength of the welds between the shaft and load cell carrier. Figure 35 shows the weld failure resulting in flap backlash.

<img width="482" alt="image049" src="https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/56855ebb-d274-4a49-9154-716206def602">

_Figure 34: Flap backlash due to weld failure on flap shaft_

![image050](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/30cf0f6d-7a34-4394-b1d1-35de040f3053)

_Figure 35: Failure of weld between flap shaft and load cell carrier_

After pulling the model and investigating the issue it was found that both bow and aft shaft welds had been compromised. An emergency repair plan was implemented to allow for continued testing that included removing the load cells and connecting the flaps directly to the shaft using six shaft collars as shown in Figure 36.

![image051](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/414c8393-04b6-4243-a136-93a092261d55)

_Figure 36: Flap repair showing six modified shaft collars connecting the flap to the shaft._

Testing was able to resume and the University of Hawaii was able to perform a week of testing fulfilling their research goals. As part of this campaign they performed a sweep of 28 velocity proportional damping values applied to both flaps with mechanical power at the motor recorded and plotted in Figure 37.

![image052](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/029a3d01-8ffa-400a-8aea-85ef8d77984c)


_Figure 37: Damping sweep and resulting power vs. time_


![FOSWEC_signalDiagram_layout 2](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/3b198c03-9166-421c-8fde-3d5da937cd96)

_Figure 38: Basin Layout_

# Summary of FOSWEC2 updates

- Encoders were changed from Sick to Heidenhain
- Scaling was changed on gauge pressure sensors
- Simulink model was redesigned and updated
- Graphical User Interface was developed to interact with FOSWEC2
- Motor operation mode changed from "profile torque" (ID4) to "cyclic torque" (ID10)
- Dry inverted flap tests were undertaken, and feedback filters were designed
- Basin wave testing was done performing systemID on the model
- Flap shaft welds failed and repairs were performed
- Testing resumed with University of Hawaii performing a week of testing

# Future Work

- Repair/replace flaps and or flap shafts
- Repair/replace leaks in electrical connections to hull
- Investigate changing flap encoder

# Appendix A
![PressureData](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/ad22c5ac-2031-4723-a257-a1bcfa797c5e)
![PressureChart](https://github.com/PMEC-OSU/FOSWEC2/assets/12175532/c99c30e8-b82f-4885-be17-b78d5a4d8edd)

