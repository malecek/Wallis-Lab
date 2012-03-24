function cue_times = get_cue_times(SpikeInfo)
% cue_times = get_cue_times(SpikeInfo)
% 
% Returns cue times in ms since the start of the session.

rs_indices = SpikeInfo.ResponseError == 0 & SpikeInfo.ConditionNumber < 241;
rs_first_codes = SpikeInfo.CodeIndex(rs_indices);
rs_n_codes = SpikeInfo.CodesPerTrial(rs_indices);
% Make array of the cue times within successful trials.
cue_times = [];
for i = 1:length(rs_first_codes)
    for j = rs_first_codes(i):rs_first_codes(i)+rs_n_codes(i)-1
        if SpikeInfo.CodeNumbers(j) == 27
            cue_times = [cue_times; SpikeInfo.CodeTimes(j)];
            break
        end
    end
end
cue_times = round(cue_times*1000);
