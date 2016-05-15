%%  load two of the chickenbroth images and compute feature matches
% For comparison against figure 4, load model_chickenbroth and
% checkenbroth_01
im1 = imread('../data/model_chickenbroth.jpg');
im2 = imread('../data/chickenbroth_01.jpg');

% Incline comparisons
% im1 = imread('../data/incline_L.png');
% im2 = imread('../data/incline_R.png');

% im1 = imread('../data/pf_scan_scaled.jpg');
% pf_scan_scaled against pf_desk
% im2 = imread('../data/pf_desk.jpg');
% pf_scan_scaled against pf_floor_rot
% im2 = imread('../data/pf_floor_rot.jpg');
% pf_scan_scaled against pf_floor
% im2 = imread('../data/pf_floor.jpg');
% pf_scan_scaled against pf_pile
% im2 = imread('../data/pf_pile.jpg');
% pf_scan_scaled against pf_stand
% im2 = imread('../data/pf_stand.jpg');


[locs1, desc1] = briefLite(im1);
[locs2, desc2] = briefLite(im2);

[matches] = briefMatch(desc1, desc2); % no need to pass in ratio

if size(im1,3) == 3
    im1 = rgb2gray(im1);
end

if size(im2, 3) == 3
    im2 = rgb2gray(im2);
end

plotMatches(im1, im2, matches, locs1, locs2);