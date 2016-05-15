%% Student Name: Anbang Hu
%% Andrew ID:    anbangh

%% Implemented according to Inverse Compositional Algorithm and the template drifting correction in paper:
%% Src URL: https://www.ri.cmu.edu/pub_files/pub4/matthews_iain_2003_2/matthews_iain_2003_2.pdf

function [u, v, u_, v_] = LucasKanadeWithTemplateCorrection(It, It1, rect, I1, rect1, u, v, u_, v_)
%% function LucasKanadeWithTemplateCorrection(It, It1, rect, I1, rect1, u, v, u_, v_) computes the shifting
%  Input:
%   It - previous frame
%   It1 - current frame
%   rect - 4 x 1 rectangle info
%   I1 - frame 1
%   rect1 - 4 x 1 rectangle info in frame 1
%   u, v - corresponds to p
%   u_, v_ - corresponds to p*
%  Output:
%   u, v - new p
%   u_, v_ - new p*


%% Initialization
threshold = 0.001;
DelP = Inf(2,1);
maxIters = 100;

%% Compute template
if norm([u; v] - [u_; v_]) <= threshold
    T = It(rect(2):rect(4), rect(1):rect(3));
else
    T = I1(rect1(2):rect1(4), rect1(1):rect1(3));
end

%% Compute gradient of template
[gradTX, gradTY] = gradient(T);

%% Jacobian is identity, no need to compute

%% compute steepest descent images
gradTWarp = [gradTX(:) gradTY(:)];

%% compute Hessian
H = gradTWarp' * gradTWarp;

cnt = 0;
%% Iterate till convergence
while (norm(DelP) > threshold)
    % Increment counter
    cnt = cnt + 1;
    
    % Compute warped image patch
    [IX, IY] = meshgrid(rect(1)+u:rect(3)+u, rect(2)+v:rect(4)+v);
    I = interp2(It1, IX, IY);

    % Compute delta p
    DelP = H \ gradTWarp' * (T(:) - I(:)); % There seems to be a typo in the paper

    % Ipdate parameters
    u = u + DelP(1);
    v = v + DelP(2);
    
    % Break loop if exceeding max allowed iters
    if cnt > maxIters
        break;
    end
end

%% Initialization
u_ = u; v_ = v;
DelP = Inf(2, 1);
T = It(rect(2):rect(4), rect(1):rect(3));

%% Compute gradient of template
[gradTX, gradTY] = gradient(T);

%% Jacobian is identity, no need to compute

%% Compute steepest descent images
gradTWarp = [gradTX(:) gradTY(:)];

%% compute Hessian
H = gradTWarp' * gradTWarp;

cnt = 0;
%% Iterate till convergence
while (norm(DelP) > threshold)
    % Increment counter
    cnt = cnt + 1;
    
    % Compute warped image patch
    [IX, IY] = meshgrid(rect(1)+u_:rect(3)+u_, rect(2)+v_:rect(4)+v_);
    I = interp2(It1, IX, IY);

    % Compute the error
    DelP = H \ gradTWarp' * (T(:) - I(:));

    % Update parameters
    u_ = u_ + DelP(1);
    v_ = v_ + DelP(2);
    
    % Break loop if exceeding the max allowed iters
    if cnt > maxIters
        break;
    end
end

end
    
