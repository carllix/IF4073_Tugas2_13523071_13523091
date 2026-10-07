function H = homomorphicFilter(P, Q, D0, gammaL, gammaH, c)
% H = (gammaH - gammaL) * (1 - exp(-c D^2 / D0^2)) + gammaL
% gain gammaL on low frequencies (illumination), gammaH on high frequencies (reflectance)
    arguments
        P (1,1) double {mustBePositive, mustBeInteger}
        Q (1,1) double {mustBePositive, mustBeInteger}
        D0 (1,1) double {mustBePositive}
        gammaL (1,1) double {mustBePositive}
        gammaH (1,1) double {mustBePositive}
        c (1,1) double {mustBePositive} = 1
    end

    D = distanceGrid(P, Q);
    H = (gammaH - gammaL) * (1 - exp(-c * (D.^2) / D0^2)) + gammaL;

end
