% Load images and mat file
I1 = imread('../data/im1.png');
I2 = imread('../data/im2.png');
load('../data/someCorresp.mat'); % pts1, pts2, M
% Run eight points to compute the fundamental matric F
F = eightpoint(pts1, pts2, M);
load('../data/intrinsics.mat'); % K1, K2
E = essentialMatrix(F, K1, K2)