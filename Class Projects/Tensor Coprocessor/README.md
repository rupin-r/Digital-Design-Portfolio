# Tensor Coprocessor
-------------------
About
-------------------

Contributors: Rupin Raj Kumar Pradeep

Project Description: WPI ECE574 Advanced Digital Systems Design Final Project

Create a TPU Coprocessor for Croc SoC with 32 bit floating point inputs and outputs optimizing for space.

--------------------
Features
--------------------

These files only contain the tensor coprocessor for Croc SoC without the integration into the design. The design flow is also not included as they use licensed TSMC cells for the duration of the course. There are two folders, one that implements a 2x2 32-bit floating point tensor multiplication and another that implements a 4x4 32-bit floating point tensor multiplication. Both were optimized for space in order to fit onto a 2 mm chip with 180 nm standard cells.

More details in implementation are found within the project files and folders.

--------------------
Reports
--------------------

Croc SoC Post-synthesis Total Area: 1,872,878.792

Croc SoC Post-synthesis Total Power: 40.38 mW

2x2 Post-synthesis Total Area: 2,234,589.326

2x2 Post-layout Total Area: 1,735,663.814

2x2 Post-synthesis Total Power: 67.91 mW

2x2 Post-layout Total Power: 60.48 mW

4x4 Post-synthesis Total Area: 2,469,153.521

4x4 Post-layout Total Area: 1,902,534.138

4x4 Post-synthesis Total Power: 76.27 mW

4x4 Post-layout Total Power: 69.37 mW

All critical path timings met
