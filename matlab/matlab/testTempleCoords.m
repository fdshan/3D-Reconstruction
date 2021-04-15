% A test script using templeCoords.mat
%
% Write your code here

%% Load the two images and the point correspondences from someCorresp.mat
I1 = imread('../data/im1.png');
I2 = imread('../data/im2.png');
load('../data/someCorresp.mat'); % pts1, pts2, M
p1 = pts1;
p2 = pts2;
%% Run eight points to compute the fundamental matric F
F = eightpoint(p1, p2, M);
%% Load the points in image 1, and get the corresponding points in image 2
load('../data/templeCoords.mat'); % pts1
points1 = pts1;
[points2] = epipolarCorrespondence(I1, I2, F, points1);
 %% Load intrinsics.mat and compute the essential matrix E
load('../data/intrinsics.mat'); % K1, K2
E = essentialMatrix(F, K1, K2);
%% Compute the first camera projection matrix P1 and four candidates for P2
M1 = [eye(3) zeros(3, 1)];  % no rotation and translation, (I|0)
P1 = K1*M1;
M2s = camera2(E);
% The correct configuration is the one for which most of the 3D points are in front of both cameras
%M2 = M2s(:, :, 1);
M2 = M2s(:, :, 2);
%M2 = M2s(:, :, 3);
%M2 = M2s(:, :, 4);
P2 = K2*M2;
%% Run your triangulate function using the four sets of camera matrix candidates
pts3d = triangulate(P1, points1, P2, points2);
%% plot these point correspondences on screen
figure
plot3(pts3d(:, 1), pts3d(:, 2), pts3d(:, 3), '.');
axis equal
%% save extrinsic parameters for dense reconstruction
R1 = eye(3);
t1 = zeros(3, 1);
R2 = M2(:, 1:3);
t2 = M2(:, 4);
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');

