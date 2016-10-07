function [im_curvity, im_corner] = harrisCurvityDetection(varargin)
    im_in = varargin{1};
    lambda = varargin{2};
    fx = [-1 0 1;-1 0 1;-1 0 1];    %使用高斯函数的一阶微分模版效果更佳
    fy = [-1 -1 -1;0 0 0;1 1 1];   
    Mx = filter2(fx, im_in);
    My = filter2(fy, im_in);
    Mx2=Mx .* Mx;
    My2=My .* My;
    MxMy = Mx .* My;
    
    H = fspecial('gaussian', [5 5], 2);
    A = filter2(H, Mx2);
    B = filter2(H, My2);
    C = filter2(H, MxMy);

    im_curvity = A .* B - C .* C - lambda * (A + B);
    
    if nargin < 3
        im_corner = nonMaxCurvity(im_curvity);
    else
        im_corner = nonMaxCurvity(im_curvity, varargin{3});
    end

    max_value = max(im_curvity(:))
    im_curvity = uint8(im_curvity * 255 / max_value);
end