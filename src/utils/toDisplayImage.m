function rgb = toDisplayImage(A)
% stretch to 0..255 uint8 RGB for uiimage
    arguments
        A {mustBeNumeric}
    end

    A = double(A);
    lo = min(A(:));
    hi = max(A(:));
    if hi > lo
        A = (A - lo) / (hi - lo);
    else
        A = ones(size(A)) * (lo > 0);
    end

    rgb = uint8(round(A * 255));
    if size(rgb, 3) == 1
        rgb = repmat(rgb, 1, 1, 3);
    end

end
