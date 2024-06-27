%% Tombini Nicolò - 10912627 - 218337
clc;
clear;

%% Preprocessing
im = imread("PalazzoTe.jpg");
% plot the image rotated by 90 deg
im_rotated = imrotate(im, -90);

% Conversion to gray scale image
img_gray_scale = rgb2gray(im_rotated);

% enhances the contrast of the grayscale image, better with two usage
img_gray_norm1 = adapthisteq(img_gray_scale);
img_gray_norm2 = adapthisteq(img_gray_norm1);
montage({im_rotated, img_gray_norm2},'Size',[1 2])

% 1) Feature Extraction - Edges detection
edges = edges_detection(img_gray_norm2, 'canny');

% 1) Feature Extraction - Lines detection 

% Found only 2 genetrix lines
line = lines_detection(edges, im_rotated, 2, 600);
data = load('l1.mat');
l1 = data.l1
data = load('l2.mat');
l2 = data.l2

% Found more lines
%lines = lines_detection(edges, im_rotated, 500, 500, 15);

% 1) Feature Extraction - Corners detection
corners_detection(im_rotated, img_gray_norm2, "Harris");
corners_detection(im_rotated, img_gray_norm2, "Surf");

% 1) Feature Extraction - Ellipses detection

%ellipses_detection(im_rotated, img_gray_norm1, "auto");
%ellipses_detection(im_rotated, img_gray_norm1, "manual");

data = load('ellipses_new.mat');
e1 = data.e1;
e2 = data.e2;
figure;
imshow(im_rotated);
hold all;
e1 = drawellipse('Center', e1.Center, 'SemiAxes', e1.SemiAxes, 'RotationAngle', e1.RotationAngle, 'Color','g');
e2 = drawellipse('Center', e2.Center, 'SemiAxes', e2.SemiAxes, 'RotationAngle', e2.RotationAngle, 'Color','g');

%% 2.1) Theory Part - From 𝐶1, 𝐶2 find the horizon (vanishing) line ℎ of the plane orthogonal to the cylinder axis.
find_vanishing_line(im_rotated);
data = load('h.mat');
h = data.l_inf_1

%% 2.2) Theory Part - From 𝑙1, 𝑙2, 𝐶1, 𝐶2 find the image projection 𝑎 of the cylinder axis, and its vanishing point V.
find_vanishing_point(im_rotated);
data = load('vp.mat');
vp = data.vp
find_imgproj_cylinder_axis(im_rotated);

%% 2.3) From 𝑙1, 𝑙2, 𝐶1, 𝐶2 (and possibly ℎ, 𝑎, and V), find the calibration matrix 𝐾.
find_calibrationK();
data = load('K.mat');
k = data.k
data = load('iac.mat');
w = data.w

%% 2.4) From ℎ, 𝐾, and V determine the orientation of the cylinder axis wrt the camera reference.
orientation_axis(im_rotated);

%% 2.5) Compute the ratio between the radius of the circular cross sections and their distance.

% Ratio computed with 2 approaches: Euclidean rectification and angles
compute_ratio(im_rotated);

%% 3) Rectification of a cylindric surface: Plot the unfolding of the part of the surface, included between the two cross sections, onto a plane.
unfolding();
