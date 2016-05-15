function [locs,desc] = computeBrief(im, GaussianPyramid, locsDoG, k, levels, compareX, compareY)
%% [locs,desc] = computeBrief(im, GaussianPyramid, locsDoG, k, levels, compareX, compareY)
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

imgHeight = size(im, 1);
imgWidth = size(im, 2);
patchWidth = 9;  % patchWidth paramter is better to be passed in as an argument

locs = [];
desc = [];

% Delete out-of-boundary cases
locsDoG_  = locsDoG(:, 1) < (floor(patchWidth/2) + 1) | ...
            locsDoG(:, 1) > (imgWidth - floor(patchWidth/2) - 1) | ...
            locsDoG(:, 2) < (floor(patchWidth/2) + 1) | ...
            locsDoG(:, 2) > (imgHeight - floor(patchWidth/2) - 1);
locsDoG_ = find(~locsDoG_);
locsDoG_ = locsDoG(locsDoG_,:);

L = size(locsDoG_, 1);

for i = 1:L
    % Get location of current keypoint
    x = locsDoG_(i, 1); y = locsDoG_(i, 2);
    
    % Get locs of current key points
    locs = [locs; locsDoG_(i,:)];
    
    % Compute a portion of BRIEF
    p = im(y-floor(patchWidth/2):y+floor(patchWidth/2), ...
           x-floor(patchWidth/2):x+floor(patchWidth/2));
    desc = [desc; (p(compareX) < p(compareY))'];
end
    
end