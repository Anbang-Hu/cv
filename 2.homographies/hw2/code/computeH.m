function H2to1 = computeH(p1,p2)
%% function H2to1 = computeH(p1,p2)
% Produces H2to1
% inputs
%   p1, p2 - 2 * N matrices of corresponding points
% outputs
%   H2to1 - 3 * 3 homography matrix

% Construct A
N = size(p1, 2);
A1 = [p2', ones(N,1), zeros(N,3), -p1(1,:)'.*p2(1,:)', -p1(1,:)'.*p2(2,:)', -p1(1,:)'];
A2 = [zeros(N,3), p2', ones(N,1), -p1(2,:)'.*p2(1,:)', -p1(2,:)'.*p2(2,:)', -p1(2,:)'];
A = [A1; A2];

% Compute eigenvectors and eigenvalues
M = A' * A;
[V, D] = eig(M);

% Select the min eigenvector
[~, I] = min(diag(D));
v = V(:, I)';

% Assemble homography matrix
H2to1 = [v(1:3); v(4:6); v(7:9)];

end