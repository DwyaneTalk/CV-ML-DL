function im_out = morphologyCloseOperation(varargin)
    im_in = varargin{1};
    im_type = varargin{2};
    switch(im_type)
        case 'IM_BINA'  
            im_out = binaryCloseOperation(im_in, varargin{3}, varargin{4});
        case 'IM_GRAY'  
            im_out = grayCloseOperation(im_in, varargin{3}, varargin{4});
    end
end

% 闭算子
function [im_out] = binaryCloseOperation(im_in, template1, template2)
    if(find(im_in(im_in > 0) < 255))
        disp('错误！，非二值图像');
    end
    im_dilation = morphologyDilation(im_in, 'IM_BINA', template1);
    im_out = morphologyErosion(im_dilation, 'IM_BINA', template2);
end

%灰度闭算子
function [im_out] = grayCloseOperation(im_in, template1, template2)
    im_out = morphologyErosion(morphologyDilation(im_in, 'IM_GRAY', template1), 'IM_GRAY', template2);
end






