function padded = padImage(imgChannel)
% mirror-pad a channel to 2M x 2N (image stays top-left) to avoid wraparound
    arguments
        imgChannel (:,:) {mustBeNumeric}
    end

    [M, N] = size(imgChannel);
    rows = [1:M, M:-1:1];
    cols = [1:N, N:-1:1];
    padded = double(imgChannel(rows, cols));

end
