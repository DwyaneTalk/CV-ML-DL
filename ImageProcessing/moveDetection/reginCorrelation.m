function [move_x, move_y] = reginCorrelation(varargin)
    im_in1 = varargin{1};
    im_in2 = varargin{2};
    if nargin > 2
        max_move = varargin{3};
        win_size = varargin{4};
    else
        max_move = 3;
        win_size = 3;
    end
    if(size(im_in1) ~= size(im_in2))
        disp('两幅图像尺寸不一样');
        return;
    end
    [row, col] = size(im_in1);
    move_x = int8(zeros(row, col));
    move_y = int8(zeros(row, col));
    for irow1 = 1 + max_move + win_size : row - max_move - win_size;
        for icol1 = 1 + max_move + win_size : col - max_move - win_size
            min_sum = 9999999;
            distance = 0;
            dx = 0; dy = 0;
            for irow2 = irow1 - max_move : irow1 + max_move
                for icol2 = icol1 - max_move : icol1 + max_move
                    diff = im_in1(irow1 - win_size : irow1 + win_size, icol1 - win_size : icol1 + win_size) ...,
                        - im_in2(irow2 - win_size : irow2 + win_size, icol2 - win_size : icol2 + win_size);
                    correlation = diff .^ 2;
                    sum_corr = sum(correlation(:));
                    new_dx = icol2 - icol1;
                    new_dy = irow2 - irow1;
                    if (sum_corr < min_sum)
                        min_sum = sum_corr;
                        dy = new_dy;
                        dx = new_dx;
                        distance = dx * dx + dy * dy;
                    else if(sum_corr == min_sum && (new_dy * new_dy + new_dx * new_dx) < distance)
                        dy = new_dy;
                        dx = new_dx;
                        distance = dx * dx + dy * dy;
                        end 
                    end
                end
            end
            move_x(irow1, icol1) = dx;
            move_y(irow1, icol1) = -dy;
        end
    end
end