function centers = detectSpikes(img, k, rDC, padding, maxSpikes)
% notch centres [dRow, dCol] from spectrum peaks above mean + k*std
% one per conjugate pair; notchReject adds the mirror
    arguments
        img {mustBeNumeric}
        k (1,1) double {mustBePositive} = 4
        rDC (1,1) double {mustBeNonnegative} = 10
        padding (1,1) string {mustBeMember(padding, ["zero", "mirror", "none"])} = "none"
        maxSpikes (1,1) double {mustBePositive, mustBeInteger} = 20
    end

    f = double(toGrayscale(img));
    if padding ~= "none"
        f = padImage(f, padding);
    end
    S = log(1 + abs(centeredSpectrum(f)));
    [P, Q] = size(S);

    % contrast against the 9x9 local mean
    R = S - boxMean(S, 4);

    % ignore the DC area
    outside = distanceGrid(P, Q) > rDC;
    vals = R(outside);
    threshold = mean(vals) + k * std(vals);

    % 3x3 local maxima only
    Spad = -Inf(P + 2, Q + 2);
    Spad(2:end-1, 2:end-1) = S;
    isPeak = true(P, Q);
    for dr = -1:1
        for dc = -1:1
            if dr ~= 0 || dc ~= 0
                isPeak = isPeak & S >= Spad((2:end-1) + dr, (2:end-1) + dc);
            end
        end
    end

    [r, c] = find(isPeak & outside & R > threshold);
    dRow = r - (floor(P/2) + 1);
    dCol = c - (floor(Q/2) + 1);

    upper = dRow > 0 | (dRow == 0 & dCol > 0);
    dRow = dRow(upper);
    dCol = dCol(upper);
    strength = R(sub2ind([P, Q], r(upper), c(upper)));

    [~, order] = sort(strength, 'descend');
    order = order(1:min(maxSpikes, numel(order)));
    centers = [dRow(order), dCol(order)];

end

function m = boxMean(A, r)
% (2r+1)^2 box mean via integral image
    [P, Q] = size(A);
    rows = min(max((1 - r):(P + r), 1), P);
    cols = min(max((1 - r):(Q + r), 1), Q);
    I = zeros(P + 2*r + 1, Q + 2*r + 1);
    I(2:end, 2:end) = cumsum(cumsum(A(rows, cols), 1), 2);
    w = 2*r + 1;
    m = (I(w+1:end, w+1:end) - I(1:end-w, w+1:end) - I(w+1:end, 1:end-w) + I(1:end-w, 1:end-w)) / w^2;
end
