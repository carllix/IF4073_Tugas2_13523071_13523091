function H = idealBandreject(P, Q, D0, W)
% IBRF: H = 0 if D0 - W/2 <= D <= D0 + W/2, else 1
    arguments
        P (1,1) double {mustBePositive, mustBeInteger}
        Q (1,1) double {mustBePositive, mustBeInteger}
        D0 (1,1) double {mustBePositive}
        W (1,1) double {mustBePositive}
    end

    D = distanceGrid(P, Q);
    H = double(abs(D - D0) > W / 2);

end
