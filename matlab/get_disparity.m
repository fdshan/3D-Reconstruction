function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.
[height, width] = size(im1)
w = (windowSize-1)/2
%% padding, make sure window is valid
im1 = im2double(im1);
im2 = im2double(im2);
im1_pad = padarray(im1, [w,w], 0, 'both');
im2_pad = padarray(im2, [w,w], 0, 'both');
%im2_pad = padarray(im2, [w+maxDisp,w+maxDisp], 0, 'both');

%% construct disparity map
for y=1:height
    %y
    for x=1:width
        min_dist = inf;
        for d=0:maxDisp
            %d
            %x
            %y
            if x-d>width || x-d<1
                continue;
            end
            temp = (im1_pad(y:y+w*2, x:x+w*2)-im2_pad(y:y+w*2, x-d:x-d+w*2)).^2;
            % summation on the window
            dist = conv2(temp, ones(windowSize, windowSize));
            if dist < min_dist
                min_dist = dist;
                dispM(y, x) = d;
            end
        end
        
    end
end

