function [im_out] = imConvole(im_in, template)
    [row, col] = size(im_in);
    im_out = uint8(zeros(row, col));
    [trow, tcol] = size(template);
    pad_x = floor(trow / 2);
    pad_y = floor(tcol / 2);
    for x = pad_x + 1 : row - pad_x
        for y = pad_y + 1 : col - pad_y
            im_out(x, y) = sum(sum(double(im_in(x - pad_x : x + pad_x, y - pad_y : y + pad_y)) .* template));
        end
    end
end