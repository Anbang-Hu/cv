function [locs,desc] = computeBriefScaleInvariant(im, GaussianPyramid, locsDoG, k, levels, compareX, compareY)
%% [locs,desc] = computeBriefScaleInvariant(im, GaussianPyramid, locsDoG, k, levels, compareX, compareY)
% Produces locs,desc
% inputs
%   im - a grayscale image with range 0 to 1
%   GaussianPyramid - R * C * L matrix
%   locsDoG - keypoints locations
%   k - the multiplicative factor of sigma at each level, where sigma=sigma_0 k^l
%   levels - the levels of the pyramid where the blur at each level is
%   compareX - comparison point indices
%   compareY - comparison point indices
% outputs
%   locs - m * 3 keypoints
%   desc - m * n descriptor

rescaleRatio = rand * (0.9 - 0.2) + 0.2; % Randomly rescale image by 0.2 - 0.9
im = imresize(im, rescaleRatio);
im = im2double(im);
imgHeight = size(im, 1);
imgWidth = size(im, 2);
patchWidth = 9;  % patchWidth paramter is better to be passed in as an argument
radius = ceil(patchWidth * sqrt(2) / 2);

locs = [];
desc = [];

% Delete out-of-boundary cases
locsDoG_  = locsDoG(:, 1) < radius + 1 | ...
            locsDoG(:, 1) > (imgWidth - radius - 1) | ...
            locsDoG(:, 2) < radius + 1 | ...
            locsDoG(:, 2) > (imgHeight - radius - 1);
locsDoG_ = find(~locsDoG_);
locsDoG_ = locsDoG(locsDoG_,:);

L = size(locsDoG_, 1);

for i = 1:L
    % Get location of current keypoint
    x = locsDoG_(i, 1); y = locsDoG_(i, 2);
    
    % Compute oriented patch
    p = computeOrientedPatch(im, x, y, patchWidth, radius);
    
    % Get locs of current key points
    locs = [locs; locsDoG_(i,:)];
    
    % Compute a portion of BRIEF
%     p = im(y-floor(patchWidth/2):y+floor(patchWidth/2), ...
%            x-floor(patchWidth/2):x+floor(patchWidth/2));
    desc = [desc; (p(compareX) < p(compareY))'];
end
    
end

function p = computeOrientedPatch(im, x, y, patchWidth, radius)
temp = im(y-radius:y+radius, x-radius:x+radius);

[dx, dy] = gradient(temp);
orientation = atan(dy./dx) / pi * 180;
orientation = orientation + 180 * (dy > 0 & dx < 0);
orientation = orientation - 180 * (dy < 0 & dx < 0);

for angle = 0:10:359
    if angle == 0
        orientation(orientation >= 360 - 5 & orientation <  5) = 0;
    else
        orientation(orientation >= angle - 5 & orientation < angle + 5) = angle;
    end 
end
temp_ = imrotate(temp, mode(orientation(:)));
X = ceil(size(temp,1)/2); Y = ceil(size(temp,2)/2);
p = temp_(Y-floor(patchWidth/2):Y+floor(patchWidth/2), ...
          X-floor(patchWidth/2):X+floor(patchWidth/2));

end