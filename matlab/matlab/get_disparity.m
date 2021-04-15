function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.
[height, width] = size(im1);
w = (windowSize-1)/2
%% padding, make sure window is valid
im1 = im2double(im1);
im2 = im2double(im2);
dispM = zeros(height, width);
%% construct disparity map
for y=1:height
    for x=1:width
        min_dist = inf;
        for d=0:maxDisp
            if y-w<1 || y+w>height || x-w<1 || x+w>width || x-d-w<1 || x-d+w>width
                continue;
            end
            temp = (im1(y-w:y+w, x-w:x+w)-im2(y-w:y+w, x-d-w:x-d+w)).^2;
            %dist = conv2(temp, ones(windowSize, windowSize));
            if temp < min_dist
                min_dist = temp;
                dispM(y, x) = d;
            end
        end
        
    end
end

