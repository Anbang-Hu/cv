%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% This script is first created in matlab/ folder. In order to run the commented
%% part, this script has to be copied back to matlab/ folder

im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
im1_ = im2double(rgb2gray(im1));
im2_ = im2double(rgb2gray(im2));

load('q2_5.mat');

[y1, x1] = ind2sub(size(im1_), find(im1_ > 0.21));
figure(1)
scatter(x1, y1);

% findM2;
% x2 = zeros(size(x1));
% y2 = zeros(size(y1));
% tic
% for i = 1:size(x1, 1)
%     if mod(i, 10000) == 0
%         fprintf('%d points completed\n', i); toc
%     end
%     [x, y] = epipolarCorrespondence(im1, im2, F, x1(i), y1(i));
%     x2(i) = x;
%     y2(i) = y;
% end
% 
% save('temp.mat', 'x1', 'y1', 'x2', 'y2');
% 
% %% Compute 3D points
% p1 = [x1 y1];
% p2 = [x2 y2];
% [P, ~] = triangulate(K1 * M1, p1, K2 * M2, p2);
% 
% %% Store results
% save('q2_8.mat', 'P', 'p1', 'p2');

load('q2_8.mat');

im1 = im2double(im1);
im2 = im2double(im2);

S = 5 * ones(size(P, 1), 1);
C = zeros(size(P, 1), 3);

for i = 1:size(P, 1)
    for j = 1:size(C, 2)
%         C(i, j) = im1(p1(i,2),p1(i,1),j) + im2(p2(i,2),p2(i,1),j);
        C(i, j) = im1(p1(i,2),p1(i,1),j);
%         C(i, j) = im2(p2(i,2),p2(i,1),j);
    end
end
%% Plot 3D scatter graph
figure(2)
scatter3(P(:,1), P(:,2), P(:,3), S, C, 'filled');

