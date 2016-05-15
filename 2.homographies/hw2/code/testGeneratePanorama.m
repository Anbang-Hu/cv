%% This scripts is for Q6.2: test the final panorama

im1 = imread('../data/incline_L.png');
im2 = imread('../data/incline_R.png');

im3 = generatePanorama(im1, im2);

imwrite(im3, '../results/q6_2.jpg');