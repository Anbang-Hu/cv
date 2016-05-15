%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

function [x,y,score] = detect(I,template,ndet)
%
% return top ndet detections found by applying template to the given image.
%   x,y should contain the coordinates of the detections in the image
%   score should contain the scores of the detections
%

%% Convert to gray scale image if necessary
if numel(size(I)) == 3
    I = rgb2gray(I);
end

%% Convert to double image
I = im2double(I);

%% Compute hog feature
F = hog(I);

%% Compute heat map
H = zeros(size(F));
for i = 1:size(H,3)
    H(:,:,i) = imfilter(F(:,:,i), template(:,:,i),'replicate');
end

H = sum(H, 3);

% figure, imagesc(H);

%% Sort the responses in descending order
[~, index] = sort(H(:), 'descend');
[locy, locx] = ind2sub(size(H), index);

%% Search for high scores
templateHeight = size(template, 1);
templateWidth  = size(template, 2);
x              = zeros(ndet, 1);
y              = zeros(ndet, 1);
score          = zeros(ndet, 1);
cnt            = 0;

for i = 1:size(index,1)
    if localMax(locx(i), locy(i), H) == 1
        NMScondition = 1;
        for k = 1:cnt
            if abs(locx(i)-x(k)) <= templateWidth && ...
               abs(locy(i)-y(k)) <= templateHeight
                NMScondition = 0;
                break;
            end
        end
        
        if NMScondition == 1
            cnt = cnt + 1;
            x(cnt) = locx(i);
            y(cnt) = locy(i);
            score(cnt) = H(locy(i), locx(i));
        end
    end
    
    if cnt == ndet
        break;
    end
end

x = 8*x - 4;
y = 8*y - 4;

end

%% Auxiliary function to check local max
function b = localMax(i, j, H)

%% Pad H
paddedH = zeros(size(H,1)+2, size(H,2)+2);
paddedH(2:1+size(H,1), 2:1+size(H,2)) = H;

%% Change to new coordinate system
newI = i+1;
newJ = j+1;

%% Test for maximum
if paddedH(newJ, newI) > paddedH(newJ-1, newI-1) && ...
   paddedH(newJ, newI) > paddedH(newJ-1, newI  ) && ...
   paddedH(newJ, newI) > paddedH(newJ-1, newI+1) && ...
   paddedH(newJ, newI) > paddedH(newJ  , newI-1) && ...
   paddedH(newJ, newI) > paddedH(newJ  , newI+1) && ...
   paddedH(newJ, newI) > paddedH(newJ+1, newI-1) && ...
   paddedH(newJ, newI) > paddedH(newJ+1, newI  ) && ...
   paddedH(newJ, newI) > paddedH(newJ+1, newI+1)
    b = 1;
else
    b = 0;
end
end