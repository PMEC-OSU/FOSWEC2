# FOSWEC2 Repair and Upgrade

Draft

Bret Bosma

7/10/2023

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

![](RackMultipart20230710-1-5ldug_html_8fbad4a491ea8944.gif)

_Figure 1: Updated FOSWEC2 system diagram_

#

# Encoder swap

A feedback stability issue with the FOSWEC2 deployment in February 2020 was identified and potential solutions explored. One issue identified was encoder noise. The original absolute encoder used on the FOSWEC2 was the Sick SKS36-HFA0-K02 with Hyperface interface. The encoder specs include 128 sine/cosine periods per revolution and 4096 total number of steps. As this is a hybrid analog/digital transducer, it is possibly susceptible to noise from the surrounding environment.

The Heidenhain ECN 1123 512 with EnDat2.2 interface was chosen as a fully digital replacement absolute encoder. This encoder has 23 bits per revolution or 8388608 position values per revolution. Custom adapter pieces were designed and fabricated by Sandia National Laboratories to allow for integration of the new encoder. A cad rendering of these pieces is shown in Figure 2

![](RackMultipart20230710-1-5ldug_html_b531f1c275f5c488.png) ![](RackMultipart20230710-1-5ldug_html_8596037214f8e210.png)

_Figure 2: Custom adapter parts for new encoders_

# Pendulum tests

Pendulum tests were used to verify functionality of the new encoders and verify the torque constant for the motors. These tests are designed to determine the relationship between torque and current. This is necessary and relevant because most motor drives have current as their input and a relationship between commanded current and actual torque measured is desired. For these tests a custom coupler needed to be fabricated connecting the motor to the torque transducer. The rest of the test stand was repurposed from another project. The bench test setup is shown in Figure 3.

![](RackMultipart20230710-1-5ldug_html_37859042c1abbe5.jpg)

_Figure 3: Bench setup of pendulum tests_

Ramp tests were conducted to estimate the torque constant with a maximum current of 20A achieved. The test consisted of four ramp events two clockwise and two counterclockwise alternating as shown in Figure 4.

![](RackMultipart20230710-1-5ldug_html_ea82c7d7210c1376.png)

_Figure 4: Torque vs. Time for pendulum ramp tests_

The torque-current relationship was plotted for each ramp segment as shown in Figure 5.

![](RackMultipart20230710-1-5ldug_html_badd3286b4220e2a.png)

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

![](RackMultipart20230710-1-5ldug_html_6af8cdb5136611ab.png)

_Figure 6: Comparison of old and new FOSWEC encoders_

Comparison of the variance of the signals is shown in Figure 7. While this result is very encouraging, the true test will be when we are applying feedback in an in-water test.

![](RackMultipart20230710-1-5ldug_html_7d693b07cf897122.png)

_Figure 7: Variance comparison_

# EtherCAT network definition

Because of changes in the Beckhoff module configuration due to changes in encoder needs and redundant modules, the EtherCAT network needed to be redefined. Additionally, addition of the Mini-DAQ to the EtherCAT network will require re-definition. This proved to be a challenge, as getting the TwinCAT software to recognize the network with the two motor drives present and customizing the motor drive inputs and outputs took a lot of trial and error. AMC\_AppNote\_017.pdf was used as a guide for customizing the AMC EtherCAT network ESI, and eventually a custom network configuration adding drive bus voltage was achieved.

# Motor checkout with flaps disconnected

A Simulink model was created that configures and sends commands to the motors. Timeout errors were present when trying to set the operation mode of both motors at the same time through Simulink, so configuration was set to operation mode 10 which is cyclic torque mode through the DriveWare software. Code was left in Simulink model but commented out. A sinusoidal torque signal of 1A at 1s was sent to both motors with oscillating motion on both motors confirmed. Scaling on motor position was confirmed by commanding zero and manually rotating each motor one rotation and recording position data.

# Flap tensioning

Figure 8 details the methodology for adjusting the belt tension. Any time the belts get removed, the tension should be adjusted upon replacement. It doesn't need to be real tight, just snug. As you move the flap back and forth, make sure the return side doesn't have any slack.

