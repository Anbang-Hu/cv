function [ warp_im ] = warpA( im, A, out_size )
% warp_im=warpAbilinear(im, A, out_size)
% Warps (w,h,1) image im using affine (3,3) matrix A 
% producing (out_size(1),out_size(2)) output image warp_im
% with warped  = A*input, warped spanning 1..out_size
% Uses nearest neighbor mapping.
% INPUTS:
%   im : input image
%   A : transformation matrix 
%   out_size : size the output image should be
% OUTPUTS:
%   warp_im : result of warping im by A
% [src_h, src_w] = size(im);
B = inv(A);
[X,Y,Z] = meshgrid(1:out_size(2), 1:out_size(1), 1);
src_X = round(B(1,1)*X + B(1,2)*Y + B(1,3)*Z);
src_Y = round(B(2,1)*X + B(2,2)*Y + B(2,3)*Z);

warp_im = zeros(out_size(1), out_size(2));
for i = 1:out_size(1)
    for j = 1:out_size(2)
        if src_X(i,j)<1 || src_X(i,j)>out_size(2) || src_Y(i,j)<1 || src_Y(i,j)>out_size(1)
            continue;
        end
        warp_im(i,j) = im(src_Y(i,j),src_X(i,j));
    end
end

