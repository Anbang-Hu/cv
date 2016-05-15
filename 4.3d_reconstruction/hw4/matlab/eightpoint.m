%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% During implementation, I consulted Hartley's paper:
%% http://www.cs.cmu.edu/afs/andrew/scs/cs/15-463/f07/proj_final/www/amichals/fundamental.pdf

function [ F ] = eightpoint( pts1, pts2, M )
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat

%     Write F and display the output of displayEpipolarF in your writeup

%% Compute normalized points
P1 = pts1 ./ M; X1 = P1(:,1); Y1 = P1(:,2);
P2 = pts2 ./ M; X2 = P2(:,1); Y2 = P2(:,2);

%% Compute coefficient matrix
A = [X1.*X2 X1.*Y2 X1, ...
     Y1.*X2 Y1.*Y2 Y1, ...
     X2     Y2     ones(size(pts1,1),1)];
 
%% Compute F
[~, ~, V] = svd(A);
F = reshape(V(:, end), [3 3]);

%% Apply singularity constraint
[U, S, V] = svd(F);
S(3, 3) = 0;
F = U * S * V';

%% Refine F
F = refineF(F, P1, P2);

%% Unscale F
T = diag([1/M, 1/M, 1]);
F = T' * F * T;

end

