%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% This function is implemented according to lecture slides 43-44 of
%% http://16720.courses.cs.cmu.edu/lec/two-view2.pdf; and Wikipedia on RANSAC

function [ F ] = ransacF( pts1, pts2, M )
% ransacF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.X - Extra Credit:
%     Implement RANSAC
%     Generate a matrix F from some '../data/some_corresp_noisy.mat'
%          - using sevenpoint
%          - using ransac

%     In your writeup, describe your algorithm, how you determined which
%     points are inliers, and any other optimizations you made

%% Initialization
numPoints = 7;
p = 1-(1e-12);
w = 0.75;  % Approximately
maxNumIters = ceil(log(1-p)/log(1-w^numPoints)); % Number of trials is computed according to lecture slides
epsilon = 1e-3;
cnt = 0;
matches = 0;
F = [];

%% For reproducibility
rng default

while cnt <= maxNumIters
    % Increment counter
    cnt = cnt + 1
    
    % Randomly choose seven points
    I = randperm(size(pts1, 1), numPoints);
    P1 = pts1(I, :);
    P2 = pts2(I, :);
    
    % Compute transformation
    F_ = sevenpoint(P1, P2, M);
    
    for i = 1:length(F_)
        % Count inliers by measuring distances
        D = diag([pts2, ones(size(pts2,1),1)] * F_{i} * [pts1, ones(size(pts1,1),1)]');
        numInliers = sum(abs(D) < epsilon);
        
        % Update best model if needed
        if numInliers > matches
            matches = numInliers;
            F = F_{i};
        end
    end
end

end

