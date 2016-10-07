function [im_out] = edgeDetection(varargin)
    type = varargin{1};
    im_in = varargin{2};
    switch(type)
        case 'SOBEL'
            im_out = sobelDetection(im_in, varargin{3 : nargin});
        case 'CANNY'
            im_out = cannyDetection(im_in, varargin{3 : nargin});
        case 'LOG'
            im_out = logDetection(im_in, varargin{3 : nargin});
        case 'MH'
            im_out = mhDetection(im_in, varargin{3 : nargin});
    end
end

function [im_out] = sobelDetection(varargin)
    if(isa(varargin{1}, 'double') == 0)
        im_in = double(varargin{1});
    else
        im_in = varargin{1};
    end
    if(nargin == 1) 
        im_gauss =  imfilter(im_in, fspecial('gaussian'), 'replicate');
    else if(nargin == 2)
            im_gauss =  imfilter(im_in, fspecial('gaussian', varargin{2}), 'replicate');
        else
            im_gauss =  imfilter(im_in, fspecial('gaussian', varargin{2}, varargin{3}), 'replicate');
        end
    end
    tmp_sobel = fspecial('sobel');
    edge_x = imfilter(im_gauss, tmp_sobel, 'replicate');
    edge_y = imfilter(im_gauss, tmp_sobel', 'replicate');
    edge = sqrt(edge_x .^2 + edge_y .^ 2);
    max_value = max(edge(:));
    im_out = uint8(edge * 255 / max_value);
end

function [im_out] = cannyDetection(varargin)
    if(isa(varargin{1}, 'double') == 0)
        im_in = double(varargin{1});
    else
        im_in = varargin{1};
    end
    if(nargin == 3)
        im_gauss = imfilter(im_in, fspecial('gaussian'), 'replicate');
    else if(nargin == 4)
            im_gauss = imfilter(im_in, fspecial('gaussian', varargin{4}), 'replicate');
        else
            im_gauss = imfilter(im_in, fspecial('gaussian', varargin{4}, varargin{5}), 'replicate');
        end
    end
    tmp_sobel = fspecial('sobel');
    edge_x = imfilter(im_gauss, tmp_sobel, 'replicate');
    edge_y = imfilter(im_gauss, tmp_sobel', 'replicate');
    edge = sqrt(edge_x .^ 2 + edge_y .^ 2);
    im_nonmax = removeNonMax(edge, edge_x, edge_y);
    im_out = doubleThreshold(im_nonmax, varargin{nargin - 1}, varargin{nargin});
end

function [im_out] = logDetection(varargin)
    if(isa(varargin{1}, 'double') == 0)
        im_in = double(varargin{1});
    else
        im_in = varargin{1};
    end
    if(nargin == 1) 
        im_gauss =  imfilter(im_in, fspecial('gaussian'), 'replicate');
    else if(nargin == 2)
            im_gauss =  imfilter(im_in, fspecial('gaussian', varargin{2}), 'replicate');
        else
            im_gauss =  imfilter(im_in, fspecial('gaussian', varargin{2}, varargin{3}), 'replicate');
        end
    end
    
    tmp_log = [ 0, -1,  0;
               -1,  4, -1;
                0, -1,  0];
    edge = abs(imfilter(im_gauss, tmp_log, 'replicate'));
    max_value = max(edge(:));
    im_out = uint8(edge * 255 / max_value);
end

function [im_out] = mhDetection(varargin)
    if(isa(varargin{1}, 'double') == 0)
        im_in = double(varargin{1});
    else
        im_in = varargin{1};
    end
    win_size = varargin{2};
    sigma = varargin{3};
    mid = floor(win_size / 2 + 1);
    tmp_mh = zeros(win_size, win_size);
    for i = 1 : win_size
        for j = 1 : win_size
            x = i - mid;
            y = j - mid;
            x2y2 = x * x + y * y;
            sigma2 = sigma * sigma;
            tmp_mh(i,j)= ((x2y2 - 2 * sigma2) * exp(-x2y2/(2 * sigma2))) / (sigma2 * sigma2); 
        end
    end
    edge = imfilter(im_in, tmp_mh, 'replicate');
    max_value = max(edge(:));
    im_out = uint8(edge * 255 / max_value);
end


