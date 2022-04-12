% Need to loop through all standard permutations for:
%   Format: Non-HT/HT
%   MCS: 0-7/0-7 (1 ant)
%   Guard Interval: na/Short-Long
%   TBD

function generate_repo

    GIs = ["sgi", "lgi"];

    for mcs = 0 : 7
        filename = sprintf("beacon_mcs%d.raw", mcs);
        candidate_path = fullfile("..", "samples", "Non-HT", filename);
        generate_beacon_nonht("MCS", mcs, "Filename", candidate_path);
    end

    for mcs = 0 : 7
        for i = 1 : 2
            filename = sprintf("beacon_mcs%d_%s.raw", mcs, GIs(i));

            sgi_param = false;
            if (i == 1)
                sgi_param = true;
            end

            candidate_path = fullfile("..", "samples", "HT", filename);
            generate_beacon_ht(...
                "MCS", mcs, ...
                "ShortGuardInterval", sgi_param, ...
                "Filename", candidate_path ...
            );
        end
    end

end
