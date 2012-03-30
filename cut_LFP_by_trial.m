function LFP_by_trial = cut_LFP_by_trial(filtered_LFP, SpikeInfo)
% LFP_by_trial = cut_LFP_by_trial(filtered_LFP, SpikeInfo)

cue_time_array = get_cue_times(SpikeInfo);
for i = 1:length(cue_time_array)
    cue_time = cue_time_array(i);
    LFP_by_trial(i, :) = filtered_LFP(cue_time-550:cue_time+3300);
end