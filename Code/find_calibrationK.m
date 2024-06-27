function find_calibrationK()

    % Load data from saved files
    data = load('s1.mat');
    s1 = data.s1;
    data = load('s2.mat');
    s2 = data.s2;
    data = load('vp.mat');
    vp = data.vp;

    % Define the normalized image of the conic dual to the circular points
    II = s1;
    JJ = s2;
    imDCCP = II*JJ.' + JJ*II.';
    imDCCP = imDCCP./norm(imDCCP);
    l_inf = null(imDCCP);

    % Singular Value Decomposition (SVD) of the image of the conic dual to the circular points
    [u, s, v] = svd(imDCCP);
    s(3,3) = 1;
    
    % Rectification matrix
    H_rect = inv(u*sqrt(s));
    H_rect = H_rect ./ norm(H_rect);
    save('H_rect_ellipses_plane.mat','H_rect');

    % Invert rectification matrix to obtain the calibration matrix K
    H_rect = inv(H_rect);
    h1 = H_rect(:, 1);
    h2 = H_rect(:, 2);
    
    % Define symbolic variables
    syms 'x', syms 'y', syms 'z', syms 'c';
    w = [x, 0, y; 0, 1, z; y, z, c];

    % Define known values
    h1 = real(II);
    h2 = imag(II);
    
    % Set up a system of equations to solve for the calibration matrix
    eqs = [ l_inf(1) == vp(1) * x + vp(3) * y;
            %l_inf(2) == vp(2) + vp(3) * z;
            l_inf(3) == c * vp(3) + y * vp(1) + vp(2) * z; 
            h1' * w * h2 == 0;
            h1' * w * h1 - h2' * w * h2 == 0;
          ];
    
    % Solve the system of equations
    res = solve(eqs);

    % Extract parameters from the solution
    param = [double(res.x(1)); double(res.y(1)); double(res.z(1)); double(res.c(1))];
    
    % Build the calibration matrix K
    w = [param(1), 0, param(2); 0, 1, param(3); param(2), param(3), param(4)];
    k = inv(chol(w));
    k = k./k(3,3);

    % Save calibration matrix and related parameters
    save('iac.mat','w');
    save('K.mat','k');
end
