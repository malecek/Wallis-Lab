function condition_spikes=get_condition_spikes(reward_conditions,trial_spikes)
% get_condition_spikes(reward_conditions, trial_spikes)

for i= 1:5
    condition_spikes(i,:) = mean(trial_spikes(reward_conditions==i,:), 1);
end
