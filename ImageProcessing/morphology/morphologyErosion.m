function im_out = morphologyErosion(varargin)
    im_in = varargin{1};
    im_type = varargin{2};
    switch(im_type)
        case 'IM_BINA'  
            im_out = binaryErosion(im_in, varargin{3});
        case 'IM_GRAY'  
            im_out = grayErosion(im_in, varargin{3});
    end
end

% ¸¯Ê´
function [im_out] = binaryErosion(im_in, template)
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
                im_out(irow, icol) = 0;
            else
                im_out(irow, icol) = 255;
            end
        end
    end
end

% »Ò¶ÈÍ¼Ïñ¸¯Ê´
function [im_out] = grayErosion(im_in, template)
    [row, col] = size(im_in);
    [trow, tcol] = size(template);
    rhal = floor(trow / 2);
    chal = floor(tcol / 2);
    im_out = im_in;
    for irow = rhal + 1 : row - rhal
        for icol = chal + 1 : col - chal
            min = 255;
            for ix = -rhal : rhal
                for iy = -chal : chal
                    diff = im_in(irow + ix, icol + iy) - template(ix + rhal + 1, iy + chal + 1) + 1;
                    if(diff < min)
                        min = diff;
                    end
                end
            end
            min = clip(min, 0, 255);
            im_out(irow, icol) = min;
        end
    end
end