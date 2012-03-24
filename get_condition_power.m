function cond_matrix = get_condition_power(reward_conditions, power_matrix)

cond_matrix = zeros(17, 5, 3751);
for i = 1:17
    for j = 1:5
        cond_matrix(i,j,:) = mean(power_matrix(i,reward_conditions==j,:));
    end
end