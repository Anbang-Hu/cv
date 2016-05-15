function [locs, desc] = briefLite(im)
%% [locs, desc] = briefLite(im)
% Produces locs,desc
% inputs
%   im - a grayscale image with range 0 to 1
% outputs
%   locs - m * 3 keypoints
%   desc - m * n descriptor

sigma0 = 1; k = sqrt(2); levels = [-1,0,1,2,3,4]; th_contrast = 0.03; th_r = 12;
load('testPattern.mat');
[locsDoG, GaussianPyramid] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r);
[locs,desc] = computeBrief(im, GaussianPyramid, locsDoG, k, levels, compareX, compareY);

end