function [im_usan, im_corner] = susanCuivityDetection(varargin)
    im_in = varargin{1};
    th_t = varargin{2};
    if nargin > 2
        th_g = varargin{3};
    else
        th_g = 0.5;
    end
    [row, col] = size(im_in);
    im_usan = zeros(row, col);
    w_size = 3;
    n_max = 37;
    th_g = (n_max - 1) * th_g; %角点提取
    
    for x = 1 + w_size : row - w_size;
        for y = 1 + w_size : col - w_size
            count = 0;
            for i = -w_size : w_size    %对应7x7=49的窗口
                for j = -w_size : w_size
                    if i ^2 + j ^2 <= 10 && ~( i==0 && j==0)    %限制在37的窗口
                        if abs(im_in(x,y) - im_in(x+i, y+j)) <= th_t
                            count = count + 1;
                        end
                    end
                end
            end
            if count >=  th_g
                im_usan(x,y) = 0;
            else
                im_usan(x,y) = th_g - count;
            end
        end
    end
    if nargin > 3
        im_corner = nonMaxCurvity(im_usan, varargin{4});
    else
        im_corner = nonMaxCurvity(im_usan);
    end
    max_value = max(im_usan(:));
    im_usan = uint8(im_usan * 20055 / max_value);
end