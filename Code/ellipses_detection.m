function ellipses_detection(img, img_gray_norm1, mode)

    % Manual ellipse selection
    if mode == "manual"
        figure;
        imshow(img);
        hold all;
        % Draw the first ellipse
        e1 = drawellipse();
        pause
        % Draw the second ellipse
        e2 = drawellipse();
        pause

        % Save the ellipses data
        save('ellipses.mat','e1','e2');
    end

    % Automatic ellipse detection
    if mode == "auto"
        % Binarize the normalized grayscale image
        img_bw = imbinarize(img_gray_norm1, 160/255);
        
        % Extract region properties of the connected components
        s = regionprops(img_bw,{...
            'Centroid',...
            'MajorAxisLength',...
            'MinorAxisLength',...
            'Orientation'});
        
        % Display the original image
        imshow(img)
        hold on
        t = linspace(0,2*pi,50);
        
        % Loop through detected ellipses and plot them
        for k = 1:length(s)
            if s(k).MajorAxisLength > 1500 && s(k).MinorAxisLength > 1300
                if k == 3716
                    continue
                end
                % Extract ellipse parameters
                a = s(k).MajorAxisLength/2;
                b = s(k).MinorAxisLength/2;
                Xc = s(k).Centroid(1);
                Yc = s(k).Centroid(2);
                phi = deg2rad(-s(k).Orientation);
                % Generate ellipse points and plot
                x = Xc + a*cos(t)*cos(phi) - b*sin(t)*sin(phi);
                y = Yc + a*cos(t)*sin(phi) + b*sin(t)*cos(phi);
                plot(x, y, 'blue','Linewidth', 1)
            end
        end
        hold off
    end
end
