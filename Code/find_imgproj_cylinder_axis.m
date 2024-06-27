function find_imgproj_cylinder_axis(im_rotated)

    % Load data from various saved files
    data = load('C1.mat');
    C1 = data.C1;
    data = load('C2.mat');
    C2 = data.C2;
    data = load('h.mat');
    l_inf_1 = data.l_inf_1;
    data = load('vp.mat');
    vp = data.vp;
    data = load('l1.mat');
    l1 = data.l1;
    data = load('l2.mat');
    l2 = data.l2;

    % Calculate conic centers
    c1 = inv(C1) * l_inf_1; 
    c2 = inv(C2) * l_inf_1; 

    % Calculate axis direction of the cylindrical surface
    a = cross(c1, c2);
    a = a./a(3)

    % Normalize centers
    c1 = c1./c1(3);
    c2 = c2./c2(3);

    % Save conic centers
    save("center_c1.mat", "c1");
    save("center_c2.mat", "c2");

    % Display the rotated image
    figure;
    imshow(im_rotated);
    hold all 

    w = size(im_rotated,2);
    A1 = [0; -l_inf_1(3)/l_inf_1(2);1];
    B1 = [w; -(l_inf_1(3)+l_inf_1(1)*w)/l_inf_1(2);1];

    % Plot lines on the image
    plot(A1(1), A1(2), 'r.', 'MarkerSize', 25);
    plot(B1(1), B1(2), 'r.', 'MarkerSize', 25);
    plot([A1(1),B1(1)],[A1(2),B1(2)], 'linewidth', 2, 'Color', 'b');
    
    % Plot axis lines
    x = linspace(-100, 100000, 10000000);
    m = (c2(2) - c1(2)) / (c2(1) - c1(1));
    b = c1(2) - m * c1(1);
    y = m * x + b;
    plot(x, y, 'b-', 'LineWidth', 2);

    x = linspace(-100, 100000, 10000000);
    y = - (l2(1) * x  + l2(3)) / l2(2); 
    plot(x, y, 'b-', 'LineWidth', 2);

    x = linspace(-100, 100000, 10000000);
    y = - (l1(1) * x  + l1(3)) / l1(2); 
    plot(x, y, 'b-', 'LineWidth', 2);

    % Plot points and labels
    plot(c1(1), c1(2), 'r.', 'MarkerSize', 25);
    plot(c2(1), c2(2), 'r.', 'MarkerSize', 25);
    text(c1(1), c1(2), 'c1', 'FontSize', 20, 'Color', 'r')
    text(c2(1), c2(2), 'c2', 'FontSize', 20, 'Color', 'r')
    plot(vp(1),vp(2),'r.','MarkerSize', 25);

    hold off
end
