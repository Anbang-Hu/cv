%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% Script for generating visualization of 1.4
%% Load images
Itrain = im2double(rgb2gray(imread('../data/test2.jpg')));
Itest = cell(1,1);
Itest{1} = im2double(rgb2gray(imread('../data/internet2.jpg')));

%% Train
nclick = 1;
figure(1); clf;
imshow(Itrain);
[x,y] = ginput(nclick);

blockx = round(x/8);
blocky = round(y/8); 

figure(2); clf;
for i = 1:nclick
  patch = Itrain(8*blocky(i)+(-63:64),8*blockx(i)+(-63:64));
  figure(2); subplot(3,2,i); imshow(patch);
end

f = hog(Itrain);

template = zeros(16,16,9);
for i = 1:nclick
  template = template + f(blocky(i)+(-7:8),blockx(i)+(-7:8),:); 
end

template = template/nclick;

%% Test
ndet = 5;
for k = 1:length(Itest)
    [x,y,score] = detect(Itest{k},template,ndet);

    %display top ndet detections
    figure; clf; imshow(Itest{k});
    for i = 1:ndet
      % draw a rectangle.  use color to encode confidence of detection
      %  top scoring are green, fading to red
      hold on; 
      h = rectangle('Position',[x(i)-64 y(i)-64 128 128],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
      hold off;
    end
end
