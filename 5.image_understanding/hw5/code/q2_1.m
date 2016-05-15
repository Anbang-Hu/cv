%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% Script for generating templates
load('template_images_pos.mat');

figure(1)
for i = 1:length(template_images_pos)
    subplot(2,3, i), subimage(template_images_pos{i}); 
end

Itrain = cell(5,1);
Itrain{1} = im2double(rgb2gray(imread('../data/test0.jpg')));
Itrain{2} = im2double(rgb2gray(imread('../data/test1.jpg')));
Itrain{3} = im2double(rgb2gray(imread('../data/test2.jpg')));
Itrain{4} = im2double(rgb2gray(imread('../data/test4.jpg')));
Itrain{5} = im2double(rgb2gray(imread('../data/test6.jpg')));

figure(2)
% subplot(2,3,1), subimage(Itrain{1}); 
% subplot(2,3,2), subimage(Itrain{2}); 
% subplot(2,3,3), subimage(Itrain{3}); 
% subplot(2,3,4), subimage(Itrain{4}); 
% subplot(2,3,5), subimage(Itrain{5}); 
for i = 1:length(Itrain)
    subplot(2,3,i), subimage(Itrain{i}); 
end