# Efficient-Convolutional-Neural-Network-Layer-on-SoC

This system performs zero skipping and depthwise-separarble convolutions on data that is made available from the embedded software.

zero_skip_conv is the top module. First data is fetched by interacting with the zynq processor on the FPGA. Then depthwise convolutions are performed,
followed by piecewise convoltuions, then a ReLU activation layer. Only non-zero ReLU activations are stored for the following layers, along with 
positional metadata to perform correct convolutions.
