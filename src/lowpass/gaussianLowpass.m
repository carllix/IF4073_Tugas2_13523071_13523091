function H = gaussianLowpass(P, Q, sigma)
% GLPF: H = exp(-D^2 / (2 sigma^2))
    arguments
        P (1,1) double {mustBePositive, mustBeInteger}
        Q (1,1) double {mustBePositive, mustBeInteger}
        sigma (1,1) double {mustBePositive}
    end

    D = distanceGrid(P, Q);
    H = exp(-(D.^2) / (2 * sigma^2));

end
