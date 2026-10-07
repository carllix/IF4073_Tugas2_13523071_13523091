function g = inverseCenteredSpectrum(Gshift)
% back to the spatial domain from a centred spectrum; drops float-noise imaginary part
    arguments
        Gshift (:,:) double
    end

    g = real(ifft2(ifftshift(Gshift)));

end
