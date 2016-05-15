%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% Test script for Q2.1

%% Load image
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');

%% Load points
load('../data/some_corresp.mat');

%% Get size
M = max(size(im1,1), size(im1,2));

%% Compute fundamental matrix
F = eightpoint(pts1, pts2, M);

%% Write required data to a file
save('q2_1.mat', 'F', 'M', 'pts1', 'pts2');

%% Display result
displayEpipolarF(im1, im2, F);