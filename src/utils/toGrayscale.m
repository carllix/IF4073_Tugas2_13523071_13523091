function grayImg = toGrayscale(rgbImg)
% convert RGB to grayscale
    arguments
        rgbImg {mustBeNumeric}
    end

    if size(rgbImg, 3) == 1
        grayImg = rgbImg;
        return;
    end

    R = double(rgbImg(:,:,1));
    G = double(rgbImg(:,:,2));
    B = double(rgbImg(:,:,3));

    grayImg = uint8(0.299*R + 0.587*G + 0.114*B);

end
