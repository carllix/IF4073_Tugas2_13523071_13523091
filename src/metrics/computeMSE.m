function mse = computeMSE(img, refImg)
% mean squared error over all pixels and channels
    arguments
        img {mustBeNumeric}
        refImg {mustBeNumeric}
    end

    if ~isequal(size(img), size(refImg))
        error("computeMSE:sizeMismatch", "Image and reference must have the same size.");
    end

    diff = double(img) - double(refImg);
    mse = mean(diff(:).^2);

end
