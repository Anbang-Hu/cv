%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% Test script for Q2.6

%% Load image
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');

%% Load points
load('../data/some_corresp.mat');

%% Get size
M = max(size(im1,1), size(im1,2));

%% Compute fundamental matrix
F = eightpoint(pts1, pts2, M);

%% Run epipolarMatchGUI
[pts1, pts2] = epipolarMatchGUI(im1, im2, F);

%% Write required data to a file
save('q2_6.mat', 'F', 'pts1', 'pts2');
