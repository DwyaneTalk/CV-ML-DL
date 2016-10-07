function [im_out, hist_out] = histOperation(varargin)
    if(nargin == 1)
        [im_out, hist_out] = hishEqua(varargin{1});
    else
        [im_out, hist_out] = histNorm(varargin{1}, varargin{2}, varargin{3});
    end
end

%   直方图正规化
function [im_out, hist_out] = histNorm(im_in, new_min, new_max)
    old_min = double(min(min(im_in)));
    old_max = double(max(max(im_in)));
    [row, col] = size(im_in);
    im_out = uint8(zeros(row, col));
    for x = 1 : row
        for y = 1 : col
            im_out(x, y) = (new_max - new_min) * (double(im_in(x, y)) - old_min) / (old_max - old_min) + new_min;
        end
    end
    hist_out = imHist(im_out);
end

%   直方图均衡化
function [im_out, hist_out] = hishEqua(im_in)
    [row, col] = size(im_in);
    im_out = uint8(zeros(row, col));
    lookup = uint8(zeros(256,1));
    hist = imHist(im_in);
    sum = 0;
    range = 255 + 1;
    total_num = row * col;
    
    for level = 1 : 256
        sum = sum + hist(level);
        lookup(level) = uint8(range * sum / total_num);
    end
    
    for x = 1 : row
        for y = 1 :col
            im_out(x, y) = lookup(im_in(x, y) + 1);
        end
    end
    hist_out = imHist(im_out);
end