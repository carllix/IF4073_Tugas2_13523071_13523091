function [outImg, info] = frequencyFilterImage(img, method, params)
% B/C: low-pass or high-pass filtering in the frequency domain, channel by channel
% params: D0 (ILPF/IHPF/BLPF/BHPF), sigma (GLPF/GHPF), order (BLPF/BHPF),
%         padding "zero" | "mirror" | "none" (default "zero"), outputMode "clip" | "normalize" (default "clip")
% info:   H, spectrumIn, spectrumOut (log magnitude in [0,1], P x Q x C), label, spectrumSize
    arguments
        img {mustBeNumeric}
        method (1,1) string {mustBeMember(method, ["ILPF", "GLPF", "BLPF", "IHPF", "GHPF", "BHPF"])}
        params (1,1) struct = struct()
    end

    padding = string(getParam(params, "padding", "zero"));
    outputMode = getParam(params, "outputMode", "clip");

    [M, N, C] = size(img);
    if padding == "none"
        P = M; Q = N;
    else
        P = 2*M; Q = 2*N;
    end

    switch method
        case "ILPF"
            H = idealLowpass(P, Q, params.D0);
            label = sprintf("ILPF (D0 = %g)", params.D0);
        case "GLPF"
            H = gaussianLowpass(P, Q, params.sigma);
            label = sprintf("GLPF (sigma = %g)", params.sigma);
        case "BLPF"
            H = butterworthLowpass(P, Q, params.D0, params.order);
            label = sprintf("BLPF (D0 = %g, n = %g)", params.D0, params.order);
        case "IHPF"
            H = idealHighpass(P, Q, params.D0);
            label = sprintf("IHPF (D0 = %g)", params.D0);
        case "GHPF"
            H = gaussianHighpass(P, Q, params.sigma);
            label = sprintf("GHPF (sigma = %g)", params.sigma);
        case "BHPF"
            H = butterworthHighpass(P, Q, params.D0, params.order);
            label = sprintf("BHPF (D0 = %g, n = %g)", params.D0, params.order);
    end

    g = zeros(M, N, C);
    specIn = zeros(P, Q, C);
    specOut = zeros(P, Q, C);
    for k = 1:C
        [g(:, :, k), Fshift, Gshift] = filterChannel(img(:, :, k), H, padding);
        specIn(:, :, k) = logMagnitude(Fshift);
        specOut(:, :, k) = logMagnitude(Gshift);
    end
    outImg = toOutputImage(g, outputMode);

    info = struct( ...
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
