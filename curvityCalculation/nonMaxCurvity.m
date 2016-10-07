function [im_corner] = nonMaxCurvity(varargin)
    im_in = varargin{1};
    if(nargin < 2)
        rate = 0;
    else
        rate = varargin{2};
    end
    [row, col] = size(im_in);
    im_corner = zeros(row, col);
    max_value = max(im_in(:));
    th_value = max_value * rate;
    list = [ 1,  1,  1,  0, -1, -1, -1,  0;
             1,  0, -1, -1, -1,  0,  1,  1];
    
    for i = 2 :row-1
        for j = 2 :col-1
            if im_in(i,j) < th_value
                im_corner(i,j) = 0;
            else
                im_corner(i,j) = 1;
                for l = 1 : 8;
                    x = i + list(1,l);
                    y = j + list(2,l);
                    if im_in(i,j) <= im_in(x,y)
                        im_corner(i, j) = 0;
                        break;
                    end
                end
            end
        end
    end
end