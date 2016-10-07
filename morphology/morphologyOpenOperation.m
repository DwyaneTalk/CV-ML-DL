function im_out = morphologyOpenOperation(varargin)
    im_in = varargin{1};
    im_type = varargin{2};
    switch(im_type)
        case 'IM_BINA'  
            im_out = binaruOpenOperation(im_in, varargin{3}, varargin{4});
        case 'IM_GRAY'  
            im_out = grayOpenOperation(im_in, varargin{3}, varargin{4});
    end
end

% 开算子
function im_out = binaruOpenOperation(im_in, template1, template2)
    if(find(im_in(im_in > 0) < 255))
        disp('错误！，非二值图像');
    end
    im_erision = morphologyErosion(im_in, 'IM_BINA', template1);
    im_out = morphologyDilation(im_erision, 'IM_BINA', template2);
end

%灰度开算子
function [im_out] = grayOpenOperation(im_in, template1, template2)
    im_out = morphologyDilation(morphologyErosion(im_in, 'IM_GRAY', template1), 'IM_GRAY', template2);
end
