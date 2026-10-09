function H = butterworthBandreject(P, Q, D0, W, order)
% BBRF: H = 1 / (1 + (D W / (D^2 - D0^2))^(2n))
    arguments
        P (1,1) double {mustBePositive, mustBeInteger}
        Q (1,1) double {mustBePositive, mustBeInteger}
        D0 (1,1) double {mustBePositive}
        W (1,1) double {mustBePositive}
        order (1,1) double {mustBePositive}
    end

    D = distanceGrid(P, Q);
    H = 1 ./ (1 + ((D .* W) ./ (D.^2 - D0^2)).^(2 * order));

end
