function img = loadImage(filePath)
% read any imread-supported file as uint8 grayscale or RGB
    arguments
        filePath (1,1) string
    end

    [img, map] = imread(filePath);   % multi-frame files: first frame only

    if ~isempty(map)
        img = ind2rgb(img, map);     % indexed -> RGB double in [0,1]
    end

    if size(img, 3) == 4
        error("loadImage:unsupportedChannels", "CMYK images are not supported.");
    end

    img = toUint8(img);

end

function out = toUint8(img)
% rescale any imread output class to uint8
    switch class(img)
        case 'uint8'
            out = img;
        case 'uint16'
            out = uint8(double(img) / 257);             % 65535 / 255 = 257
        case 'int16'
            out = uint8((double(img) + 32768) / 257);   % shift to [0,65535]
        case 'logical'
            out = uint8(img) * 255;
        case {'double', 'single'}
            out = uint8(double(img) * 255);             % float images are in [0,1]
        otherwise
            error("loadImage:unsupportedClass", "Unsupported image class: %s.", class(img));
    end

end
