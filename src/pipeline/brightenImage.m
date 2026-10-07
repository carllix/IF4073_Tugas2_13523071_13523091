function [outImg, info] = brightenImage(img, method, params)
% D: brightening in the frequency domain, channel by channel
% "homomorphic": D0, gammaL, gammaH, c (default 1), usePadding (default true)
% "dc":          gain (a), offset (b)  ->  G = a F + b M N delta(u,v), i.e. s = a r + b
% info: H, spectrumIn, spectrumOut (log magnitude in [0,1], luminance), label, spectrumSize
    arguments
        img {mustBeNumeric}
        method (1,1) string {mustBeMember(method, ["homomorphic", "dc"])}
        params (1,1) struct = struct()
    end

    [M, N, C] = size(img);
    g = zeros(M, N, C);
    lum = toGrayscale(img);

    switch method
        case "homomorphic"
            usePadding = getParam(params, "usePadding", true);
            c = getParam(params, "c", 1);
            if usePadding
                P = 2*M; Q = 2*N;
            else
                P = M; Q = N;
            end

            H = homomorphicFilter(P, Q, params.D0, params.gammaL, params.gammaH, c);
            for k = 1:C
                g(:, :, k) = homomorphicBrighten(img(:, :, k), H, usePadding);
            end
            [~, Fshift, Gshift] = homomorphicBrighten(lum, H, usePadding);   % spectrum of ln f
            label = sprintf("Homomorphic (D0 = %g, gammaL = %g, gammaH = %g, c = %g)", ...
                params.D0, params.gammaL, params.gammaH, c);

        case "dc"
            P = M; Q = N;
            % H is a gain a everywhere; the offset b only touches the DC sample
            H = params.gain * ones(P, Q);
            for k = 1:C
                g(:, :, k) = dcBrighten(img(:, :, k), params.gain, params.offset);
            end
            [~, Fshift, Gshift] = dcBrighten(lum, params.gain, params.offset);
            label = sprintf("DC Brightening (a = %g, b = %g)", params.gain, params.offset);
    end

    outImg = toOutputImage(g, "clip");

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
