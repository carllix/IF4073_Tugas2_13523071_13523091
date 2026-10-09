function H = notchReject(P, Q, centers, D0, type, order)
% NRF: H = prod_k H_k H_-k, highpass of radius D0 centred on each spike [row, col] and its mirror
    arguments
        P (1,1) double {mustBePositive, mustBeInteger}
        Q (1,1) double {mustBePositive, mustBeInteger}
        centers (:,2) double {mustBeNonempty}
        D0 (1,1) double {mustBePositive}
        type (1,1) string {mustBeMember(type, ["ideal", "butterworth", "gaussian"])} = "butterworth"
        order (1,1) double {mustBePositive} = 2
    end

    H = ones(P, Q);
    for k = 1:size(centers, 1)
        for s = [1, -1]
            D = distanceGrid(P, Q, s * centers(k, :));
            switch type
                case "ideal"
                    Hk = double(D > D0);
                case "butterworth"
                    Hk = 1 ./ (1 + (D0 ./ D).^(2 * order));
                case "gaussian"
                    Hk = 1 - exp(-(D.^2) / (2 * D0^2));
            end
            H = H .* Hk;
        end
    end

end
