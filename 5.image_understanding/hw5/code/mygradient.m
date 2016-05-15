%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

function [mag,ori] = mygradient(I)
%%
% compute image gradient magnitude and orientation at each pixel
%
% Input:  gray scale image I
% Output: 
%   - mag: magnitude of gradients
%   - ori: orientation of gradients

%% Convert to gray scale image if necessary
if numel(size(I)) == 3
    I = rgb2gray(I);
end

%% Convert to double image
I = im2double(I);

% [dx, dy] = gradient(I);
% mag = sqrt(dx.^2 + dy.^2);
% ori = atan2d(dy, dx);

%% Compute gradients and orientations
[mag, ori] = imgradient(I);

index1 = ori >= -180 & ori < -90;
index2 = ori > 90 & ori <= 180;
ori(index1) = ori(index1) + 180;
ori(index2) = ori(index2) - 180;
