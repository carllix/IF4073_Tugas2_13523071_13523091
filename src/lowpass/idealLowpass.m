function H = idealLowpass(P, Q, D0)
% ILPF: H = 1 if D <= D0, else 0
    arguments
        P (1,1) double {mustBePositive, mustBeInteger}
        Q (1,1) double {mustBePositive, mustBeInteger}
        D0 (1,1) double {mustBePositive}
    end

    D = distanceGrid(P, Q);
    H = double(D <= D0);

end
