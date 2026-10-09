function H = gaussianBandreject(P, Q, D0, W)
% GBRF: H = 1 - exp(-1/2 ((D^2 - D0^2) / (D W))^2)
    arguments
        P (1,1) double {mustBePositive, mustBeInteger}
        Q (1,1) double {mustBePositive, mustBeInteger}
        D0 (1,1) double {mustBePositive}
        W (1,1) double {mustBePositive}
    end

    D = distanceGrid(P, Q);
    H = 1 - exp(-0.5 * ((D.^2 - D0^2) ./ (D .* W)).^2);

end
