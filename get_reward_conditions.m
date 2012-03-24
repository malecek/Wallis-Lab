function reward_conditions = get_reward_conditions(SpikeInfo)

rs_indices = SpikeInfo.ResponseError == 0 & SpikeInfo.ConditionNumber < 241;
rs_conditions = SpikeInfo.ConditionNumber(rs_indices);
reward_levels = [1:5:236; 2:5:237; 3:5:238; 4:5:239; 5:5:240];
for i = 1:length(rs_conditions)
    [row col] = find(reward_levels == rs_conditions(i));
    reward_conditions(i) = row;
end
% Make reward_conditions a column vector.
reward_conditions = reward_conditions';