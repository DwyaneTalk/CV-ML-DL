function [hist] = imHist(im_gray)
    hist = zeros(256,1);
    [row, col] = size(im_gray);
    for x = 1 : row
        for y = 1 :col
            hist(im_gray(x, y) + 1) = hist(im_gray(x, y) + 1) + 1;
        end
    end
end