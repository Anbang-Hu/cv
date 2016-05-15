%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% Script for Q2.7
%% Load image
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');

%% Load points
load('../data/templeCoords.mat');

%% Compute F, M1, M2
findM2;

%% Find correspondences
x2 = zeros(size(x1));
y2 = zeros(size(y1));
for i = 1:size(x1, 1)
    [x, y] = epipolarCorrespondence(im1, im2, F, x1(i), y1(i));
    x2(i) = x;
    y2(i) = y;
end

%% Compute 3D points
p1 = [x1 y1];
p2 = [x2 y2];
[P, ~] = triangulate(K1 * M1, p1, K2 * M2, p2);

%% Save required variables
save('q2_7.mat', 'F', 'M1', 'M2');

%% Plot 3D scatter graph
scatter3(P(:,1), P(:,2), P(:,3));

