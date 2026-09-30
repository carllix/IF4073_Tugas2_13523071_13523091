function outImg = applyPerChannel(img, fn)
% apply fn(channel, channelIndex) to every channel and stack the results
    arguments
        img {mustBeNumeric}
        fn (1,1) function_handle
    end

    outImg = zeros(size(img), 'uint8');
    for k = 1:size(img, 3)
        outImg(:, :, k) = fn(img(:, :, k), k);
    end

end
