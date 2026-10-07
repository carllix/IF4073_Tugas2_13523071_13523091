function H = idealHighpass(P, Q, D0)
% IHPF = 1 - ILPF: H = 0 if D <= D0, else 1
    arguments
        P (1,1) double {mustBePositive, mustBeInteger}
        Q (1,1) double {mustBePositive, mustBeInteger}
        D0 (1,1) double {mustBePositive}
    end

    H = 1 - idealLowpass(P, Q, D0);

end
