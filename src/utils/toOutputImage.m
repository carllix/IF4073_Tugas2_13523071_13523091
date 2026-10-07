function outImg = toOutputImage(g, mode)
% double result -> uint8; "clip" keeps absolute levels, "normalize" stretches min..max to 0..255
    arguments
        g {mustBeNumeric}
        mode (1,1) string {mustBeMember(mode, ["clip", "normalize"])} = "clip"
    end

    g = double(g);
    switch mode
        case "clip"
            out = g;
        case "normalize"
            % over all channels at once so the colour balance is kept
            lo = min(g(:));
            hi = max(g(:));
            if hi > lo
                out = (g - lo) / (hi - lo) * 255;
            else
                out = zeros(size(g));
            end
    end

    outImg = uint8(max(min(round(out), 255), 0));

end
