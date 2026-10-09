function padded = padImage(imgChannel, mode)
% pad a channel to 2M x 2N (image stays top-left) to avoid wraparound
    arguments
        imgChannel (:,:) {mustBeNumeric}
        mode (1,1) string {mustBeMember(mode, ["zero", "mirror"])} = "zero"
    end

    [M, N] = size(imgChannel);
    switch mode
        case "zero"
            padded = zeros(2*M, 2*N);
            padded(1:M, 1:N) = double(imgChannel);
        case "mirror"
            rows = [1:M, M:-1:1];
            cols = [1:N, N:-1:1];
            padded = double(imgChannel(rows, cols));
    end

end
