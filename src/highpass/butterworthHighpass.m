function H = butterworthHighpass(P, Q, D0, order)
% BHPF = 1 - BLPF: H = 1 / (1 + (D0/D)^(2n))
    arguments
        P (1,1) double {mustBePositive, mustBeInteger}
        Q (1,1) double {mustBePositive, mustBeInteger}
        D0 (1,1) double {mustBePositive}
        order (1,1) double {mustBePositive}
    end

    H = 1 - butterworthLowpass(P, Q, D0, order);

end
