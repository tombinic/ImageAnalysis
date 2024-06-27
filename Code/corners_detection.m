function corners = corners_detection(img_orig, img, method)
    % Check the specified method for corner detection
    if method == "Harris"
        % Use Harris corner detection algorithm
        corners = detectHarrisFeatures(img);
    end

    if method == "Surf"
        % Use SURF corner detection algorithm
        corners = detectSURFFeatures(img);
    end

    % Display the original image with detected corners
    figure, imshow(img_orig); hold on;
    plot(corners.selectStrongest(1000));
    hold off
end
