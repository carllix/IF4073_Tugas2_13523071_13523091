function rgb = drawCircles(rgb, centers, radius, color)
% circle outlines at [row, col] on a uint8 RGB image
    arguments
        rgb (:,:,3) uint8
        centers (:,2) double
        radius (1,1) double {mustBePositive}
        color (1,3) uint8 = uint8([255 40 120])
    end

    [P, Q, ~] = size(rgb);
    thickness = max(1, round(min(P, Q) / 150));
    [x, y] = meshgrid(1:Q, 1:P);

    ring = false(P, Q);
    for k = 1:size(centers, 1)
        d = hypot(y - centers(k, 1), x - centers(k, 2));
        ring = ring | abs(d - radius) <= thickness;
    end

    for ch = 1:3
        plane = rgb(:, :, ch);
        plane(ring) = color(ch);
        rgb(:, :, ch) = plane;
    end

end
