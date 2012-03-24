function [rew_mean rew_sd] = get_reward_mean_sd(reward_matrix)
% [rew_mean rew_sd] = get_reward_mean_sd(reward_matrix)

% 17 X 3751
flattened_matrix = reshape(reward_matrix, 1, 17*3751);
rew_mean = mean(flattened_matrix);
rew_sd = std(flattened_matrix);