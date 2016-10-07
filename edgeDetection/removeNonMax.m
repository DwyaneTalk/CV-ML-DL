%非极大值抑制
function neg_edge = removeNonMax(edge, edge_x, edge_y)
    [row, col] = size(edge);
    neg_edge = zeros(row, col);
    for x = 2 : row -1
        for y = 2 : col - 1;
            grad_x = edge_x(x, y);
            grad_y = edge_y(x, y);
            grad   = edge(x, y);
            if grad == 0                    % 梯度为0不可能是边缘
                continue;
            end
            if abs(grad_x) > abs(grad_y)    %边缘方向为：-45到45
                edge_tan = grad_y / grad_x;
                edge_P2 = edge(x+1, y);
                edge_P4 = edge(x-1, y);
                if edge_tan >= 0      %边缘方向为：0到45
                    edge_P1 = edge(x+1, y+1);
                    edge_P3 = edge(x-1, y-1);
                else                        %边缘方向为：-45到0
                    edge_P1 = edge(x+1, y-1);
                    edge_P3 = edge(x-1, y+1);
                end
                edge_M1 = edge_P1 * abs(edge_tan) + edge_P2 * (1 - abs(edge_tan));
                edge_M2 = edge_P3 * abs(edge_tan) + edge_P4 * (1 - abs(edge_tan));
            else                            %边缘方向为：45到135
                edge_ctn = grad_x / grad_y;
                edge_P2 = edge(x, y+1);
                edge_P4 = edge(x, y-1);
                if edge_ctn > 0      %边缘方向为：45到90
                    edge_P1 = edge(x+1, y+1);
                    edge_P3 = edge(x-1,  y-1);
                else                        %边缘方向为：45到135
                    edge_P1 = edge(x-1, y+1);
                    edge_P3 = edge(x+1, y-1);
                end
                edge_M1 = edge_P1 * abs(edge_ctn) + edge_P2 * (1 - abs(edge_ctn));
                edge_M2 = edge_P3 * abs(edge_ctn) + edge_P4 * (1 - abs(edge_ctn));
            end
            if grad > edge_M1 && grad > edge_M2
                neg_edge(x, y) = grad;
            end
        end 
    end
end
