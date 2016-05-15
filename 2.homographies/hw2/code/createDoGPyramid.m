function [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels)
%% function [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels)
%  Produces DoG pyramids and DoG levels
%  Input:
%    GaussianPyramid - A matrix of grayscale images of size R * C * L
%    levels - the levels of the pyramid where the blur at each level is
%  Output:
%    DoGPyramid - R * C * (L-1) matrix
%    DoGLevels - L-1 vector containing the last L elements of levels

L = length(levels);
DoGPyramid = zeros([size(GaussianPyramid, 1), size(GaussianPyramid, 2), L-1]);
for i = 2:L
    DoGPyramid(:,:,i-1) = GaussianPyramid(:,:,i) - GaussianPyramid(:,:,i-1);
end
DoGLevels = levels(2:end);

end