function spec = computeSpectra(img)
% log spectrum per channel in [0,1]
    arguments
        img {mustBeNumeric}
    end

    spec = zeros(size(img));
    for k = 1:size(img, 3)
        spec(:, :, k) = logMagnitude(centeredSpectrum(img(:, :, k)));
    end

end
