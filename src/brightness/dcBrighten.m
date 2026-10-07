function [s, Fshift, Gshift] = dcBrighten(imgChannel, gain, offset)
% s = a r + b done in the frequency domain:
% G(u,v) = a F(u,v) + b M N delta(u,v), since the DC term F(0,0) = M N * mean(f)
    arguments
        imgChannel (:,:) {mustBeNumeric}
        gain (1,1) double {mustBePositive}
        offset (1,1) double
    end

    [M, N] = size(imgChannel);
    Fshift = centeredSpectrum(imgChannel);

    Gshift = gain * Fshift;
    dc = [floor(M/2) + 1, floor(N/2) + 1];
    Gshift(dc(1), dc(2)) = Gshift(dc(1), dc(2)) + offset * M * N;

    s = inverseCenteredSpectrum(Gshift);   % double, not clipped

end
