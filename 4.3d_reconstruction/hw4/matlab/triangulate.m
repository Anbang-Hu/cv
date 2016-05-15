%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% I choose to implement the linear triangulation described in slide 33,34 of
%% http://www.ics.uci.edu/~dramanan/teaching/cs217_spring09/lec/stereo.pdf

function [ P, error ] = triangulate( M1, p1, M2, p2 )
% triangulate:
%       M1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       M2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

% Q2.4 - Todo:
%       Implement a triangulation algorithm to compute the 3d locations
%       See Szeliski Chapter 7 for ideas

%% Initialization
N = size(p1, 1);
P = zeros(N, 3); % 3D points to be returned

%% Compute estimated 3D points for each pair of correspondence
for i = 1:N
    % Get 2D points
    x1 = p1(i, 1); y1 = p1(i, 2);
    x2 = p2(i, 1); y2 = p2(i, 2);
    
    % Compute coefficient matrix A
    A = [x1 * M1(3, :) - M1(1, :); ...
         y1 * M1(3, :) - M1(2, :); ...
         x2 * M2(3, :) - M2(1, :); ...
         y2 * M2(3, :) - M2(2, :)];
    
    % Estimate 3D point
    [~, ~, V] = svd(A);
    P(i, 1) = V(1, end) / V(end, end);
    P(i, 2) = V(2, end) / V(end, end);
    P(i, 3) = V(3, end) / V(end, end);
end

%% Compute reprojection error
P = [P, ones(N, 1)];

% Obtain reprojected point for p1
p1_ = (M1 * P')';
p1_ = p1_ ./ repmat(p1_(:, end), 1, 3);
p1_ = p1_(:, 1:2);

% Obtain reprojected point for p2
p2_ = (M2 * P')';
p2_ = p2_ ./ repmat(p2_(:, end), 1, 3);
p2_ = p2_(:, 1:2);

% Compute sum of Euclidean distances squared
D1 = sum(sum((p1 - p1_).^2));
D2 = sum(sum((p2 - p2_).^2));
% D1 = trace(pdist2(p1, p1_, 'euclidean').^2);
% D2 = trace(pdist2(p2, p2_, 'euclidean').^2);

% Sum up error
error = D1 + D2;

% Restore P
P = P(:, 1:3);
end

