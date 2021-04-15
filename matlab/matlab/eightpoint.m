function F = eightpoint(pts1, pts2, M)
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'
%load('../data/someCorresp.mat');

%% normalize the input points
norm_pts1 = pts1/M;
norm_pts2 = pts2/M;
T = [1/M, 0, 0; 0, 1/M, 0; 0, 0, 1];

x_x1 = norm_pts1(:, 1);
y_x1 = norm_pts1(:, 2);
x_x2 = norm_pts2(:, 1);
y_x2 = norm_pts2(:, 2);

%% construct F matrix
one_element = ones(size(x_x1)); % 1
% xx', xy', x, yx', yy', y, x', y', 1
A = [x_x1.*x_x2, x_x2.*y_x1, x_x2, y_x2.*x_x1, y_x2.*y_x1, y_x2, x_x1, y_x1, one_element];

[~, ~, V] = svd(A);
F = reshape(V(:, end), 3, 3)';

%% enforce rank 2 constraint on F
[U, S, V1] = svd(F);
S = diag(diag(S));
S(:, end) = 0; % set the smallest singular value in S to zero
F = U * S * V1';
F = refineF(F, norm_pts1, norm_pts2); % refine, using local minimization

%% de-normalize F
F = T'*F*T;
end

