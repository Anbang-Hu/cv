function PrincipalCurvature = computePrincipalCurvature(DoGPyramid)
%% function PrincipalCurvature = computePrincipalCurvature(DoGPyramid)
%  Produces PrincipalCurvature
%  Input:
%    DoGPyramid - R * C * (L-1) matrix
%  Output:
%    PrincipalCurvature - R * C * (L-1) matrix where each point contains
%                         curvature ratio

% PrincipalCurvature = zeros(size(DoGPyramid));
% L = size(DoGPyramid, 3);
% for i = 1:L
%     [dx, dy]        = gradient(DoGPyramid(:,:,i));
%     [dxdx, dxdy]    = gradient(dx);
%     [dydx, dydy]    = gradient(dy);
%     trace           = (dxdx + dydy).^2;
%     determinant     =  dxdx.* dydy - dxdy.* dydx;
%     PrincipalCurvature(:,:,i) =  trace ./ determinant;
% end

[dx, dy]        = gradient(DoGPyramid);
[dxdx, dxdy]    = gradient(dx);
[dydx, dydy]    = gradient(dy);
trace           = (dxdx + dydy).^2;
determinant     =  dxdx.* dydy - dxdy.* dydx;
PrincipalCurvature =  trace ./ determinant;

end