function [move_x, move_y] = gradIteration(varargin)
    im_in1 = double(varargin{1});
    im_in2 = double(varargin{2});
    if nargin > 2
        lamda  = varargin{3};
        it_num = varargin{4};
    else
        lamda  = 0.01;
        it_num = 50;
    end
    if (size(im_in1) ~= size(im_in2))
        disp('两幅图像尺寸不一样');
        return;
    end
    [row, col] = size(im_in1);
    move_x = int8(zeros(row, col));
    move_y = int8(zeros(row, col));
    
    tx = double(zeros(row, col));
    ty = double(zeros(row, col));
    
    for iter = 1 : it_num
        for irow = 2 : row - 1
            for icol = 2 : col - 1;
                Ex = im_in1(irow, icol + 1) - im_in1(irow, icol) + im_in1(irow + 1, icol + 1) - im_in1(irow + 1, icol) ...,
                    + im_in2(irow, icol + 1) - im_in2(irow, icol) + im_in2(irow + 1, icol + 1) - im_in2(irow + 1, icol) / 4;
                Ey = im_in1(irow + 1, icol) - im_in1(irow, icol) + im_in1(irow + 1, icol + 1) - im_in1(irow, icol + 1) ...,
                    + im_in2(irow + 1, icol) - im_in2(irow, icol) + im_in2(irow + 1, icol + 1) - im_in2(irow, icol + 1) / 4;
                Et = im_in2(irow, icol) - im_in1(irow, icol) + im_in2(irow + 1, icol) - im_in1(irow + 1, icol) + im_in2(irow, icol + 1) ...,
                    - im_in1(irow, icol + 1) + im_in2(irow + 1, icol + 1) - im_in1(irow + 1, icol + 1) / 4;
                Ax = (1 * tx(irow, icol) + tx(irow + 1, icol) + tx(irow - 1, icol) + tx(irow, icol + 1) + tx(irow, icol - 1)) / 4;
                Ay = (1 * ty(irow, icol) + ty(irow + 1, icol) + ty(irow - 1, icol) + ty(irow, icol + 1) + ty(irow, icol - 1)) / 4;
                A = Ex * Ax + Ey * Ay + Et;
                B = 1 + lamda * ( Ex * Ex + Ey * Ey);
                tx(irow, icol) = Ax - Ex * lamda * A / B;
                ty(irow, icol) = Ay - Ey * lamda * A / B;
            end
        end
    end
    for irow = 2 : row - 1;
        for icol = 2 : col - 1;
            move_x(irow, icol) = tx(irow, icol);
            move_y(irow, icol) = -ty(irow, icol);
        end
    end
end