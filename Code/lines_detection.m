function lines = lines_detection(edges, img, n_lines, fill_gap)

% Perform Hough transform on the edges of the image
[H, Theta, Rho] = hough(edges, 'Theta', -90:0.5:89.9);

% Find peaks in the Hough accumulator matrix
peaks = houghpeaks(H, n_lines, "Threshold", 0.1*max(H(:)), "NHoodSize", [301 301]);

% Extract lines from Hough transform
lines = houghlines(edges, Theta, Rho, peaks, 'FillGap', fill_gap, 'MinLength', 45);

% Display the original image with detected lines
figure, imshow(img), hold on
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',1.5,'Color','blue');
    text(xy(1,1),xy(1,2), num2str(k), 'Color', 'black')
    plot(xy(1,1), xy(1,2), '*', 'LineWidth', 1,'Color', 'white');
    plot(xy(2,1), xy(2,2), '*', 'LineWidth', 1, 'Color', 'magenta');
end

% Save information about the detected lines if there are exactly 2 lines
if n_lines == 2
    % Save points defining the two generatrix lines
    line_1_1 = lines(1).point1;
    line_1_2 = lines(1).point2;
    line_2_1 = lines(2).point1;
    line_2_2 = lines(2).point2;
    
    save('generatrix_lines.mat','line_1_1','line_1_2', 'line_2_1', 'line_2_2');

    % Represent lines in homogeneous coordinates and normalize
    p1_1 = [line_1_1, 1];
    p2_1 = [line_1_2, 1];
    l1 = cross(p1_1, p2_1);
    l1 = l1 ./ norm(l1);
    save('l1.mat','l1');

    p1_2 = [line_2_1, 1];
    p2_2 = [line_2_2, 1];
    l2 = cross(p1_2, p2_2);
    l2 = l2 ./ norm(l2);
    save('l2.mat','l2');
end

% Return the detected lines
lines = [lines];
end
