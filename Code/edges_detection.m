function edges = edges_detection(img, method)

% The best way to vary the threshold is to run edge once, capturing the calculated threshold as the second output argument.
% Then, starting from the value calculated by edge, adjust the threshold higher to detect fewer edge pixels, 
% or lower to detect more edge pixels.
threshold_values = [0.7, 0.8, 0.9, 1, 1.25, 1.45, 2.3, 2.75, 3.5];
if method == "canny"
    [BW2, th] = edge(img,'canny');
    
    % Uncomment if you want to run the grid search
    %{
    %figure;
    %imshow(BW2)
    %title('Canny Filter - normal');
    
    for i = 1:length(threshold_values)
        for j = 1:length(threshold_values)
            th2 = th.*[threshold_values(i), threshold_values(j)];
            th2
            BW2 = edge(img,'canny', th2);
            BW2 = bwareaopen(BW2, 80);
            figure;
            imshow(BW2)
            title(['Low: ' num2str(threshold_values(i)) ', High: ' num2str(threshold_values(j))]);
        end
    end   
    %}
end

if method == "roberts"
    [BW2, th] = edge(img, 'roberts');
    figure;
    imshow(BW2)
    title('Roberts Filter');
end

if method == "sobel"
    [BW2, th] = edge(img, 'Sobel');
    figure;
    imshow(BW2)
    title('Sobel Filter');
end

if method == "log"
    [BW2, th] = edge(im_gray_norm, 'log');
    figure;
    imshow(BW2)
    title('Log Filter');
end

th2 = th.*[3.5, 1.45];
edges = edge(img,'canny', th2, 5);
figure;
imshow(edges)
title(['Low: ' num2str(th2(1)) ', High: ' num2str(th2(2))]);

edges = [edges];