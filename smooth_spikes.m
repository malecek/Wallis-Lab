function smoothed_spikes = smooth_spikes(trial_spikes)
% smoothed_spikes = smooth_spikes(trial_spikes)

for i = 1:size(trial_spikes, 2)-99
    smoothed_spikes(:, i) = mean(condition_spikes(:, i:i+99), 2);
end
