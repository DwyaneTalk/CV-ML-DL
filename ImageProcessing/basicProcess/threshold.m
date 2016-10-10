function [im_out] = threshold(varargin)
    if(nargin == 2)
        im_out = thresholdConst(varargin{1}, varargin{2});
    else
        im_out = thresholdOtsu(varargin{1});
    end
end

function [im_out] = thresholdConst(im_in, value)
    im_out = uint8(zeros(size(im_in)));
    im_out(im_in > value) = 255;
end

%   Otsu方法进行阈值化处理
function [im_out] = thresholdOtsu(im_in)
    hist = imHist(im_in);
    pix_num = numel(im_in);
    hist_rate = double(hist) ./ pix_num;
    w = zeros(256,1);
    u = zeros(256,1);
    level_min = find(hist_rate ~= 0, 1, 'first');
    level_max = find(hist_rate ~= 0, 1, 'last' );
    w(level_min) = hist_rate(level_min);
    u(level_min) = hist_rate(level_min) * level_min;
    for level = level_min + 1 : level_max
        w(level) = w(level - 1) + hist_rate(level);
        u(level) = u(level - 1) + hist_rate(level) * level;
    end
    uT = u(level_max);
    tmp_value = (uT * w(level_min) - u(level_min))^2 / (w(level_min) * (1 - w(level_min)));
    threshold = 1;
    for level = level_min + 1 : level_max
        new_value = (uT * w(level) - u(level))^2 / (w(level) * (1 - w(level)));
        if new_value > tmp_value
            tmp_value = new_value;
            threshold = level;
        end
    end
    im_out = thresholdConst(im_in, threshold);
end