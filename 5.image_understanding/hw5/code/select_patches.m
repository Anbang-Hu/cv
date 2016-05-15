%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% I choose to build a pedestrian crossing sign template
function select_patches()
num_pos = 5;
num_neg = 100;
template_dim = 128;
Itrain = cell([num_pos,1]);
Itrain{1} = im2double(rgb2gray(imread('../data/test0.jpg')));
Itrain{2} = im2double(rgb2gray(imread('../data/test1.jpg')));
Itrain{3} = im2double(rgb2gray(imread('../data/test2.jpg')));
Itrain{4} = im2double(rgb2gray(imread('../data/test4.jpg')));
Itrain{5} = im2double(rgb2gray(imread('../data/test6.jpg')));

%% User selects five positive templates
rects = zeros(num_pos,4);
template_images_pos = cell([num_pos,1]);
for i = 1:num_pos
    imshow(Itrain{i});
    rect = round(getrect);
    rects(i,:) = rect;
    template_images_pos{i} = resizePatch(Itrain{i}, rect, template_dim);
end

%% Automatically selects 100 negative templates
template_images_neg = cell([num_neg, 1]);
for i = 1:length(Itrain)
    xmax = size(Itrain{i}, 2);
    ymax = size(Itrain{i}, 1);
    for j = 1:num_neg/length(Itrain)
        while 1
            x = randi(xmax);
            y = randi(ymax);
            if x+template_dim-1 <= xmax && y+template_dim-1 <= ymax
                % Conservative selection
                upperleft = [rects(1,1)-128,rects(1,2)-128];
                lowerright = [rects(1,1)+rects(1,3)+128,rects(1,2)+rects(1,4)+128];
                
                if (x >= upperleft(1) && x <= lowerright(1)) && ...
                   (y >= upperleft(2) && y <= lowerright(2))
                   continue;
                end
                break;
            end
        end
        template_images_neg{(i-1)*num_neg/length(Itrain)+j} = ...
          Itrain{i}(y:y+template_dim-1,x:x+template_dim-1);
    end
end

%% Save template_images_pos/neg
save('template_images_pos.mat','template_images_pos');
save('template_images_neg.mat','template_images_neg');

end


function patch = resizePatch(I, rect, template_dim)
x = rect(1);
y = rect(2);
w = rect(3);
h = rect(4);
xmax = size(I, 2);
ymax = size(I, 1);

diff = floor(abs(w - h)/2);
if w > h
    patch = zeros(w,w);
    patch(diff+1:diff+h, :) = I(y+1:y+h, x:x+w-1);
    
    % Fill in upper portion
    if y - diff >= 0
        patchUpRange = 1:diff;
        ImageUpRange = y-diff+1:y;
    else
        patchUpRange = diff-y+1:diff;
        ImageUpRange = 1:y;
    end
    patch(patchUpRange, :) = I(ImageUpRange, x:x+w-1);
    
    % Fill in lower portion
    y = y+h;
    newDiff = w - (diff+h);
    if y + newDiff <= ymax
        patchLowerRange = diff+h+1:diff+h+newDiff;
        ImageLowerRange = y+1:y+newDiff;
    else
        patchLowerRange = diff+h+1:diff+h+ymax-y;
        ImageLowerRange = y+1:ymax;
    end
    patch(patchLowerRange, :) = I(ImageLowerRange, x:x+w-1);
    
else
    patch = zeros(h,h);
    patch(:, diff+1:diff+w) = I(y:y+h-1, x+1:x+w);
    
    % Fill in left portion
    if x - diff >= 0
        patchLeftRange = 1:diff;
        ImageLeftRange = x-diff+1:x;
    else
        patchLeftRange = diff-x+1:diff;
        ImageLeftRange = 1:x;
    end
    patch(:, patchLeftRange) = I(y:y+h-1, ImageLeftRange);
    
    % Fill in right portion
    x = x+w;
    newDiff = h - (diff+w);
    if x + newDiff <= xmax
        patchRightRange = diff+w+1:diff+w+newDiff;
        ImageRightRange = x+1:x+newDiff;
    else
        patchRightRange = diff+w+1:diff+w+xmax-x;
        ImageRightRange = x+1:xmax;
    end
    patch(:, patchRightRange) = I(y:y+h-1, ImageRightRange);
end

patch = imresize(patch, [template_dim template_dim]);
end
