# RTL-Sobel-Gaussian-Filter

RTL implementation of 3×3 Sobel and Gaussian filters using Verilog HDL.

---

## 🧩 Features

### 🔹 Sobel Filter
- 3×3 convolution kernel using Gx and Gy gradients  
- Edge detection based on |Gx| + |Gy| magnitude  
- Line buffering and 3×3 window generation

### 🔹 Gaussian Filter
- 3×3 smoothing convolution using separable Gaussian kernels  
- Noise reduction in image pre-processing  
- Basic pipeline structure implemented
