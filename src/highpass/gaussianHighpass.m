function H = gaussianHighpass(P, Q, sigma)
% GHPF = 1 - GLPF: H = 1 - exp(-D^2 / (2 sigma^2))
    arguments
        P (1,1) double {mustBePositive, mustBeInteger}
        Q (1,1) double {mustBePositive, mustBeInteger}
        sigma (1,1) double {mustBePositive}
    end

    H = 1 - gaussianLowpass(P, Q, sigma);

end
