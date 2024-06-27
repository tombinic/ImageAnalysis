function orientation_axis(im_rotated)

    % Load necessary data
    data = load('H_rect_ellipses_plane.mat');
    H_rect = data.H_rect;

    data = load('K.mat');
    k = data.k;

    data = load('center_c2.mat');
    c2 = data.c2;
    data = load('center_c1.mat');
    c1 = data.c1;
    
    data = load('vp.mat');
    vp = data.vp;

    line_1_1 = load('generatrix_lines.mat').line_1_1;
    line_1_2 = load('generatrix_lines.mat').line_1_2;
    line_2_1 = load('generatrix_lines.mat').line_2_1;
    line_2_2 = load('generatrix_lines.mat').line_2_2;

    p1_1 = [line_1_1, 1];
    p2_1 = [line_1_2, 1];
    p1_2 = [line_2_1, 1];
    p2_2 = [line_2_2, 1];
    
    % Calculate essential matrices
    res = inv(k) * H_rect;
    i_pi = res(:, 1);
    j_pi = res(:, 2);
    O_pi = res(:, 3);
    
    % Calculate the camera coordinate system in 3D
    k_pi = cross(i_pi, j_pi);
    res = [i_pi j_pi k_pi O_pi; 0 0 0 1];
    
    % Transform 2D points and centers to 3D coordinates
    c1_3d = res * [c1(1); c1(2); 0; c1(3)]; 
    c2_3d = res * [c2(1); c2(2); 0; c2(3)];
    p1_1_3d = res * [p1_1(1); p1_1(2); 0; p1_1(3)];
    p2_1_3d = res * [p2_1(1); p2_1(2); 0; p2_1(3)];
    p1_2_3d = res * [p1_2(1); p1_2(2); 0; p1_2(3)];
    p2_2_3d = res * [p2_2(1); p2_2(2); 0; p2_2(3)];
    vp_3d = res * [vp(1); vp(2); 0; vp(3)];

    % Normalize 3D coordinates
    c1_3d = c1_3d./c1_3d(4);
    c2_3d = c2_3d./c2_3d(4);
    p1_1_3d = p1_1_3d./p1_1_3d(4);
    p2_1_3d = p2_1_3d./p2_1_3d(4);
    p1_2_3d = p1_2_3d./p1_2_3d(4);
    p2_2_3d = p2_2_3d./p2_2_3d(4);
    vp_3d = vp_3d./vp_3d(4);

    % Plot the 3D points and lines
    figure(1);
    
    scatter3(p1_1_3d(1),p1_1_3d(2),p1_1_3d(3),'filled','color','b')
    hold on
    scatter3(p2_1_3d(1),p2_1_3d(2),p2_1_3d(3),'filled','color','b')
    hold on

    scatter3(p1_2_3d(1),p1_2_3d(2),p1_2_3d(3),'filled','color','b')
    hold on
    scatter3(p2_2_3d(1),p2_2_3d(2),p2_2_3d(3),'filled','color','b')
    hold on
    scatter3(vp_3d(1),vp_3d(2),vp_3d(3),'filled','color','b')
    text(vp_3d(1),vp_3d(2),vp_3d(3),'V')
    hold on
    
    scatter3(c1_3d(1),c1_3d(2),c1_3d(3),'filled','color','b')
    text(c1_3d(1),c1_3d(2),c1_3d(3),'c1')
    hold on
    scatter3(c2_3d(1),c2_3d(2),c2_3d(3),'filled','color','b')
    text(c2_3d(1),c2_3d(2),c2_3d(3),'c2')
    scatter3(0,0,0,'g')
    text(0,0,0,'cam')
    
    plot3([c1_3d(1) vp_3d(1)],[c1_3d(2) vp_3d(2)],[c1_3d(3) vp_3d(3)],'color','g','LineWidth',1)
    plot3([c1_3d(1) c2_3d(1)],[c1_3d(2) c2_3d(2)],[c1_3d(3) c2_3d(3)],'color','g','LineWidth',1)
    plot3([p1_1_3d(1) p2_1_3d(1)],[p1_1_3d(2) p2_1_3d(2)],[p1_1_3d(3) p2_1_3d(3)],'color','g','LineWidth',1)
    plot3([p1_2_3d(1) p2_2_3d(1)],[p1_2_3d(2) p2_2_3d(2)],[p1_2_3d(3) p2_2_3d(3)],'color','g','LineWidth',1)
    
    % Set axis labels
    xlabel('X');
    ylabel("Y");
    zlabel("Z")


end
