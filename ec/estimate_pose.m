function P = estimate_pose(x, X)
% ESTIMATE_POSE computes the pose matrix (camera matrix) P given 2D and 3D
% points.
%   Args:
%       x: 2D points with shape [2, N]
%       X: 3D points with shape [3, N]
% P = K[R t]
x2d = x(1, :)';
y2d = x(2, :)';

x3d = X(1, :)';
y3d = X(2, :)';
z3d = X(3, :)';
one_element = ones(size(x,2), 1);
zero_element = zeros(size(x,2), 1);

A = [x3d, y3d, z3d, one_element, zero_element, zero_element, zero_element, zero_element, -x2d.*x3d, -x2d.*y3d, -x2d.*z3d, -x2d;
    zero_element, zero_element, zero_element, zero_element, x3d, y3d, z3d, one_element, -y2d.*x3d, -y2d.*y3d, -y2d.*z3d, -y2d];
[~, ~, V] = svd(A);
P = V(:, end);
P = reshape(P, [], 3)';