![](RackMultipart20230710-1-5ldug_html_b6fdf12ee033ba16.png)

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

![](RackMultipart20230710-1-5ldug_html_eb7d1c5f127ad69c.jpg)

_Figure 9: Testing the EL3154 by inputting 4-20mA and verifying output in TwinCAT3._

![](RackMultipart20230710-1-5ldug_html_1152b2dad7666f9a.jpg)

_Figure 10: Recording pressure on calibrator and with Simulink to verify scaling and offset values._

# Motor temperature checkout

Motor temperature was logged using the Beckhoff EL3692 modules and values seemed in a reasonable range and increased when the motor was loaded.

# VRU accelerometer checkout

VRU unit was disconnected from enclosure housing and manually rotated to verify angular positions.

# Inverted dry flap reference command

Current reference signals were sent to the drives to command ramps, sine, white noise, and chirp signals. All were verified to work on the flaps within the range of the flap endstops. Data was collected and stored in the DryReference1 experiment on the HWRL share. Figure 11 shows the inverted dry flap test in progress.

![](RackMultipart20230710-1-5ldug_html_3c11ae1f85f83f84.jpg)

_Figure 11: Inverted flap reference input test_

Figure 12 shows the target and actual reported current signal from the motor drive. Motor drive control of current as reported is quite good.

![](RackMultipart20230710-1-5ldug_html_a72a9a3564f9db85.png)

_Figure 12: Reference Current Ramps_

Figure 13 shows the target and actual sine wave response from the motor drive. Target matches actual quite well.

![](RackMultipart20230710-1-5ldug_html_300e9adad4b2e6eb.png)

_Figure 13: Reference Current Sine_

Figure 14 shows the target and actual current for a white noise input. Motor drive controller tracks well.

![](RackMultipart20230710-1-5ldug_html_e85969971d099f7f.png)

_Figure 14: Reference Current White Noise_

Figure 15 shows the target and actual current fort a chirp input. Motor drive current control tracking well.

![](RackMultipart20230710-1-5ldug_html_3aed0bf0c73f5cc5.png)

_Figure 15: Reference Current Chirp_

# Inverted dry flap feedback

Feedback control was implemented to enable the application of velocity and position proportional torque commands. In the control software, conversion from the motor frame to the flap frame is implemented so that damping and stiffness terms are input in the flap frame.

The encoders on the motors are directly connected to the motor drives and the motor drives report the "Position Actual Value". The software then takes a discrete-time derivative to calculate a velocity. Because of noise in the position signal, both position and velocity feedback signals need to be filtered. Starting with the velocity feedback signal, a 15Hz cutoff frequency first order low pass filter via the discrete transfer function block in Simulink. A second order bandpass filter is applied to the position signal. Velocity proportional feedback control is implemented by sending a current command to the motor drive. Calculation of the current is done with the following:

where is the commanded motor torque, is the velocity proportional damping term at the flap, is the angular velocity at the motor, is the gear ratio , and is the torque constant.

An inverted flap dry test was completed by testing the velocity proportional feedback loop. The flaps were actuated manually with a broomstick as shown in Figure 16. The control loop was activated with an increasing damping value starting at 1 Nms/rad and increasing to 7 Nms/rad. For each damping value the flap was manually actuated several cycles with a broomstick. This test was repeated for the aft and bow flaps and results are shown in Figure 17. Plotted are both the derivative of the drive reported position, and the filtered version of this signal. It is notable that as the applied damping increases, the noise on the motor velocity increases.

![](RackMultipart20230710-1-5ldug_html_4aa1ba6c5c7fd28f.jpg)

_Figure 16: Manual flap actuation to test active feedback_

![](RackMultipart20230710-1-5ldug_html_f03e09eaa885469d.png)

_Figure 17: Inverted flap velocity proportional feedback test_

Zooming into one cycle of the bow motor velocity for B = 7 Nms is shown in Figure 18. Even with a fairly aggressive low pass filter, the noise is being transferred through. This results in mechanical resonance in the structure that appears to increase with applied damping.

![](RackMultipart20230710-1-5ldug_html_3e46cd01921e4b5c.png)

_Figure 18: Zoomed in bow velocity for B=7 Nms_

