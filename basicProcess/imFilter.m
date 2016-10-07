function [im_out] = imFilter(varargin)
    switch(varargin{1})
        case 'AVERAGE'
            im_out = averageFilter(varargin{2}, varargin{3});
        case 'GAUSSIAN'
            im_out = gaussianFilter(varargin{2}, varargin{3}, varargin{4});
        case 'MEDIAN'
            im_out = medianFilter(varargin{2}, varargin{3});
        case 'CUT_MEDIAN'
            im_out = cutMedianFilter(varargin{2}, varargin{3});
    end
end
%   均值滤波
function [im_out] = averageFilter(im_in, winSize)
    value = 1 / (winSize * winSize);
    template(1:winSize, 1:winSize) = value;
    im_out = imConvole(im_in, template);
end

%   高斯滤波
function [im_out] = gaussianFilter(im_in, winSize, sigma)
     center = floor(winSize / 2) + 1;
     sum = 0;
     template  = zeros(winSize, winSize);
     for x = 1 : winSize
         for y = 1 : winSize
            template(x, y) = exp(- (((x - center) * (x - center) + (y - center) * (y - center)) / (2 * sigma * sigma)));
            sum = sum + template(x, y);
         end
     end
     template = template / sum;
     im_out = imConvole(im_in, template);
end

%   中值滤波
function [im_out] = medianFilter(im_in, winSize)
    if ~mod(winSize, 2)
        return
    end
    [row, col] = size(im_in);
    pad = floor(winSize / 2);
    im_out = im_in;
    for x = 1 + pad : row - pad
        for y = 1 + pad : col - pad
%   对于3x3的窗口，求中指快速方法：http://www.cnblogs.com/BYTEMAN/archive/2012/07/21/2602181.html  
            im_win = im_in(x - pad : x + pad, y - pad : y + pad);
            im_out(x, y) = median(im_win(:));
        end
    end
end

%   截断中值滤波
function [im_out] = cutMedianFilter(im_in, winSize)
    if ~mod(winSize,2)
        return;
    end
    [row, col] = size(im_in);
    im_out = im_in;
    pad = floor(winSize / 2);
    for x = 1 + pad : row - pad
        for y = 1 + pad : col - pad
            im_win = im_in(x - pad : x + pad, y - pad : y + pad);
            ave = mean(im_win(:));
            med = median(im_win(:));
            if ave > med
                cut_off = 2 * med - min(min(im_win));
            else if ave < med
                cut_off = 2 * med - max(max(im_win));
                end
            end
            count = 0;
            list = zeros(winSize * winSize);
            for i = 1 : winSize
                for j = 1 : winSize
                    if logical(ave > med) && logical(cut_off > im_win(i,j))
                        count = count + 1;
                        list(count) = im_win(i,j);  
                    end
                end
            end
            if count > 0
                im_out(x,y) = median(list(1 : count));
            else
                im_out(x,y) = med;
            end
        end
    end
end


