function D = distanceGrid(P, Q)
% D(u,v): distance of every frequency sample to the centre of a fftshift-ed P x Q spectrum
    arguments
        P (1,1) double {mustBePositive, mustBeInteger}
        Q (1,1) double {mustBePositive, mustBeInteger}
    end

    [u, v] = meshgrid(1:Q, 1:P);

    % fftshift moves DC to floor(size/2)+1 for both even and odd sizes
    u0 = floor(Q/2) + 1;
    v0 = floor(P/2) + 1;

    D = sqrt((u - u0).^2 + (v - v0).^2);

end
