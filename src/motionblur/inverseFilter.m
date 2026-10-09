function Fhat = inverseFilter(G, H, threshold, radius)
% inverse: Fhat = G / H, |H| clamped to threshold
    arguments
        G (:,:) double
        H (:,:) double
        threshold (1,1) double {mustBeNonnegative} = 0
        radius (1,1) double {mustBePositive} = Inf
    end

    if ~isequal(size(G), size(H))
        error("inverseFilter:sizeMismatch", ...
            "G is %dx%d but H is %dx%d.", size(G, 1), size(G, 2), size(H, 1), size(H, 2));
    end

    mag = abs(H);
    small = mag < threshold;
    Hs = H;
    Hs(small) = threshold * H(small) ./ mag(small);
    Hs(small & mag == 0) = threshold;

    Fhat = G ./ Hs;

    if isfinite(radius)
        outside = distanceGrid(size(G, 1), size(G, 2)) > radius;
        Fhat(outside) = G(outside);
    end

end
