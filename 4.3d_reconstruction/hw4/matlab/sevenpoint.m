%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% During implementation, I consulted the following slides:
%% https://staff.fnwi.uva.nl/l.dorst/hz/chap11_13.pdf

function [ F ] = sevenpoint( pts1, pts2, M )
% sevenpoint:
%   pts1 - N x 2 matrix of (x,y) coordinates
%   pts2 - N x 2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2 - Todo:
%     Implement the seven point algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup

%% Constants
N = size(pts1,1);

%% Randomly choose 7 points
I = randperm(N, 7)';
pts1 = pts1(I, :);
pts2 = pts2(I, :);

%% Compute normalized points
P1 = pts1 ./ M; X1 = P1(:,1); Y1 = P1(:,2);
P2 = pts2 ./ M; X2 = P2(:,1); Y2 = P2(:,2);

%% Compute coefficient matrix
A = [X1.*X2 X1.*Y2 X1, ...
     Y1.*X2 Y1.*Y2 Y1, ...
     X2     Y2     ones(7,1)];

%% Compute F1, F2
[~, ~, V] = svd(A);
F1 = reshape(V(:, end-1), [3 3]);
F2 = reshape(V(:, end), [3 3]);

%% Solve for alpha
syms Alpha % symbolic variable
polynomial = det(Alpha * F1 + (1 - Alpha) * F2);
coeff = fliplr(coeffs(polynomial, Alpha));
sol = real(double(roots(coeff)));

%% Compute F
T = diag([1/M, 1/M, 1]);
F = cell(size(sol));
for i = 1:length(F)
    F{i} = sol(i) * F1 + (1 - sol(i)) * F2;
    F{i} = refineF(F{i}, P1, P2);
    F{i} = T' * F{i} * T;
end

%% Write required data to a file
save('q2_2.mat', 'F', 'M', 'pts1', 'pts2');
end

