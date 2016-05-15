%% Student Name: Anbang Hu
%% Andrew ID:    anbangh

function mask = SubtractDominantMotion(image1, image2)
%% function SubtractDominantMotion(image1, image2) computes the mask
%  between two frames
%  Input:
%   image1 - previous frame
%   image2 - current frame
%  Output:
%   mask - the mask that contains info about moving objects computed from
%          image1 and image2

M           = LucasKanadeAffine(image1, image2);
tform       = affine2d(M');
I           = imwarp(image2, tform, 'FillValues', 0,...
                    'OutputView', imref2d(size(image2)));
imgMask     = imwarp(ones(size(image2)), tform, 'FillValues', 0,...
                    'OutputView', imref2d(size(image2)));

% I have no idea why the following wouldn't work perfectly. I have been
% trying literally all combinations, none of which gets rid of all nasty
% noises.
SE          = strel('disk', 8, 0);
mask        = (abs(I - image1) > 0.11) .* imgMask;
mask        = bwmorph(mask, 'close');
mask        = bwmorph(mask, 'majority');
mask        = imdilate(mask, SE);
mask        = imerode(mask, SE);
mask        = bwmorph(mask, 'bridge');
mask        = bwmorph(mask, 'clean');
mask        = mask - bwareaopen(mask, 400);

% Extra tweaking step to get rid of boundary noise
mask(:,[1:2 end-1:end]) = 0;

end
