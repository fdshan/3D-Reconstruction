function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2
%

im1 = im2double(im1);
im2 = im2double(im2);

pts2 = zeros(size(pts1));
[~, w, ~] = size(im2);
window = 5;
%% estimate epipolar line l'
for idx=1:size(pts1, 1)
    % estimate epipolar line l'
    x1 = round(pts1(idx, 1));
    y1 = round(pts1(idx, 2));
    target = im1(y1-window:y1+window, x1-window:x1+window, :);
    l = F * [pts1(idx, :) 1]'; % ax+by+c=0
    a = l(1);
    b = l(2);
    c = l(3);
    min_dist = inf; % init distance 10000
    %% generate sample points x' in im2
    for x2=1+window:w-window  % make sure x2 is valid
        y2 = round((-a*x2-c)/b);
        temp = im2(y2-window:y2+window, x2-window:x2+window, :);
        %% similarity score between x and x', use Euclidean distance
        dist = sqrt(sum((target(:)-temp(:)).^2));
        %% select the highest score, aka minimum distance
        if min_dist > dist
            min_dist = dist;
            pts2(idx, :) = [x2 y2];
        end
    end
end