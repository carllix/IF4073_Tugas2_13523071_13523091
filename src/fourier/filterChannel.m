function [g, Fshift, Gshift] = filterChannel(imgChannel, H, usePadding)
% g = IDFT{ H .* F }, H built for the (padded) spectrum size; returns double, not clipped
    arguments
        imgChannel (:,:) {mustBeNumeric}
        H (:,:) double
        usePadding (1,1) logical = true
    end

    [M, N] = size(imgChannel);
    if usePadding
        f = padImage(imgChannel);
    else
        f = double(imgChannel);
    end

    if ~isequal(size(H), size(f))
        error("filterChannel:sizeMismatch", ...
            "H is %dx%d but the spectrum is %dx%d.", size(H, 1), size(H, 2), size(f, 1), size(f, 2));
    end

    Fshift = centeredSpectrum(f);
    Gshift = Fshift .* H;
    g = inverseCenteredSpectrum(Gshift);
    g = g(1:M, 1:N);   % crop the padding away

end
