function [locsDoG, GaussianPyramid] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r)
%% function [GaussianPyramid] = createGaussianPyramid(im, sigma0, k, levels)
% Produces locsDoG, GaussianPyramid
% inputs
%   im - a grayscale image with range 0 to 1
%   sigma0 - the standard deviation of the blur at level 0
%   k - the multiplicative factor of sigma at each level, where sigma=sigma_0 k^l
%   levels - the levels of the pyramid where the blur at each level is
%   th_contrast - contrast threshold
%   th_r - Principle curvature threshold
% outputs
%   locsDog - N * 3 keypoints 
%   GaussianPyramid - R * C * L

GaussianPyramid = createGaussianPyramid(im, sigma0, k, levels);
[DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels);
PrincipalCurvature = computePrincipalCurvature(DoGPyramid);
locsDoG = getLocalExtrema(DoGPyramid, DoGLevels, PrincipalCurvature, th_contrast, th_r);
end