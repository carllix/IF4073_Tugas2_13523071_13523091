function [outImg, info] = motionBlurImage(img, params)
% F: apply motion blur G = H F per channel; params L, angle, padding
    arguments
        img {mustBeNumeric}
        params (1,1) struct
    end

    padding = "mirror";
    if isfield(params, "padding")
        padding = string(params.padding);
    end

    [M, N, C] = size(img);
    if padding == "none"
        P = M; Q = N;
    else
        P = 2*M; Q = 2*N;
    end
    psf = motionPSF(params.L, params.angle);
    H = psfToTransfer(psf, P, Q);

    g = zeros(M, N, C);
    specIn = zeros(P, Q, C);
    specOut = zeros(P, Q, C);
    for k = 1:C
        [g(:, :, k), Fshift, Gshift] = filterChannel(img(:, :, k), H, padding);
        specIn(:, :, k) = logMagnitude(Fshift);
        specOut(:, :, k) = logMagnitude(Gshift);
    end
    outImg = toOutputImage(g, "clip");

    info = struct( ...
        "psf", psf, ...
        "H", H, ...
        "spectrumIn", specIn, ...
        "spectrumOut", specOut, ...
        "channels", channelNames(C), ...
        "spectrumSize", [P, Q], ...
        "label", sprintf("Motion Blur (L = %g, angle = %g)", params.L, params.angle));

end
