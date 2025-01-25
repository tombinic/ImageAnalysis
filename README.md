# 🏛 Geometric Computer Vision

### 🧑‍🎓 Author: Nicolò Tombini  
---

## 📖 Introduction
The task focuses on analyzing the cylindrical vault of **Palazzo Te in Mantova**, an architectural marvel, through feature extraction and geometric calculations using MATLAB. A single image was taken with an uncalibrated, zero-skew camera.

---

## 🖼 Image
The camera captured visible circular cross-sections (`C1`, `C2`) and generatrix lines (`l1`, `l2`) of the cylindrical vault.

---

## 🔍 Feature Extraction

### 🎛 Initial Preprocessing
The image was converted to grayscale and its contrast enhanced using `adapthisteq`.

### ✂️ Edge Detection
Several methods were tested (e.g., Canny, Sobel, Roberts), with **Canny** emerging as the most effective. Parameters like thresholds and sigma were optimized through grid search.

### 📏 Lines Detection
The Hough Transform was used twice:  
1. To detect the generatrix lines `l1` and `l2`.  
2. To detect additional lines across the image.

### 🔵 Ellipses Detection

#### 📊 Regionprops
MATLAB’s `regionprops` function was used to identify ellipses automatically, followed by manual selection to refine results.

#### ✋ Manual Selection
Manual extraction of ellipses using `drawellipse` was employed for improved accuracy.

### 🏞 Corners Detection
The **Harris Algorithm** was used to detect stable keypoints within the image.

---

## 📐 Geometry

### 🌅 Horizon Line `h`
Using the intersections of `C1` and `C2`, the horizon line `h` was calculated.

### 🎯 Cylinder Axis and Vanishing Point

#### 🛞 Cylinder Axis `a`
Using polar line calculations, the axis `a` of the cylinder was determined.

#### 📌 Vanishing Point `V`
The vanishing point was computed as the cross product of the generatrix lines `l1` and `l2`.

### 🖩 Calibration Matrix `K`
The calibration matrix of the zero-skew camera was derived using the IAC matrix `ω` and Cholesky factorization.

### 🧭 Orientation of the Cylinder Axis w.r.t. the Camera Reference
Mapping the planar face to its image, the orientation of the cylinder axis was computed through transformations.

### 🔄 Ratio Between the Radius of the Circular Cross Sections and Their Distance

#### 🔧 Rectification Approach
The image was rectified to calculate the radii and the distance between the cross-sections.

#### 📐 Angles Approach
Using trigonometric invariants and sine rules, the ratios were verified through alternative methods.

---

## 🌀 Unfolding the Surface Between Cross Sections
The surface between the cross-sections was cropped and rectified, then converted from Cartesian to polar coordinates for unfolding.

---

## 📚 References
1. Richard Hartley, Andrew Zisserman - *Multiple View Geometry*  
2. MATLAB Documentation:  
   - [Edge Detection](https://it.mathworks.com/help/vision/ref/edgedetection.html)  
   - [Hough Transform](https://it.mathworks.com/help/images/ref/houghlines.html)  
   - [Regionprops](https://it.mathworks.com/help/images/ref/regionprops.html)  
   - [Corner Detection Harris](https://it.mathworks.com/help/vision/ref/detectharrisfeatures.html)  
   - [Corner Detection SURF](https://it.mathworks.com/help/vision/ref/detectsurffeatures.html)  
---

This README file provides an overview of the **Geometric Computer Vision** project conducted in the **Image Analysis and Computer Vision course**, A.Y. 2023-2024, under the supervision of Prof. Vincenzo Caglioti. The project was carried out by Nicolò Tombini from Politecnico di Milano, Italy.

For more detailed information, please refer to the project documentation and source code provided in this repository.