A longer test with a damping of 7 Nms applied was done and results analyzed in the frequency domain as shown in Figure 19.

![](RackMultipart20230710-1-5ldug_html_4bc4cab041b3ccba.png)

_Figure 19: Feedback low pass filter with cutoff 15Hz_

The Digital Filter Design block in Simulink was employed to generate a better filter for the velocity feedback. A low pass IIR Maximally Flat filter of 8th order with a sampling frequency of 1 kHz and a cutoff frequency of 10 Hz was chosen as shown in Figure 20. The test was then repeated with the same conditions with the new filter with the results shown in Figure 21.

![](RackMultipart20230710-1-5ldug_html_a01063410d373441.png)

_Figure 20: Digital Filter design in Simulink_

![](RackMultipart20230710-1-5ldug_html_5df74f0da69b066.png)

_Figure 21: Updated feedback filter results_

The settings for the Digital Filter Design block in Simulink were then modified to try and decrease the phase lag between the filtered and unfiltered velocities. Decreasing the filter order to two for the numerator and denominator seemed a good tradeoff of stability and phase delay. Filter design shown in Figure 22. The resulting frequency plots are shown in Figure 23. The phase lag is significantly decreased while continuing to eliminate the high frequency noise.

![](RackMultipart20230710-1-5ldug_html_d3353a299e4f6265.png)

_Figure 22: Reducing the filter order to 2 to improve phase lag_

![](RackMultipart20230710-1-5ldug_html_f963484164a3d951.png)

_Figure 23: Reduced numerator and denominator filter order to 2 and fc = 10 Hz_

A notch filter was then employed to focus on the peak around 54Hz introduced by the second order filter. The "Notch-Peak Filter" block was used with a center frequency of 54.8 Hz and a 3dB Bandwidth specification of 5 Hz.

![](RackMultipart20230710-1-5ldug_html_3cfbff6b92cae9b7.png)

_Figure 24: Notch plus lowpass filter results_

# Graphical User Interface (GUI) development

A graphical user interface was developed using the Matlab toolbox App Designer. This tool allows for creating a user interface that allows for interacting with a model without having to interact with the underlying code. Inputs are available in convenient forms such as sliders, spinners, and text fields and real time monitoring of signals from the output of the system can be displayed in convenient forms including axes, gauges, indicators, etc… As part of the GUI development, at the finish of running the model, the data is retrieved from the Speedgoat system and archived for post processing. A snapshot of the GUI in operation is shown in Figure 25.

![](RackMultipart20230710-1-5ldug_html_3084570477229d6f.png)

_Figure 25: GUI snapshot after white noise reference command_

#

# Wave Basin Deployment

FOSWEC2 was fixed to the basin floor using threaded rod extending through hollow tubes.

![](RackMultipart20230710-1-5ldug_html_17b505e722dc9b78.jpg)

_Figure 26: FOSWEC2 being lowered down over threaded rods_

![](RackMultipart20230710-1-5ldug_html_2ec1de68a6e579d8.jpg)

_Figure 27: Threaded rods pass through steel plates and wingnuts are used to secure the FOSWEC2 to the basin floor_

# Wave Basin Testing

System Identification no wave tests were conducted first. Small improvements to the data collection and GUI were performed throughout with changes tracked in git.

Experiment Reference1 was conducted to characterize the system using input output methods. Three white noise realizations of drive current command were used to excite the flap with a drive measured torque while encoder position was recorded. An admittance model was then estimated using the MATLAB system identification toolbox. Admittance is assumed here to be the ratio of flap position and flap torque

where is the admittance, is the angular position at the flap, is the torque at the flap, is the angular position at the motor, is the torque at the motor, and is the gear ratio between the motor and flap which is . Figure 28 shows this admittance estimate for trials two through seven of the Reference1 experiment.

![](RackMultipart20230710-1-5ldug_html_9a1da75b9c148681.png)

_Figure 28: FOSWEC2 flap admittance, estimated flap rotational position to flap torque_

