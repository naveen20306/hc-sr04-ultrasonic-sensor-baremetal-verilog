# FPGA Sensor Interfaces (Baremetal Verilog)

A collection of **baremetal Verilog sensor interfaces** implemented completely from scratch without using any prebuilt libraries or IP cores.

This repository includes:
- HC-SR04 Ultrasonic Distance Sensor Interface  

Designed for **real-world robotics applications**, focusing on timing accuracy, stability, and reliability.

---

## 🚀 Features

- Fully **custom implementations (no IP cores / libraries)**
- **FSM-based designs** with precise timing control  
- Robust handling of real-world sensor noise  
- Designed and tested on FPGA  

---

# 📏 HC-SR04 Ultrasonic Interface

## Overview

A **fully stabilized ultrasonic sensor interface** with advanced filtering and protection mechanisms for reliable distance measurement.

---

## ⚙️ Working

1. Generate **10 µs trigger pulse**  
2. Measure **echo pulse width**  
3. Convert time to distance  

distance (cm) = echo_time / 58

---

## 🧠 Key Features

### Filtering
- Median filter  
- Moving average filter  

### Protection
- Outlier rejection  
- Echo timeout protection  
- Sensor freeze protection  

### Stability Logic
- Ensures consistent readings before triggering outputs  

---

## 🔌 Inputs & Outputs

### Inputs
- `clk` (50 MHz)
- `rst_n`
- `echo`

### Outputs
- `trig`
- `dist`
- `led`
- `less5`
- `less32`

---

## 📊 Output Meaning

- `dist` → Distance in cm  
- `less5` → Object very close (≤ 5 cm)  
- `less32` → Object in range (~30–32 cm)  
- `led` → Stable detection indicator  

---

# 🛠️ Hardware Used

- FPGA: Intel/Altera DE0-Nano (Cyclone IV E)  
- Sensors:
  - HC-SR04  

---

# ⚠️ Important Notes

- Designed for **real hardware conditions (not just simulation)**  
- Handles noise, unstable readings, and edge cases  
- Fully **baremetal implementations**  

---

# 🎯 Why This Repository?

Most sensor interfaces rely on libraries or processors.

This project focuses on:
- **Low-level hardware design**
- Understanding sensor protocols deeply  
- Building reliable systems for robotics  

---

# 🏁 Conclusion

This repository demonstrates:

- Precise timing-based sensor interfacing  
- FSM-driven hardware design  
- Reliable real-world performance on FPGA  

---

## 👨‍💻 Author

- Naveen Kumar B
- Sabarish Mohan JS
- Hemanth S

 
