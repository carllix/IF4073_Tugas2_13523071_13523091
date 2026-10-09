function [outImg, info] = periodicRestoreImage(img, method, params)
% E: periodic noise removal in the frequency domain, channel by channel
% params: D0, W, order, centers, notchType, padding (default "none")
% info:   H, spectrumIn, spectrumOut, channels, label, spectrumSize
    arguments
        img {mustBeNumeric}
        method (1,1) string {mustBeMember(method, ["IBRF", "BBRF", "GBRF", "notch"])}
        params (1,1) struct = struct()
    end

    padding = string(getParam(params, "padding", "none"));

    [M, N, C] = size(img);
    if padding == "none"
        P = M; Q = N;
    else
        P = 2*M; Q = 2*N;
    end

    switch method
        case "IBRF"
            H = idealBandreject(P, Q, params.D0, params.W);
            label = sprintf("IBRF (D0 = %g, W = %g)", params.D0, params.W);
        case "BBRF"
            H = butterworthBandreject(P, Q, params.D0, params.W, params.order);
            label = sprintf("BBRF (D0 = %g, W = %g, n = %g)", params.D0, params.W, params.order);
        case "GBRF"
            H = gaussianBandreject(P, Q, params.D0, params.W);
            label = sprintf("GBRF (D0 = %g, W = %g)", params.D0, params.W);
        case "notch"
            notchType = string(getParam(params, "notchType", "butterworth"));
            order = getParam(params, "order", 2);
            H = notchReject(P, Q, params.centers, params.D0, notchType, order);
            if notchType == "butterworth"
                label = sprintf("Notch %s (D0 = %g, n = %g, centers = %s)", ...
                    notchType, params.D0, order, mat2str(params.centers));
            else
                label = sprintf("Notch %s (D0 = %g, centers = %s)", ...
                    notchType, params.D0, mat2str(params.centers));
            end
    end

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
        "H", H, ...
        "spectrumIn", specIn, ...
        "spectrumOut", specOut, ...
        "channels", channelNames(C), ...
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
