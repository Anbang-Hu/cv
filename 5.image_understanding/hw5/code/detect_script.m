% load a training example image
Itrain = im2double(rgb2gray(imread('../data/test2.jpg')));

%have the user click on some training examples.  
% If there is more than 1 example in the training image (e.g. faces), you could set nclicks higher here and average together
nclick = 1;
figure(1); clf;
imshow(Itrain);
[x,y] = ginput(nclick); %get nclicks from the user

% Itrain1 = im2double(rgb2gray(imread('../data/test0.jpg')));
% figure(1); clf;
% imshow(Itrain1);
% [x1,y1] = ginput(nclick);

%compute 8x8 block in which the user clicked
blockx = round(x/8);
blocky = round(y/8); 

% blockx1 = round(x1/8);
% blocky1 = round(y1/8); 

%visualize image patches that the user clicked on
figure(2); clf;
for i = 1:nclick
  patch = Itrain(8*blocky(i)+(-63:64),8*blockx(i)+(-63:64));
  figure(2); subplot(3,2,i); imshow(patch);
  
%   patch = Itrain1(8*blocky1(i)+(-63:64),8*blockx1(i)+(-63:64));
%   figure(2); subplot(3,2,i+1); imshow(patch);
end

% compute the hog features
f = hog(Itrain);

% f1 = hog(Itrain1);

% compute the average template for the user clicks
template = zeros(16,16,9);
for i = 1:nclick
  template = template + f(blocky(i)+(-7:8),blockx(i)+(-7:8),:); 
end
% for i = 1:nclick
%   template = template + f1(blocky1(i)+(-7:8),blockx1(i)+(-7:8),:); 
% end
template = template/nclick;
% 
% template = template/(2*nclick);

%
% load a test image
%
%%
Itest= im2double(rgb2gray(imread('../data/test3.jpg')));


% find top 5 detections in Itest
ndet = 5;
[x,y,score] = detect(Itest,template,ndet);

%display top ndet detections
figure; clf; imshow(Itest);
for i = 1:ndet
  % draw a rectangle.  use color to encode confidence of detection
  %  top scoring are green, fading to red
  hold on; 
  h = rectangle('Position',[x(i)-64 y(i)-64 128 128],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
  hold off;
end