From previous experimental testing we encountered a resonance in the structure that occurs in higher frequencies than the wave frequencies of interest. This limits the gains for feedback, particularly in the velocity feedback. To identify this resonance frequency with the hope of designing a filter to mitigate it a bandlimited white noise block in Simulink was employed. Two heights of PSD of white noise were used, namely 0.003 W and 0.006 W. Because the feedback signal of interest is velocity, the resulting angular velocity of each flap was analyzed individually and then together. Figure 29 shows the resulting velocity power spectral density with the strongest component at ~50 Hz. This could be used to fairly quickly identify resonance frequencies to target with filters on a feedback loop.

![](RackMultipart20230710-1-5ldug_html_4b5ca40493510c9.png)

_Figure 29: Rotational velocity PSD for Bandlimited white noise current input_

A chirp current reference input was given to one flap at a time and the resulting position was logged. This time-domain data was used to create a transfer function representing a single input single output (SISO) system with current the input and angular motor position the output. This SISO system was then fed the input time series with the results shown in Figure 30.

![](RackMultipart20230710-1-5ldug_html_3b25f7ac7734c0b8.png)

_Figure 30: tfest was used to create a 4th order transfer function describing the system_

The same transfer function was then used with a white noise input and compared to experimental output as shown in Figure 31.

![](RackMultipart20230710-1-5ldug_html_993453b99c386e69.png)

_Figure 31: Comparison of experimental results with transfer function results for chirp identification_

Next, an estimate of the excitation force frequency domain relationship was the goal. A wave input of bandlimited pink noise with a frequency range of f0 = 0.05 Hz to f1 = 1.5 Hz was run while a white noise flap input with a frequency range of f0 = 0.05 Hz to f1 = 1 Hz was commanded on the flaps. This was repeated for three phase realizations of the pink noise and three phase realizations of the white noise for a total of 9 trials. From the resulting data a frequency domain model was estimated with wave surface elevation at the device as the input and torque at the individual flaps as the output. A bode plot, shown in Figure 32, shows the estimated excitation frequency response from experimental data. The solid lines are the averaged data from the nine trials and the dashed lines are the smoothed data given by the spa command in MATLAB.

![](RackMultipart20230710-1-5ldug_html_12d3d8c4f71e3238.png)

_Figure 32: Excitation force transfer function estimation showing average and smoothed models._

# Encoder Feedback Filter Design

A series of eight regular wave tests were conducted with a wave height of 0.136 m and a period of 3.89 s. Noise in the encoder feedback signal gets amplified by the damping value implemented and becomes the current command for the motor. Greater noise in the feedback signal turns into greater noise in the commanded current command and the reinforces itself to a point of instability. Inserting a filter in the feedback path helps to mitigate the commanded noise and therefore allows for a greater damping value to be implemented before instability happens. The first trial was with no filter, then filters were implemented starting with a notch, progressing to two notch filters of varying frequencies and bandwidths, then settling on a notch and lowpass combination. The final filter design has a 50 Hz notch filter with a 3 dB bandwidth of 10 Hz and a second order lowpass filter using the filter designer in Simulink with a cutoff frequency is 10 Hz and is of the type IIR maximally flat. Figure 33 shows the power spectral density of the angular frequency of the aft and bow shafts before and after filtering.

![](RackMultipart20230710-1-5ldug_html_53150a923861c2af.png)

_Figure 33: Power spectral density of angular frequency before and after filtering_

# Shaft failures

During testing a failure of the flap shafts occurred and was noticed on the position signal as shown in Figure 34. This is likely due to exceeding the strength of the welds between the shaft and load cell carrier. Figure 35 shows the weld failure resulting in flap backlash.

![](RackMultipart20230710-1-5ldug_html_25dfc1fbc566fa4f.png)

_Figure 34: Flap backlash due to weld failure on flap shaft_

![](RackMultipart20230710-1-5ldug_html_988a2d8e4529d92.jpg)

_Figure 35: Failure of weld between flap shaft and load cell carrier_

After pulling the model and investigating the issue it was found that both bow and aft shaft welds had been compromised. An emergency repair plan was implemented to allow for continued testing that included removing the load cells and connecting the flaps directly to the shaft using six shaft collars as shown in Figure 36.

![](RackMultipart20230710-1-5ldug_html_88b4d217ddbc1cf9.jpg)

