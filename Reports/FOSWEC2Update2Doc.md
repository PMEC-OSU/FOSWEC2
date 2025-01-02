# FOSWEC2 Repair and Upgrade 2

12/23/2024

# Contents

[Introduction](#introduction)

[Flaps](#flaps)

[Cables](#cables)

[Repair](#repair)

[Electronics](#electronics)

[Shore Electrical](#shore-electrical)

[Data Sign Conventions](#data-sign-conventions)

[Dry Testing](#dry-testing)

---

# Introduction

This report documents the efforts in repairing and upgrading the FOSWEC2 device from 4/2024 to 11/2025. Major efforts include:

- Replacement 
	- flaps 
	- flap shafts
	- high power cables and bulkheads
	- low power cables and bulkheads
	- ethernet cables and bulkheads
	- non-stainless fasteners on enclosure connection to platform
- Removal
	- flap integrated load cells
	- flap integrated encoders
- Repair 
	- enclosure penetrations for instruments removed or consolidated.  Previous ethernet passthrough was plugged.
- Combining
	- low power and ethernet cable and bulkheads into a replacement single cable
- Removal and re-installation of all electronics in submerged enclosure to allow for enclosure machining
- Creation 
	- shore-side electrical stand on wheels for efficient storage and cable management
- Dry checkout of all systems
	- Application of reference signals on inverted flaps (ramps, sine, multisine, chirp)
	- Damping feedback checkout with manual flap actuation

 ![PXL_20241221_001740702](https://github.com/user-attachments/assets/98273af1-41e4-4131-b22d-d06a350271eb)


---

# Flaps
New flaps were fabricated by the CMTD shop.  Changed from closed cell foam based design to a hollow weldment with the 
same nominal dimensions.  If we have any trouble with flaps leaking, we can fill with foam.  New flap dimensions are 
shown in the table below.  All dimensions in meters.


| width | depth1 | depth2 | height | shaft diameter | shaft center to top |
| :---: | :----: | :----: | :----: | :------------: | :-----------------: |
| 0.743 | 0.061  | 0.120  | 0.576  | 0.03015        | 0.595               |


![PXL_20241220_175030558](https://github.com/user-attachments/assets/36b68fce-775f-45b0-895f-153d6bbe6fa9)

---
# Cables

Cables were updated to [Subconn](https://www.macartney.com/connectivity/subconn/) by MacArtney have a 15 m length.

## Low power and ethernet cable

Low power and ethernet cables were combined into one 13 pin [cable](https://www.macartney.com/connectivity/subconn/subconn-ethernet-series/subconn-power-ethernet-circular-13-contacts/).  
Standard RJ45 connectors were put on each end of the bulkhead ethernet cable ends.  
- Ethernet cable 4 pair 24 AWG twisted pair
- Bulkhead ethernet cable is CAT 5E patch cable 
- Cable power conductors 4 x 18 AWG
- Screen of tinned copper braid
- Bulkhead cables:  and 5 x 20 AWG

## High power cable

High power [cable](https://www.macartney.com/connectivity/subconn/subconn-power-series/subconn-high-power-4-contacts/)
- Cable is 4 conductor #8 AWG
- Bulkheads have 4 conductor 10AWG
  
<img width="1040" alt="SubConnCables" src="https://github.com/user-attachments/assets/9706f2ec-c0b7-4b81-92a0-cd4138dc019a" />

---

# Repair
Passthroughs of the load cell and shaft encoder cables were plugged or sealed.  Previous ethernet passthrough was plugged

---

# Electronics

Updated system diagram shown below

![FOSWEC_signalDiagram20241220](https://github.com/user-attachments/assets/69d34fba-2e1e-4c78-879e-2b68d169c42d)


# Shore Electrical

A new structure was created to hold the shore-side electrical components and hold the cables when they are not in use.
This allows for easy moving and storage of these components and removes need to lift heavy components repeatedly.
New cables were integrated into the shore-side electrical system.

# Data Sign Conventions

Recorded data is reported with the sign conventions shown below.  This sign convention is designed to be consistent with the
HWRL tank coordinate definitions.

![FOSWEC Sign Conventions 3d](https://github.com/user-attachments/assets/d65fc5a7-16a1-4cd0-a7fe-99d70fddbce6)

![FOSWEC Sign Conventions 2d](https://github.com/user-attachments/assets/0b13e933-3b31-4af3-97b1-e42065940b9e)

---

# Dry testing

Dry testing included testing different reference current signals including ramps, sine wave, chirp wave, multisine waves.  
Also included was the testing of damping feedback control stepping through six damping values from 2 to 7 Nms in 1 Nms increments.
Notable that the encoder position zero resets whenever the power is cycled.  

## Ramps

![Ramps](https://github.com/user-attachments/assets/3e6cec9f-852a-4334-8942-69466a26c6b6)

## Sine
![Sine](https://github.com/user-attachments/assets/04b0e13f-fa20-400c-8abf-218a8cbd22ad)

## Chirp

![Chirp](https://github.com/user-attachments/assets/e7776e3a-0bd8-4749-8c57-e7a14d1c9b55)

## Multisine

![Multisine](https://github.com/user-attachments/assets/5a4dc0eb-fe1a-48b4-a4c9-269fcf72e629)

## Damping

![Damping](https://github.com/user-attachments/assets/f3a635b5-192e-4e67-aaeb-cb4c4536d473)

### Notes on dry testing

There is noticeable stiction and friction differences in the two flaps most notable in the chirp dry test shown above.  The flap shafts were equipped with self lubricating bushings activated when wet.  Evaluation of the stiction/friction will occur once deployed in water and the need for repair assessed. 
