%% This script is for Q5.2

img1 = imread('../data/incline_L.png');
img2 = imread('../data/incline_R.png');

img1 = im2double(img1);
img2 = im2double(img2);

[locs1, desc1] = briefLite(img1);
[locs2, desc2] = briefLite(img2);

matches = briefMatch(desc1, desc2, 0.45);

p1 = locs1(matches(:,1), 1:2)';
p2 = locs2(matches(:,2), 1:2)';

H2to1 = computeH(p1,p2);

panoImg = imageStitching_noClip(img1, img2, H2to1);

imwrite(panoImg, '../results/q5_2_pan.jpg');