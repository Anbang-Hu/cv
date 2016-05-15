%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% Script for generating visualization of 1.2
im0 = imread('../data/test0.jpg');
ohist0 = hog(im2double(rgb2gray(im0)));
V0 = hogdraw(ohist0);
figure(1)
imagesc(V0);

im3 = imread('../data/test3.jpg');
ohist3 = hog(im2double(rgb2gray(im3)));
V3 = hogdraw(ohist3);
figure(2)
imagesc(V3);