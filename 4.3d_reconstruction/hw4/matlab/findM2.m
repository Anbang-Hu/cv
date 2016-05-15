%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

% Q2.5 - Todo:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       3. Save the correct M2, p1, p2, R and P to q2_5.mat

%% Load data
im1 = imread('../data/im1.png');
load('../data/some_corresp.mat');
load('../data/intrinsics.mat');

%% Compute M2s
F = eightpoint(pts1, pts2, max(size(im1, 1), size(im1, 2)));
M2s = camera2(essentialMatrix(F, K1, K2));

%% Find best M2
p1 = pts1;
p2 = pts2;
M2 = [];
P = [];
smallestError = Inf;
M1 = [diag([1,1,1]), zeros(3,1)];
for i = 1:size(M2s,3)
    [currP, error] = triangulate(M1, p1, M2s(:, :, i), p2);
    count = sum((currP(:,3) >= 0));
    if error < smallestError && count == size(currP, 1)
        smallestError = error;
        M2  = M2s(:, :, i);
        P = currP;
    end
end

%% Save required variables
save('q2_5.mat', 'M2', 'p1', 'p2', 'P');