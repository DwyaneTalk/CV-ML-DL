function [out] = clip(in, low, high)
    if in < low
        out = low;
    else if in > high
            out = high;
        else
            out = in;
        end
    end
end