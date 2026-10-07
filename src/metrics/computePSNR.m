function psnrValue = computePSNR(img, refImg)
% PSNR in dB for 8-bit images: 10 log10(255^2 / MSE)
    arguments
        img {mustBeNumeric}
        refImg {mustBeNumeric}
    end

    mse = computeMSE(img, refImg);
    if mse == 0
        psnrValue = Inf;
    else
        psnrValue = 10 * log10(255^2 / mse);
    end

end