_Figure 36: Flap repair showing six modified shaft collars connecting the flap to the shaft._

Testing was able to resume and the University of Hawaii was able to perform a week of testing fulfilling their research goals. As part of this campaign they performed a sweep of 28 velocity proportional damping values applied to both flaps with mechanical power at the motor recorded and plotted in Figure 37.

![](RackMultipart20230710-1-5ldug_html_caa354ee5a3912a4.png)

_Figure 37: Damping sweep and resulting power vs. time_

| **FOSWEC2 Wave Conditions** |
 |
 | 3/22/2023 |
 |
 |
 |
 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Water Depth 1m** |
 |
 |
 |
 |
 |
 |
 |
 |
|
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
| **Regular** |
 |
 |
 |
 | ![Shape1](RackMultipart20230710-1-5ldug_html_99a25725687ba787.gif) **Regular waves** Heading: 0 degRun time: 120 min **JONSWAP waves** Repeat period: 300 sHeading: 0 degRun time: 20min **Chirp** Start at f0, progress linearly to f1, and reverseRun time: 10 minHeading: 0 deg **Pink** Repeat period: 300 sHeading: 0 degRun time: 20minEach wave height will have three different phase realizations
 |
|   |   | **H (m)** |   |
| --- | --- | --- | --- |
|   |
 | **0.086** | **0.136** | **0.186** |   |
| **T (s)** | **1.25** | R1A | R1B | R1C |   |
| **1.55** | R2A | R2B | R2C |   |
| **1.94** | R3A | R3B | R3C |   |
| **2.63** | R4A | R4B | R4C |   |
| **3.89** | R5A | R5B | R5C |   |
|   |   |   |   |   |   |
|
 |
 |
 |
 |
 |
 |
| --- | --- | --- | --- | --- | --- |
|
 |
 |
 |
 |
 |
 |
| **JONSWAP** | **Gamma** | **3.3** |
 |
 |
|   |   | **Hm0 (m)** |   |
| --- | --- | --- | --- |
|   |
 | **0.086** | **0.136** | **0.186** |   |
| **Tp (s)** | **1.25** | J1A | ~~J1B~~ | ~~J1C~~ |   |
| **1.55** | J2A | J2B | ~~J2C~~ |   |
| **1.94** | J3A | J3B | ~~J3C~~ |   |
| **2.63** | J4A | J4B | J4C |   |
| **3.89** | J5A | J5B | J5C |   |
|   |   |   |   |   |   |
|
 |
 |
 |
 |
 |
 |
| --- | --- | --- | --- | --- | --- |
| **Chirp** |
 |
 |
 |
 |
|   | f0(Hz) | 1.5 |   |   |   |
 |
 |
 |
 |
 |
|   | f1(Hz) | 0.05 |
 |
 |   |
 |
 |
 |
 |
 |
|   | H(m) | **0.086** | **0.136** | ** ~~0.186~~ ** |   |
 |
 |
 |
 |
 |
|   | Name | ChirpA | ChirpB | ~~ChirpC~~ |   |
 |
 |
 |
 |
 |
|   |   |   |   |   |   |
 |
 |
 |
 |
 |
|
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
| **Pink** |
 |
 |
 |
 |
 |
 |
 |
 |
 |
|   | f0(Hz) | 1.5 |   |   |   |
 |
 |
 |
 |
 |
|   | f1(Hz) | 0.05 |
 |
 |   |
 |
 |
 |
 |
 |
|   |
 | **H (m)** |   |
 |
 |
 |
 |
 |
|   |
 | **0.086** | **0.136** | ** ~~0.186~~ ** |   |
 |
 |
 |
 |
 |
| **Phase** | **1** | Pink1A | Pink1B | ~~Pink1C~~ |   |
 |
 |
 |
 |
 |
| **2** | Pink2A | Pink2B | ~~Pink2C~~ |   |
 |
 |
 |
 |
 |
| **3** | Pink3A | Pink3B | ~~Pink3C~~ |   |
 |
 |
 |
 |
 |

#

#

![](RackMultipart20230710-1-5ldug_html_7147b2bf280cea07.gif)

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

