function [im_curvity, im_corner] = moravecCurvityDetection(varargin)
    im_in = varargin{1};
    [row, col] = size(im_in);
    im_curvity = zeros(row, col);
    fx = [-1 0 1;-1 0 1;-1 0 1];    %使用高斯函数的一阶微分模版效果更佳
    fy = [-1 -1 -1;0 0 0;1 1 1];   
    Mx = filter2(fx, im_in);
    My = filter2(fy, im_in);
    Mx2=Mx .* Mx;
    My2=My .* My;
    MxMy = Mx .* My;
    
    H = fspecial('gaussian', [5 5], 1);
    A = filter2(H, Mx2);
    B = filter2(H, My2);
    C = filter2(H, MxMy);
    
    for x = 1 : row
        for y = 1 : col
            if (Mx2(x, y) + My2(x ,y))~=0
                im_curvity(x, y) = (A(x,y) * My2(x,y) + 2 * C(x,y) * MxMy(x,y) + B(x,y) * Mx2(x,y))/(Mx2(x,y) + My2(x,y));
            end
        end
    end
    
    if nargin < 2
        im_corner = nonMaxCurvity(im_curvity);
    else
        im_corner = nonMaxCurvity(im_curvity, varargin{2});
    end
    max_value = max(im_curvity(:));
    im_curvity = uint8(im_curvity * 255 / max_value);
end