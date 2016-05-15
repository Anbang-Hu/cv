function [compareX, compareY] = makeTestPattern(patchWidth, nbits)
%% function [compareX, compareY] = makeTestPattern(patchWidth, nbits)
%  Produces compareX, compareY
%  Input:
%    patchWidth - path size
%    nbits - number of points to select
%  Output:
%    compareX - comparison point indices
%    compareY - comparison point indices

mu      = ceil(patchWidth/2);
sigma   = 1/25 * patchWidth^2;

compareX = round(mvnrnd([mu,mu],diag([sigma,sigma]),nbits));
compareY = round(mvnrnd([mu,mu],diag([sigma,sigma]),nbits));

% Clamp those less than 1 to 1
compareX(compareX < 1) = 1;
compareY(compareY < 1) = 1;

% Clamp those more than patchWidth to patchWidth
compareX(compareX > patchWidth) = patchWidth;
compareY(compareY > patchWidth) = patchWidth;

% Translates to 1-D index
compareX = sub2ind([patchWidth patchWidth], compareX(:,1), compareX(:,2));
compareY = sub2ind([patchWidth patchWidth], compareY(:,1), compareY(:,2));

% Save results for future usage
save('testPattern.mat', 'compareX', 'compareY');

end