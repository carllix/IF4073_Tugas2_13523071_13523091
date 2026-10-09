function names = channelNames(C)
% channel labels: "Gray" for 1 channel, R G B for 3
    arguments
        C (1,1) double {mustBeMember(C, [1, 3])}
    end

    if C == 1
        names = "Gray";
    else
        names = ["R", "G", "B"];
    end

end
