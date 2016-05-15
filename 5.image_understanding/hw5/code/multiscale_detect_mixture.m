%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

function det_res = multiscale_detect_mixture(image, template, ndet)
% input:
%     image - test image.
%     template - [16 x 16x 9] matrix.
%     ndet - the number of return values.
% output:
%      det_res - [ndet x 3] matrix
%                column one is the x coordinate
%                column two is the y coordinate
%                column three is the scale, i.e. 1, 0.7 or 0.49 ..

%% Convert to gray image if necessary
if numel(size(image)) == 3
    image = rgb2gray(image);
end

%% Convert to double image
image = im2double(image);

%% Find detections
templateWidth = size(template{1}, 2);
templateHeight = size(template{1}, 1);
s = 1;
x = []; 
y = []; 
score = [];
scale = [];
while 8*templateHeight < s*size(image,1) && 8*templateWidth < s*size(image,2)
    Itest = imresize(image, s);
    
    for i = 1:length(template)
        [curr_x,curr_y,curr_score] = detect(Itest,template{i},ndet);
        x = [x; round(curr_x/s)];
        y = [y; round(curr_y/s)];
        curr_score = curr_score / sum(curr_score(:));
%         curr_score = curr_score ./ (max(curr_score)-1);
        score = [score; curr_score];
        scale = [scale; s*ones(ndet, 1)];
    end
    
    s = s * 0.7;
end
s = 1/0.7;
while s <= 6
    Itest = imresize(image, s);
    
    for i = 1:length(template)
        [curr_x,curr_y,curr_score] = detect(Itest,template{i},ndet);
        x = [x; round(curr_x/s)];
        y = [y; round(curr_y/s)];
        curr_score = curr_score / sum(curr_score(:));
%         curr_score = curr_score ./ (max(curr_score)-1);
        score = [score; curr_score];
        scale = [scale; s*ones(ndet, 1)];
    end
    
    s = s / 0.7;
end

%% Non-Max Suppression
ret_x = zeros(ndet,1);
ret_y = zeros(ndet,1);
ret_scale = zeros(ndet,1);
[~, I] = sort(score, 'descend');
x = x(I);
y = y(I);
score = score(I);
scale = scale(I);
templateWidth = size(template{1}, 2);
templateHeight = size(template{1}, 1);

cnt = 0;
for i = 1:size(I,1)
    NMScondition = 1;
    for k = 1:cnt
        if abs(x(i)-ret_x(k)) <= 8*0.5*templateWidth*(1/scale(i)+1/ret_scale(k)) && ...
           abs(y(i)-ret_y(k)) <= 8*0.5*templateHeight*(1/scale(i)+1/ret_scale(k))
            NMScondition = 0;
            break;
        end
    end

    if NMScondition == 1
        cnt = cnt + 1;
        ret_x(cnt) = x(i);
        ret_y(cnt) = y(i);
        ret_scale(cnt) = scale(i);
    end
    
    if cnt == ndet
        break;
    end
end

det_res = [ret_x ret_y ret_scale];

end
