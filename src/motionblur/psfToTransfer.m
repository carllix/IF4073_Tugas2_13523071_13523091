function H = psfToTransfer(psf, P, Q)
% H = fftshift(fft2(h)), h padded to P x Q and centred at (1,1)
    arguments
        psf (:,:) double
        P (1,1) double {mustBePositive, mustBeInteger}
        Q (1,1) double {mustBePositive, mustBeInteger}
    end

    [m, n] = size(psf);
    if m > P || n > Q
        error("psfToTransfer:psfTooLarge", ...
            "PSF is %dx%d but the spectrum is only %dx%d.", m, n, P, Q);
    end

    h = zeros(P, Q);
    h(1:m, 1:n) = psf;
    h = circshift(h, -floor([m, n] / 2));

    H = fftshift(fft2(h));

end
