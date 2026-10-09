function psf = motionPSF(L, angle)
% motion PSF: line of length L at angle (degrees), sum = 1
    arguments
        L (1,1) double {mustBePositive}
        angle (1,1) double
    end

    half = (L - 1) / 2;
    sz = 2 * ceil(half) + 3;
    c = (sz + 1) / 2;

    t = linspace(-half, half, max(2, ceil(20 * L)));
    x = c + t * cosd(angle);
    y = c + t * sind(angle);

    x0 = floor(x);
    y0 = floor(y);
    fx = x - x0;
    fy = y - y0;

    rows = [y0, y0, y0 + 1, y0 + 1];
    cols = [x0, x0 + 1, x0, x0 + 1];
    w = [(1 - fx) .* (1 - fy), fx .* (1 - fy), (1 - fx) .* fy, fx .* fy];

    psf = accumarray([rows(:), cols(:)], w(:), [sz, sz]);
    psf = psf / sum(psf(:));

end
