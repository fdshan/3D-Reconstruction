%% Load an image, a CAD model cad, 2D points x and 3D points X from PnP.mat.
load('../data/PnP.mat');  % cad, image, X[3,N], x[2,N]

%% estimate camera matrix P, intrinsic matrix K, rotation matrix R, and translation t
[K, R, t] = estimate_params(P);
P = estimate_pose(x, X);
%% Use your estimated camera matrix P to project the given 3D points X onto the image
x_generate = P*[X; ones(1, size(X,2))];
x_generate = [x_generate(1,:)./x_generate(3,:); x_generate(2,:)./x_generate(3,:)];  % [x,y,1]

%% Plot the given 2D points x and the projected 3D points on screen, use plot
figure
imshow(image);
hold on
plot(x_generate(1,:), x_generate(2,:), 'o');
plot(x(1,:), x(2,:),'.');
%% Draw the CAD model rotated by your estimated rotation R on screen, use trimesh
rotated = cad.vertices*R';
figure
trimesh(cad.faces, rotated(:,1), rotated(:,2), rotated(:,3));
%% Project the CAD's all vertices onto the image and draw the projected CAD model overlapping with the 2D image, use patch
projected = P*[cad.vertices ones(size(cad.vertices,1), 1)]';
projected = [projected(1,:)./projected(3,:); projected(2,:)./projected(3,:)]';
figure
imshow(image);
hold on
patch('Faces',cad.faces,'Vertices',projected,'FaceColor','red', 'EdgeColor', 'none', 'FaceAlpha',.3);
