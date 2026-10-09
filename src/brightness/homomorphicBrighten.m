function [s, Zshift, Sshift] = homomorphicBrighten(imgChannel, H, padding)
% f = i * r  ->  ln f = ln i + ln r, filter in the frequency domain, then exp back
% ln is taken of (f+1)/256 so z <= 0; scaling z by gammaL < 1 pulls it towards 0 = brighter
    arguments
        imgChannel (:,:) {mustBeNumeric}
        H (:,:) double
        padding (1,1) string {mustBeMember(padding, ["zero", "mirror", "none"])} = "zero"
    end

    z = log((double(imgChannel) + 1) / 256);
    [zFiltered, Zshift, Sshift] = filterChannel(z, H, padding);
    s = 256 * exp(zFiltered) - 1;   % double, not clipped

end
