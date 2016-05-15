function im3 = generatePanorama(im1, im2)
%% function im3 = generatePanorama(im1, im2)
% Produces im3
% inputs
%   img1, img2 - two images to be stitched
% outputs
%   im3 - panorama image

im1 = im2double(im1);
im2 = im2double(im2);

[locs1, desc1] = briefLite(im1);
[locs2, desc2] = briefLite(im2);

matches = briefMatch(desc1, desc2, 0.8);

H = ransacH(matches, locs1, locs2);

im3 = imageStitching_noClip(im1, im2, H);

end