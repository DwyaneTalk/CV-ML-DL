function im_out = morphologyDilation(varargin)
    im_in = varargin{1};
    im_type = varargin{2};
     switch(im_type)
        case 'IM_BINA'  
            im_out = binaryDilation(im_in, varargin{3});
        case 'IM_GRAY'  
            im_out = grayDilation(im_in, varargin{3});
     end
end

% ÅòÕÍ
function [im_out] = binaryDilation(im_in,template)
    if(find(im_in(im_in > 0) < 255))
        disp('´íÎó£¡·Ç¶þÖµÍ¼Ïñ');
    end
    [row, col] = size(im_in);
    [trow, tcol] = size(template);
    template = uint8(template);
    rhal = floor(trow / 2);
    chal = floor(tcol / 2);
    im_out = im_in;
    for irow = 1 + rhal : row - rhal
        for icol = 1 + chal : col - chal
            im_diff = im_in(irow - rhal : irow + rhal, icol - chal : icol + chal) ~= template;
            if(any(im_diff(:)))
                im_out(irow, icol) = 255;
            else
                im_out(irow, icol) = 0;
            end
        end
    end
end

% »Ò¶ÈÍ¼ÏñÅòÕÍ
function [im_out] = grayDilation(im_in, template)
    [row, col] = size(im_in);
    [trow, tcol] = size(template);
    rhal = floor(trow / 2);
    chal = floor(tcol / 2);
    im_out = im_in;
    for irow = 1 + rhal : row - rhal
        for icol = 1 + chal : col - chal
            max = 0;
            for ix = -rhal : rhal
                for iy = -chal : chal
                    diff = im_in(irow + ix, icol + iy) + template(ix + rhal + 1, iy + chal + 1) - 1;
                    if(diff > max)
                        max = diff;
                    end
                end
            end
            max = clip(max, 0, 255);
            im_out(irow, icol) = max;
        end
    end
end