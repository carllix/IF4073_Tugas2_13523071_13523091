function out = resizeNearest(A, targetSize)
% nearest-neighbour upscale
    arguments
        A {mustBeNumeric}
        targetSize (1,1) double {mustBePositive, mustBeInteger}
    end

    scale = max(1, floor(targetSize / max(size(A, 1), size(A, 2))));
    rows = ceil((1:size(A, 1) * scale) / scale);
    cols = ceil((1:size(A, 2) * scale) / scale);
    out = A(rows, cols, :);

end
