function [outImg, info] = brightenImage(img, method, params)
% D: brightening in the frequency domain, channel by channel
% "homomorphic": D0, gammaL, gammaH, c (default 1), padding "zero" | "mirror" | "none" (default "zero")
% "dc":          gain (a), offset (b)  ->  G = a F + b M N delta(u,v), i.e. s = a r + b
% info: H, spectrumIn, spectrumOut (log magnitude in [0,1], P x Q x C), label, spectrumSize
    arguments
        img {mustBeNumeric}
        method (1,1) string {mustBeMember(method, ["homomorphic", "dc"])}
        params (1,1) struct = struct()
    end

    [M, N, C] = size(img);
    g = zeros(M, N, C);

    switch method
        case "homomorphic"
            padding = string(getParam(params, "padding", "zero"));
            c = getParam(params, "c", 1);
            if padding == "none"
                P = M; Q = N;
            else
                P = 2*M; Q = 2*N;
            end

            H = homomorphicFilter(P, Q, params.D0, params.gammaL, params.gammaH, c);
            specIn = zeros(P, Q, C);
            specOut = zeros(P, Q, C);
            for k = 1:C
                [g(:, :, k), Zshift, Sshift] = homomorphicBrighten(img(:, :, k), H, padding);
                specIn(:, :, k) = logMagnitude(Zshift);
                specOut(:, :, k) = logMagnitude(Sshift);
            end
            label = sprintf("Homomorphic (D0 = %g, gammaL = %g, gammaH = %g, c = %g)", ...
                params.D0, params.gammaL, params.gammaH, c);

        case "dc"
            P = M; Q = N;
            % H is a gain a everywhere; the offset b only touches the DC sample
            H = params.gain * ones(P, Q);
            specIn = zeros(P, Q, C);
            specOut = zeros(P, Q, C);
            for k = 1:C
                [g(:, :, k), Fshift, Gshift] = dcBrighten(img(:, :, k), params.gain, params.offset);
                specIn(:, :, k) = logMagnitude(Fshift);
                specOut(:, :, k) = logMagnitude(Gshift);
            end
            label = sprintf("DC Brightening (a = %g, b = %g)", params.gain, params.offset);
    end

    outImg = toOutputImage(g, "clip");

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
