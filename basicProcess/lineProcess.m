function [im_out] = lineProcess(im_in, k, b)
    [row, col] = size(im_in);
    im_out = uint8(zeros(row, col));
    for x = 1 : row
        for y  = 1 : col
            pix_value = im_in(x,y) * k + b;
            im_out(x, y) = clip(pix_value, 0, 255);
        end
    end
end