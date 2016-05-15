%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% Script for generating visualization in 1.1
im0 = imread('../data/test0.jpg');
[mag0, ori0] = mygradient(im2double(rgb2gray(im0)));
figure(1)
imagesc(mag0);
figure(2)
imagesc(ori0);

im3 = imread('../data/test3.jpg');
[mag3, ori3] = mygradient(im2double(rgb2gray(im3)));
figure(3)
imagesc(mag3);
figure(4)
imagesc(ori3);