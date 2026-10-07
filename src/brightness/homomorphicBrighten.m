function [s, Zshift, Sshift] = homomorphicBrighten(imgChannel, H, usePadding)
% f = i * r  ->  ln f = ln i + ln r, filter in the frequency domain, then exp back
% ln is taken of (f+1)/256 so z <= 0; scaling z by gammaL < 1 pulls it towards 0 = brighter
    arguments
        imgChannel (:,:) {mustBeNumeric}
        H (:,:) double
        usePadding (1,1) logical = true
    end

    z = log((double(imgChannel) + 1) / 256);
    [zFiltered, Zshift, Sshift] = filterChannel(z, H, usePadding);
    s = 256 * exp(zFiltered) - 1;   % double, not clipped

end
