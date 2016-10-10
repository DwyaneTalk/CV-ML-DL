function [im_curvity, im_corner] = kassCurvityDetection(varargin)
    type = varargin{1};
    im_in = varargin{2};
    [row, col] = size(im_in);
    im_curvity = zeros(row, col);
    fx = [-2 -1 0 1 2]; %ˮƽ����ģ��
    fy = [-2;-1;0;1;2]; %��ֱ����ģ��
    Mx = filter2(fx, im_in);    %ˮƽ�ݶ�
    My = filter2(fy, im_in);    %��ֱ�ݶ�
    Mxx= filter2(fx, Mx);
    Mxy= filter2(fy, Mx);
    Myx= filter2(fx, My);
    Myy= filter2(fy, My);
    
    for x = 1 : row;
        for y = 1 : col
            Mx2 = Mx(x, y) * Mx(x, y);
            My2 = My(x, y) * My(x, y);
            if (Mx2 + My2) ~= 0
                MxMy= Mx(x, y) * My(x, y);
                switch(type)
                    case 'D1'   %���߷���
                        im_curvity(x, y) = ( My2 * Mxx(x, y) - MxMy * Myx(x, y) + Mx2 * Myy(x, y) - MxMy * Mxy(x, y)) / ((Mx2 + My2) ^ 1.5);
                    case 'D2'   %���߷���
                        im_curvity(x, y) = ( My2 * Mxx(x, y) - MxMy * Myx(x, y) - Mx2 * Myy(x, y) + MxMy * Mxy(x, y)) / ((Mx2 + My2) ^ 1.5);
                    case 'D3'   %���߷���
                        im_curvity(x, y) = ( Mx2 * Myx(x, y) - MxMy * Mxx(x, y) + My2 * Mxy(x, y) - MxMy * Myy(x, y)) / ((Mx2 + My2) ^ 1.5);
                   case 'D4'    %���߷���
                        im_curvity(x, y) = (-Mx2 * Myx(x, y) + MxMy * Mxy(x, y) + My2 * Mxy(x, y) - MxMy * Myy(x, y)) / ((Mx2 + My2) ^ 1.5);
                end    
            end
        end
    end  
    if nargin < 3
        im_corner = nonMaxCurvity(im_curvity);    %�Ǽ���ֵ���ƺ���ֵ����
    else
        im_corner = nonMaxCurvity(im_curvity, varargin{3});    %�Ǽ���ֵ���ƺ���ֵ����
    end
    max_value = max(im_curvity(:));
    im_curvity = uint8(im_curvity * 255 / max_value);
end