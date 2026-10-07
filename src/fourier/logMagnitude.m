function S = logMagnitude(Fshift)
% log(1 + |F|) scaled to [0,1] for display
    arguments
        Fshift (:,:) double
    end

    S = log(1 + abs(Fshift));
    if max(S(:)) > 0
        S = S / max(S(:));
    end

end
