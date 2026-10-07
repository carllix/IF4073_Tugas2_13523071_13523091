function [outImg, info] = frequencyFilterImage(img, method, params)
% B/C: low-pass or high-pass filtering in the frequency domain, channel by channel
% params: D0 (ILPF/IHPF/BLPF/BHPF), sigma (GLPF/GHPF), order (BLPF/BHPF),
%         usePadding (default true), outputMode "clip" | "normalize" (default "clip")
% info:   H, spectrumIn, spectrumOut (log magnitude in [0,1], luminance), label, spectrumSize
    arguments
        img {mustBeNumeric}
        method (1,1) string {mustBeMember(method, ["ILPF", "GLPF", "BLPF", "IHPF", "GHPF", "BHPF"])}
        params (1,1) struct = struct()
    end

    usePadding = getParam(params, "usePadding", true);
    outputMode = getParam(params, "outputMode", "clip");

    [M, N, C] = size(img);
    if usePadding
        P = 2*M; Q = 2*N;
    else
        P = M; Q = N;
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
    for k = 1:C
        g(:, :, k) = filterChannel(img(:, :, k), H, usePadding);
    end
    outImg = toOutputImage(g, outputMode);

    % spectra are shown for the luminance so RGB and grayscale look the same in the UI
    [~, Fshift, Gshift] = filterChannel(toGrayscale(img), H, usePadding);

    info = struct( ...
        "H", H, ...
        "spectrumIn", logMagnitude(Fshift), ...
        "spectrumOut", logMagnitude(Gshift), ...
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
