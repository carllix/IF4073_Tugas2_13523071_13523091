function [outImg, info] = motionRestoreImage(img, method, params)
% F: motion blur restoration in the frequency domain, channel by channel
% params: L, angle, threshold, radius (inverse), K (wiener), padding (default "mirror")
% info:   psf, H, spectrumIn, spectrumOut, label, spectrumSize
    arguments
        img {mustBeNumeric}
        method (1,1) string {mustBeMember(method, ["inverse", "wiener"])}
        params (1,1) struct
    end

    padding = string(getParam(params, "padding", "mirror"));

    [M, N, C] = size(img);
    if padding == "none"
        P = M; Q = N;
    else
        P = 2*M; Q = 2*N;
    end

    psf = motionPSF(params.L, params.angle);
    H = psfToTransfer(psf, P, Q);

    switch method
        case "inverse"
            threshold = getParam(params, "threshold", 0.1);
            radius = getParam(params, "radius", Inf);
            restore = @(G) inverseFilter(G, H, threshold, radius);
            label = sprintf("Inverse (L = %g, angle = %g, threshold = %g", params.L, params.angle, threshold);
            if isfinite(radius)
                label = label + sprintf(", radius = %g", radius);
            end
            label = label + ")";
        case "wiener"
            K = getParam(params, "K", 0.01);
            restore = @(G) wienerFilter(G, H, K);
            label = sprintf("Wiener (L = %g, angle = %g, K = %g)", params.L, params.angle, K);
    end

    g = zeros(M, N, C);
    specIn = zeros(P, Q, C);
    specOut = zeros(P, Q, C);
    for k = 1:C
        if padding == "none"
            f = double(img(:, :, k));
        else
            f = padImage(img(:, :, k), padding);
        end
        Gshift = centeredSpectrum(f);
        Fhat = restore(Gshift);
        fk = inverseCenteredSpectrum(Fhat);
        g(:, :, k) = fk(1:M, 1:N);
        specIn(:, :, k) = logMagnitude(Gshift);
        specOut(:, :, k) = logMagnitude(Fhat);
    end
    outImg = toOutputImage(g, "clip");

    info = struct( ...
        "psf", psf, ...
        "H", H, ...
        "spectrumIn", specIn, ...
        "spectrumOut", specOut, ...
        "spectrumSize", [P, Q], ...
        "label", label);

end

function value = getParam(params, name, default)
    if isfield(params, name)
        value = params.(name);
    else
        value = default;
    end
end
