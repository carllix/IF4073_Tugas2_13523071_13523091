function Fhat = wienerFilter(G, H, K)
% Wiener: Fhat = conj(H) / (|H|^2 + K) * G
    arguments
        G (:,:) double
        H (:,:) double
        K (1,1) double {mustBeNonnegative}
    end

    if ~isequal(size(G), size(H))
        error("wienerFilter:sizeMismatch", ...
            "G is %dx%d but H is %dx%d.", size(G, 1), size(G, 2), size(H, 1), size(H, 2));
    end

    Fhat = conj(H) ./ (abs(H).^2 + K) .* G;

end
