function mean_firing_rate = get_mean_firing_rate(neuron, SpikeInfo, SpikeData)
% mean_firing_rate = get_mean_firing_rate(neuron, SpikeInfo, SpikeData)

trial_spikes = get_trial_spikes(SpikeInfo, SpikeData, neuron);
trial_spikes = norm_spikes(smooth_spikes(trial_spikes));
reward_conditions = get_reward_conditions(SpikeInfo);
mean_firing_rate = get_condition_spikes(reward_conditions, trial_spikes);