|
 | cts | psi meas | psi assumed
 slope&offset | absolute error | psi meas
 slope&offset | absolute error |
| --- | --- | --- | --- | --- | --- | --- |
|
 | 16225 | 0.0087 | 0.0063 | 0.0024 | -0.0674 | 0.0761 |
|
 | 17504 | 1.1262 | 1.1656 | 0.0394 | 1.0919 | 0.0343 |
|
 | 18775 | 2.3068 | 2.3177 | 0.0109 | 2.2439 | 0.0629 |
|
 | 19949 | 3.1199 | 3.3818 | 0.2619 | 3.3079 | 0.1880 |
|
 | 21156 | 4.4818 | 4.4758 | 0.0060 | 4.4019 | 0.0799 |
|
 | 22506 | 5.575 | 5.6994 | 0.1244 | 5.6255 | 0.0505 |
|
 | 23644 | 6.603 | 6.7309 | 0.1279 | 6.6569 | 0.0539 |
|
 | 24737 | 7.5827 | 7.7216 | 0.1389 | 7.6476 | 0.0649 |
|
 | 25686 | 8.6265 | 8.5818 | 0.0447 | 8.5077 | 0.1188 |
|
 | 26936 | 9.6087 | 9.7148 | 0.1061 | 9.6407 | 0.0320 |
|
 | 28030 | 10.5172 | 10.7064 | 0.1892 | 10.6322 | 0.1150 |
|
 | 29160 | 11.6502 | 11.7306 | 0.0804 | 11.6564 | 0.0062 |
|
 | 30170 | 12.5754 | 12.6461 | 0.0707 | 12.5718 | 0.0036 |
|
 | 31273 | 13.5546 | 13.6458 | 0.0912 | 13.5716 | 0.0170 |
|
 | 31838 | 14.2776 | 14.1580 | 0.1196 | 14.0837 | 0.1939 |
|
 | 32565 | 14.7419 | 14.8169 | 0.0750 | 14.7426 | 0.0007 |
|
 | 31238 | 13.5133 | 13.6141 | 0.1008 | 13.5398 | 0.0265 |
|
 | 30152 | 12.5157 | 12.6298 | 0.1141 | 12.5555 | 0.0398 |
|
 | 29029 | 11.5022 | 11.6119 | 0.1097 | 11.5377 | 0.0355 |
|
 | 27921 | 10.4957 | 10.6076 | 0.1119 | 10.5334 | 0.0377 |
|
 | 26838 | 9.4909 | 9.6260 | 0.1351 | 9.5519 | 0.0610 |
|
 | 25573 | 8.5142 | 8.4794 | 0.0348 | 8.4053 | 0.1089 |
|
 | 24467 | 7.5073 | 7.4769 | 0.0304 | 7.4029 | 0.1044 |
|
 | 23539 | 6.5044 | 6.6357 | 0.1313 | 6.5618 | 0.0574 |
|
 | 22296 | 5.5083 | 5.5091 | 0.0008 | 5.4352 | 0.0731 |
|
 | 21316 | 4.5018 | 4.6208 | 0.1190 | 4.5469 | 0.0451 |
|
 | 20194 | 3.5017 | 3.6038 | 0.1021 | 3.5300 | 0.0283 |
|
 | 18971 | 2.4999 | 2.4953 | 0.0046 | 2.4215 | 0.0784 |
|
 | 17987 | 1.5046 | 1.6034 | 0.0988 | 1.5296 | 0.0250 |
|
 | 16885 | 0.5062 | 0.6046 | 0.0984 | 0.5308 | 0.0246 |
|
 | 16331 | 0.0036 | 0.1024 | 0.0988 | 0.0287 | 0.0251 |
|
 |
 |
 |
 | mean abs error | mean abs error |
|
 |
 |
 |
 | 0.0897 |
 | 0.0603 |
| slope | psi/cts | 9.0636E-04 | 9.0640E-04 |   | 9.0636E-04 |   |
| offset | psi | -14.7731 | -14.7000 |   | -14.7731 |   |
|
 | rsq | 0.999716984 | 1.0000 |   | 0.99971698 |   |

![](RackMultipart20230710-1-5ldug_html_13fbf5975e6c2a22.gif)