function find_vanishing_line(im_rotated)

    % Load ellipse data from the 'ellipses_new.mat' file
    data = load('ellipses_new.mat');
    e1 = data.e1;
    e2 = data.e2;
    
    % Convert ellipse parameters of e1 to conic matrix C1
    par_geo = [e1.Center, e1.SemiAxes, -e1.RotationAngle]';
    par_alg = conic_param_geo2alg(par_geo);
    [a1, b1, c1, d1, e1, f1] = deal(par_alg(1), par_alg(2), par_alg(3), par_alg(4), par_alg(5), par_alg(6));
    C1 = [a1, b1/2, d1/2; b1/2, c1, e1/2; d1/2, e1/2, f1];
    save('C1.mat','C1');

    % Convert ellipse parameters of e2 to conic matrix C2
    par_geo = [e2.Center, e2.SemiAxes, -e2.RotationAngle]';
    par_alg = conic_param_geo2alg(par_geo);
    [a2, b2, c2, d2, e2, f2] = deal(par_alg(1), par_alg(2), par_alg(3), par_alg(4), par_alg(5), par_alg(6));
    C2 = [a2, b2/2, d2/2; b2/2, c2, e2/2; d2/2, e2/2, f2];
    save('C2.mat','C2');
    
    syms 'x';
    syms 'y';
    
    % Set up equations for the ellipses
    eq1 = a1*x^2 + b1*x*y + c1*y^2 + d1*x + e1*y + f1;
    eq2 = a2*x^2 + b2*x*y + c2*y^2 + d2*x + e2*y + f2;
    eqns = [eq1 == 0, eq2 == 0];
    
    % Solve the equations for the intersection points
    S12 = solve(eqns, [x, y], 'IgnoreAnalyticConstraints', true, 'Maxdegree', 4);
    s1 = [double(S12.x(1)); double(S12.y(1)); 1];
    s2 = [double(S12.x(2)); double(S12.y(2)); 1];
    save('s1.mat','s1');
    save('s2.mat','s2');
    
    % Calculate the vanishing line
    l_inf_1 = imag(cross(s1, s2));
    l_inf_1 = l_inf_1./norm(l_inf_1);
    save('h.mat','l_inf_1');

    w = size(im_rotated, 2);

    % Define two points A1 and B1 on the vanishing line
    A1 = [0; -l_inf_1(3)/l_inf_1(2); 1];
    B1 = [w; -(l_inf_1(3) + l_inf_1(1)*w)/l_inf_1(2); 1];

    % Display the rotated image with the vanishing line
    figure;
    imshow(im_rotated);
    hold all;
    plot(A1(1), A1(2), 'r.', 'MarkerSize', 25);
    plot(B1(1), B1(2), 'r.', 'MarkerSize', 25);
    plot([A1(1), B1(1)], [A1(2), B1(2)], 'linewidth', 2, 'Color', 'b');
    axis equal;

    % Save equations and results
    save('eq1.mat','eq1');
    save('eq2.mat','eq2');
end
