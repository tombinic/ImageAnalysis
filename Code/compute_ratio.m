function compute_ratio(im_rotated)

data = load('vp.mat');
vp = data.vp;
data = load('l1.mat');
l1 = data.l1;
data = load('l2.mat');
l2 = data.l2;
data = load('h.mat');
h = data.l_inf_1;
data = load('center_c2.mat');
c2 = data.c2;
data = load('center_c1.mat');
c1 = data.c1;
data = load('ellipses_new.mat');
e1 = data.e1;
e2 = data.e2;
data = load('eq1.mat');
eq1 = data.eq1;
data = load('eq2.mat');
eq2 = data.eq2;
data = load('vp.mat');
vp = data.vp;

figure;
imshow(im_rotated);
hold all 

% Plot line at line infinity 1
w = size(im_rotated,2);
A1 = [0; -h(3)/h(2);1];
B1 = [w; -(h(3)+h(1)*w)/h(2);1];

% Plot ellipses
e1 = drawellipse('Center', e1.Center, 'SemiAxes', e1.SemiAxes, 'RotationAngle', e1.RotationAngle);
e2 = drawellipse('Center', e2.Center, 'SemiAxes', e2.SemiAxes, 'RotationAngle', e2.RotationAngle);

% Plot cylinder axis
x = linspace(-100, 100000, 10000000);
m = (c2(2) - c1(2)) / (c2(1) - c1(1));
b = c1(2) - m * c1(1);
y = m * x + b;
plot(x, y, 'b-', 'LineWidth', 2);

% Plot generatrix 1
x = linspace(-100, 100000, 10000000);
y = - (l1(1) * x  + l1(3)) / l1(2); 
plot(x, y, 'b-', 'LineWidth', 2);

% Plot generatrix 2
x = linspace(-100, 100000, 10000000);
y = - (l2(1) * x  + l2(3)) / l2(2); 
plot(x, y, 'b-', 'LineWidth', 2);

% Plot the 2 conics center
plot(c1(1), c1(2), 'r.', 'MarkerSize', 25);
plot(c2(1), c2(2), 'r.', 'MarkerSize', 25);

% Compute and plot the 2 intersection between l1 and ellipses 1
syms 'x';
syms 'y';
eq_rect = - y - (l1(1) * x  + l1(3)) / l1(2);
intersection_points = solve([eq1 == 0, eq_rect == 0], [x, y], 'IgnoreAnalyticConstraints', true, 'Maxdegree', 4);
i1 = [double(intersection_points.x(1)); double(intersection_points.y(1)); 1];
i2 = [double(intersection_points.x(2)); double(intersection_points.y(2)); 1];
plot(i1(1), i1(2), 'b.', 'MarkerSize', 25);
plot(i2(1), i2(2), 'r.', 'MarkerSize', 25);

% Compute and plot first diameter - from center to intersection
d1 = cross(c1, i1);
d1 = d1 ./ d1(3);
intersect_1 = i1;
x = linspace(-100000, 100000, 10000000);
y = - (d1(1) * x  + d1(3)) / d1(2); 
plot(x, y, 'g-', 'LineWidth', 2);

% Compute and plot the 2 intersection between l1 and ellipses 2
syms 'x';
syms 'y';
eq_rect = - y - (l1(1) * x  + l1(3)) / l1(2);
intersection_points = solve([eq2 == 0, eq_rect == 0], [x, y], 'IgnoreAnalyticConstraints', true, 'Maxdegree', 4);
i1 = [double(intersection_points.x(1)); double(intersection_points.y(1)); 1];
i2 = [double(intersection_points.x(2)); double(intersection_points.y(2)); 1];
plot(i1(1), i1(2), 'b.', 'MarkerSize', 25);
plot(i2(1), i2(2), 'r.', 'MarkerSize', 25);

% Compute and plot second diameter - from center to intersection
d2 = cross(c2, i1);
d2 = d2 ./ d2(3);
intersect_2 = i1;
x = linspace(-100000, 100000, 10000000);
y = - (d2(1) * x  + d2(3)) / d2(2); 
plot(x, y, 'g-', 'LineWidth', 2);

% Compute and plot the vanishing point as the intersection of the 2 diameters
vp2 = cross(d1, d2);
vp2 = vp2 ./ vp2(3);
save('vp2.mat','vp2');
plot(vp2(1), vp2(2), 'r.', 'MarkerSize', 25);
plot(vp(1), vp(2),'r.','MarkerSize', 25);

