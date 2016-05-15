function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q2.6 - Todo:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q2_6.mat
%
%           Explain your methods and optimization in your writeup

%% Paramters
hsize = 12; sigma = (2 * hsize) / 6;

%% Pre-process images
if numel(size(im1)) == 3
    im1 = rgb2gray(im1);
end
if numel(size(im2)) == 3
    im2 = rgb2gray(im2);
end
im1 = im2double(im1);
im2 = im2double(im2);
im1Padded = zeros(size(im1, 1) + 2*hsize, size(im1, 2) + 2*hsize);
im2Padded = zeros(size(im2, 1) + 2*hsize, size(im2, 2) + 2*hsize);
im1Padded(hsize+1:hsize+size(im1, 1), hsize+1:hsize+size(im1, 2)) = im1;
im2Padded(hsize+1:hsize+size(im2, 1), hsize+1:hsize+size(im2, 2)) = im2;

%% Create Gaussian Weighter
GaussianWeighter = fspecial('gaussian', 2*hsize+1, sigma);

%% Set Search Range according to y-axis since the epipolar line is almost vertical
SearchRadius = 50;
SearchRangeY = y1-SearchRadius:y1+SearchRadius;

%% Compute epipolar line
EpipolarLine = F * [x1 y1 1]';
a = EpipolarLine(1);
b = EpipolarLine(2);
c = EpipolarLine(3);

%% Compute target patch in image1
centerX = hsize + x1;
centerY = hsize + y1;
targetPatch = im1Padded(centerY-hsize:centerY+hsize, centerX-hsize:centerX+hsize);

%% Search for best match
bestD = Inf;
x2 = 0;
y2 = 0;
for y = SearchRangeY(1):SearchRangeY(end)
    % Compute x value
    x = round((-b * y - c) / a);
    
    % Check boundary condition
    if x < 1 || x > size(im2, 2)
        continue;
    end
    
    % Create a patch centered at (x, y)
    centerX = hsize + x;
    centerY = hsize + y;
    patch = im2Padded(centerY-hsize:centerY+hsize, centerX-hsize:centerX+hsize);
    
    % Compute sum of weighted Euclidean distances
    D = sqrt((patch - targetPatch) .* (patch - targetPatch)) .* GaussianWeighter;
    D = sum(D(:));
    
    % Update the best match if needed
    if D < bestD
        bestD = D;
        x2 = x;
        y2 = y;
    end
end
end

