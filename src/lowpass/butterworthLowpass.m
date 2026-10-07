function H = butterworthLowpass(P, Q, D0, order)
% BLPF: H = 1 / (1 + (D/D0)^(2n))
    arguments
        P (1,1) double {mustBePositive, mustBeInteger}
        Q (1,1) double {mustBePositive, mustBeInteger}
        D0 (1,1) double {mustBePositive}
        order (1,1) double {mustBePositive}
    end

    D = distanceGrid(P, Q);
    H = 1 ./ (1 + (D ./ D0).^(2 * order));

end