% Compute and plot the line at infinity 2
h2 = cross(vp, vp2);
h2 = h2 ./ norm(h2);
save('h2.mat','h2');
x = linspace(-100000, 100000, 10000000);
y = - (h2(1) * x  + h2(3)) / h2(2); 
plot(x, y, 'r-', 'LineWidth', 2);

data = load('iac.mat');
w = data.w;
data = load('h2.mat');
l2 = data.h2;

syms x y z;

% Intersect IAC and second horizon in order to find I' and J' relative to
% the plane parallel to the axis cylinder
e1 = w(1, 1) * x^2 + w(2, 2) * y^2 + w(3, 3) * z^2 + (w(1, 2) + w(2, 1)) * x * y + (w(1, 3) + w(3, 1)) * x * z + (w(2, 3) + w(3, 2)) * y * z == 0;
e2 = l2(1) * x + l2(2) * y + l2(3) * z == 0;
e3 = x ~= 0;
e4 = y ~= 0;
e5 = z ~= 0;

eqns = [e1, e2, e3, e4, e5];

S = solve(eqns, [x, y, z]);
I = [double(S.x(1)); double(S.y(1)); double(S.z(1))];
J = [double(S.x(2)); double(S.y(2)); double(S.z(2))];

% Once found I' and J', rectify the image
imDCCP = I*J.' + J*I.';
imDCCP = imDCCP./norm(imDCCP);
[u, s, v] = svd(imDCCP);
s(3,3) = 1;
H_rect = inv(u*sqrt(s));
H_rect = H_rect ./ norm(H_rect)
save('H_rect_axis_plane.mat','H_rect');

tform = maketform('projective', H_rect');
J = imtransform(imresize(im_rotated, 0.8), tform);
%figure;
%imshow(J);

% Compute the ratio
c1_rect = H_rect * c1;
c1_rect = c1_rect ./ c1_rect(3);

c2_rect = H_rect * c2;
c2_rect = c2_rect ./ c2_rect(3);

intersect_1_rect = H_rect * intersect_1;
intersect_1_rect = intersect_1_rect ./ intersect_1_rect(3);

intersect_2_rect = H_rect* intersect_2;
intersect_2_rect = intersect_2_rect ./ intersect_2_rect(3);

dist_1 = norm(c1_rect - intersect_1_rect);
dist_2 = norm(c2_rect - intersect_2_rect);
dist_c1_c2 = norm(c1_rect - c2_rect);

ratio = dist_1 / dist_c1_c2
ratio = dist_2 / dist_c1_c2

%% Another approach to find the same result but with angles
% First triangle
c1c2 = cross(c1, c2);
c1c2 = c1c2./c1c2(3);

r = cross(c1, intersect_1);
r = r./r(3);

c2r = cross(c2, intersect_1);
c2r = c2r./c2r(3);

% angle c1c2 and c2r
alfa = rad2deg(acos((c2r' * imDCCP * c1c2) / sqrt((c2r' * imDCCP * c2r) * (c1c2' * imDCCP * c1c2))));

% angle r and c1c2
% beta = rad2deg(acos((r' * imDCCP * c1c2) / sqrt((r' * imDCCP * r) * (c1c2' * imDCCP * c1c2))))

% angle c2r and r
gamma = rad2deg(acos((c2r' * imDCCP * r) / sqrt((r' * imDCCP * r) * (c2r' * imDCCP * c2r))));

ratio = sind(alfa) / sind(gamma)

% Second triangle
c1c2 = cross(c1, c2);
c1c2 = c1c2./c1c2(3);

r = cross(c2, intersect_2);
r = r./r(3);

c1r = cross(c1, intersect_2);
c1r = c1r./c1r(3);

% angle between c1r and c1c2
alfa = rad2deg(acos((c1r' * imDCCP * c1c2) / sqrt((c1r' * imDCCP * c1r) * (c1c2' * imDCCP * c1c2))));

% angle between r and c1c2
% beta = rad2deg(acos((r' * imDCCP * c1c2) / sqrt((r' * imDCCP * r) * (c1c2' * imDCCP * c1c2))));

% angle between r and c1r
gamma = rad2deg(acos((c1r' * imDCCP * r) / sqrt((r' * imDCCP * r) * (c1r' * imDCCP * c1r))));

gamma = 180 - gamma;
ratio = sind(alfa) / sind(gamma)

end