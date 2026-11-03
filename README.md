Project Overview
This project integrates multiple IP blocks into a System-on-Chip (SoC) using AXI, AHB, and APB protocols.
SoC Architecture
  SoC Integration Block Diagram
                         SoC Integration (AXI / AHB / APB)
 +-------------+   +-------------+   +-------------+   +-------------+
 |    CPU0     |   |    CPU1     |   |     DMA     |   |     DSP     |
 | AXI master  |   | AXI master  |   | AXI master  |   | AHB master  |
 +------+------+   +------+------+   +------+------+   +------+------+
        |                 |                 |                 |
        |                 |                 |          +------v------+
        |                 |                 |          | AHB slave   |
        |                 |                 |          | AHB-to-AXI  |
        |                 |                 |          |   Bridge    |
        |                 |                 |          | AXI master  |
        |                 |                 |          +------+------+
        |                 |                 |                 |
        v                 v                 v                 v
 +-------------------------------------------------------------------+
 |  AXI slave         AXI slave         AXI slave         AXI slave  |
 |                        SYSTEM INTERCONNECT                        |
 | AXI master        AXI master        AXI master        AXI master  |
 +-------------------------------------------------------------------+
        |                 |                 |                 |
        v                 v                 v                 v
 +-------------+   +-------------+   +-------------+   +-------------+
 | AXI slave   |   | AXI slave   |   | AXI slave   |   | AXI slave   |
 |  Boot ROM   |   |    SRAM0    |   |    SRAM1    |   | AXI-to-APB  |
 |             |   |             |   |             |   |   Bridge    |
 |             |   |             |   |             |   | APB master  |
 +-------------+   +-------------+   +-------------+   +------+------+
                                                              |
                                                              v
 +-------------------------------------------------------------------+
 |                                                        APB slave  |
 |                        APB PERIPHERAL BUS                         |
 | APB master                 APB master                 APB master  |
 +-------------------------------------------------------------------+
        |                          |                          |
        v                          v                          v
 +------+------+            +------+------+            +------+------+
 |     SPI     |            |   Timers    |            |    UART     |
 +------+------+            +-------------+            +------+------+
        |                                                     |
        v                                                     v
 +-------------+                                       +-------------+
 |  External   |                                       |  External   |
 | SPI device  |                                       | UART device |
 +-------------+                                       +-------------+
Communication Protocols
•	AXI: Used for high-performance communication between masters and memory/peripheral interfaces.
•	AHB: Used by the DSP to communicate through the AHB-to-AXI bridge.
•	APB: Used for communication with low-speed peripherals.


Verification
The SoC integration will be verified using testbenches and simulation.
Simulation Tool: QuestaSim

