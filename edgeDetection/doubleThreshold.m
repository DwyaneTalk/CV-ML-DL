%数组模拟递归实现阈值处理
function im_edge = doubleThreshold(edge, th_max, th_min)
    [row, col] = size(edge);
    MAXSIZE = row * col;
    list = [ 1,  1,  1,  0, -1, -1, -1,  0;
             1,  0, -1, -1, -1,  0,  1,  1];

    seed = find(edge > th_max);
    num = numel(seed);
    im_edge = zeros(row, col);
    im_edge(seed) = 255;
    
    seed_x = zeros(MAXSIZE, 1);
    seed_y = zeros(MAXSIZE, 1);
    seed_x(1 : num, 1) = uint8((seed - 1) / col + 1);
    seed_y(1 : num, 1) = uint8(mod((seed - 1), col) + 1);
    
    front = 1;
    rear = num + 1;
    while front ~= rear
        pos_x = seed_x(front);
        pos_y = seed_y(front);
        front = front + 1;
        for i = 1 : 8
            pos_xi = pos_x + list(1, i);
            pos_yi = pos_y + list(2, i);
            if pos_xi >0 && pos_yi >0 && pos_xi <= row && pos_yi <= col && edge(pos_xi, pos_yi) > th_min && im_edge(pos_xi, pos_yi)  ~= 255
                im_edge(pos_xi, pos_yi) = 255;
                seed_x(rear) = pos_xi;
                seed_y(rear) = pos_yi;
                rear = rear + 1;
            end
        end
    end
end
