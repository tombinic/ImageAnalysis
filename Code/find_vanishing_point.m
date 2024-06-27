function find_vanishing_point(im_rotated)

    data = load('l1.mat');
    l1 = data.l1;
    data = load('l2.mat');
    l2 = data.l2;

    % Display the rotated image
    figure;
    imshow(im_rotated);
    hold all

    % Plot lines on the image
    x = linspace(-100, 100000, 10000000);
    y = - (l2(1) * x  + l2(3)) / l2(2); 
    plot(x, y, 'b-', 'LineWidth', 2);

    x = linspace(-100, 100000, 10000000);
    y = - (l1(1) * x  + l1(3)) / l1(2); 
    plot(x, y, 'b-', 'LineWidth', 2);
    
    % Calculate the vanishing point by taking the cross product of the lines
    vp = cross(l1, l2);
    vp = vp / vp(3);
    
    % Save the vanishing point
    save("vp.mat", 'vp');
    
    % Plot the vanishing point on the image
    plot(vp(1), vp(2),'r.','MarkerSize', 40);
    hold off
end
