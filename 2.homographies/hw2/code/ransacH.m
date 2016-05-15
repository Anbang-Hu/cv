function [bestH] = ransacH(matches, locs1, locs2, nIter, tol)
%% function [bestH] = ransacH(matches, locs1, locs2, nIter, tol)
% Produces bestH
% inputs
%   matches - indices of matched descriptors
%   locs1, locs2 - m * 3 keypoints
%   nIter - number of iterations to loop
%   tol - tolerance within which to qualify a point to be inlier
% outputs
%   bestH - best 3 * 3 homography matrix

% Set tolerance to 1 as default value
if nargin < 5
    tol = 1;
end

% Set nIter = 20000 as default value
if nargin < 4
    nIter = 20000;
end

N = size(matches, 1);
bestH = zeros(3,3);
bestNum   = 0;

for k = 1:nIter
    % Randomly select 4 points
    idx = matches(randperm(N, 4)',:);
    p1 = locs1(idx(:,1), 1:2)';
    p2 = locs2(idx(:,2), 1:2)';

    % Compute current model
    H2to1 = computeH(p1, p2);

    % Evaluate current model
    I2 = matches(:,2); I1 = matches(:,1);
    plocs1 = H2to1 * [locs2(I2, 1:2)'; ones(1, size(I2, 1))];
    plocs1 = plocs1 ./ repmat(plocs1(3,:),3,1);
    plocs1 = plocs1(1:2,:);
    qlocs1 = locs1(I1,1:2)';
    D = sqrt(sum((plocs1 - qlocs1).^2));
    Idx = D < tol;

    % Note down the best model
    if sum(Idx) > bestNum
        bestNum = sum(Idx);
        bestH = H2to1;
    end
end

end