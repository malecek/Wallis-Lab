function normed_spikes = norm_spikes(trial_spikes)
% normed_spikes = norm_spikes(trial_spikes)
% 
% trial_spikes should be smoothed before this step.

n_rows, n_columns = size(trial_spikes);
flat_spikes = reshape(trial_spikes, n_rows*n_columns, 1);
normed_spikes = (trial_spikes - mean(flat_spikes)) / std(flat_spikes);