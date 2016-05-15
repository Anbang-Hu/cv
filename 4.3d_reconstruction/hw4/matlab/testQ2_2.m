%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% Test script for Q2.2

%% Load image
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');

%% Load points
load('../data/some_corresp.mat');

% f1 = figure(1);
% imshow(im1);
% hold on
% plot(pts1(1:7,1), pts1(1:7,2),'or', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
% 
% f2 = figure(2);
% imshow(im2);
% hold on
% plot(pts2(1:7,1), pts2(1:7,2),'ob', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
% 
% pause(2);
% close(f1);
% close(f2);

%% Get size
M = max(size(im1,1), size(im1,2));

%% Compute fundamental matrix
F = sevenpoint(pts1, pts2, M);

%% Display result
for i = 1:length(F)
    displayEpipolarF(im1, im2, F{i});
end

F = F{2};
displayEpipolarF(im1, im2, F);

