function pts3d = triangulate(P1, pts1, P2, pts2 )
% triangulate estimate the 3D positions of points from 2d correspondence
%   Args:
%       P1:     projection matrix with shape 3 x 4 for image 1
%       pts1:   coordinates of points with shape N x 2 on image 1
%       P2:     projection matrix with shape 3 x 4 for image 2
%       pts2:   coordinates of points with shape N x 2 on image 2
%
%   Returns:
%       Pts3d:  coordinates of 3D points with shape N x 3
%
p1_1 = P1(1, :);
p1_2 = P1(2, :);
p1_3 = P1(3, :);

p2_1 = P2(1, :);
p2_2 = P2(2, :);
p2_3 = P2(3, :);

A = zeros(4, 4);
temp = zeros(size(pts1,1), 4);
for idx=1:size(pts1,1)
    x1 = pts1(idx, 1);
    y1 = pts1(idx, 2);
    
    x2 = pts2(idx, 1);
    y2 = pts2(idx, 2);
    
    A = [y1.*p1_3-p1_2; p1_1-x1.*p1_3; y2.*p2_3-p2_2; p2_1-x2.*p2_3];
    [~, ~, V] = svd(A);
    temp(idx, :) = V(:, 4)';
end
pts3d = [temp(:, 1)./temp(:, 4), temp(:, 2)./temp(:, 4), temp(:, 3)./temp(:, 4)];
%% project the estimated 3D points back to the image 1 and 2
temp1 = [pts3d ones(size(pts3d, 1), 1)]*P1'; % n,3
re_pts1 = [temp1(:, 1)./temp1(:, 3), temp1(:, 2)./temp1(:, 3)];
temp2 = [pts3d ones(size(pts3d, 1), 1)]*P2';
re_pts2 = [temp2(:, 1)./temp2(:, 3), temp2(:, 2)./temp2(:, 3)];
%% compute the mean Euclidean error between projected 2D points and pts1/2.
error1 = mean(sqrt(sum((pts1-re_pts1).^2, 2)))
error2 = mean(sqrt(sum((pts2-re_pts2).^2, 2)))