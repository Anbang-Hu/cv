%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% Test script for Q2X

%% Load image
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');

%% Load points
load('../data/some_corresp_noisy.mat');

%% Get size
M = max(size(im1,1), size(im1,2));

%% Compute fundamental matrix using eight point algo
F_eight = eightpoint(pts1, pts2, M);

%% Display result from eight point algo
displayEpipolarF(im1, im2, F_eight);

pause(1);

%% Compute fundamental matrix using seven point algo with RANSAC
F_RANSAC = ransacF(pts1, pts2, M);

%% Display result from seven point algo with RANSAC
displayEpipolarF(im1, im2, F_RANSAC);
