%% Plot keypoints for '../data/model_chickenbroth.jpg'

sigma0 = 1; k = sqrt(2); levels = [-1,0,1,2,3,4]; th_contrast = 0.03; th_r = 12;
im = imread('../data/model_chickenbroth.jpg');
[locsDoG, GaussianPyramid] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r);
imshow(rgb2gray(im2double(im)));
hold on
scatter(locsDoG(:,1), locsDoG(:,2),'filled', 'o', 'red');