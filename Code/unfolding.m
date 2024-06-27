function unfolding()
    rectifiedImage = imread("crop1.png");
    
    % Load transformation matrix H_rect
    data = load('H_rect_axis_plane.mat');
    H_rect = data.H_rect;
    
    % Create a projective transformation object using the transpose of H_rect
    tform = projective2d(H_rect');
    
    % Apply the transformation to the input image and resize it
    J = imwarp(imresize(rectifiedImage, 0.2), tform);
    
    % Display the transformed image
    figure;
    imshow(J);
    
    % Create a meshgrid for polar coordinate transformation
    [X, Y] = meshgrid((1:2500), (1:2500));
    
    % Convert Cartesian coordinates to polar coordinates
    [theta, rho] = cart2pol(X, Y);
    
    % Initialize Z (depth) to zeros
    Z = zeros(size(theta));
    
    % Display the original and transformed images side by side
    figure
    subplot(121), imshow(J), axis on
    subplot(122), warp(theta, rho, Z, J), view(2), axis square

end