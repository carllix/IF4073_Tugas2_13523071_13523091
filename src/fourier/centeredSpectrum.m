function Fshift = centeredSpectrum(imgChannel)
% F(u,v) with the zero frequency moved to the centre
    arguments
        imgChannel (:,:) {mustBeNumeric}
    end

    Fshift = fftshift(fft2(double(imgChannel)));

end
