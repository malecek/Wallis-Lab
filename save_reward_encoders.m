function save_reward_encoders(LFP_or_neur, alpha)
% save_reward_encoders(LFP_or_neur, alpha)

if strcmp(LFP_or_neur, 'neur')
    cd ~/Science/wallis/spike_regression
    match_string = '[AB][0-9]{3}-[0-9]{4}.mat';
else
    cd ~/Science/wallis/LFP_regression
    match_string = '[AB][0-9]{3}-[0-9]{4}-[0-9]{1,3}(_[0-9]{4})?.mat';
end
mat_files = dir;
pos_encoders = {};
neg_encoders = {};
mixed_encoders = {};
for i = 3:length(mat_files)
    unit = mat_files(i).name;
    if regexp(unit, match_string)
        unit = unit(1:end-4);
        load(unit, 'betas', 'r_squareds', 'p_values');
        pos_count = 0;
        neg_count = 0;
        consec = 0;
        for j = 32:200
            if p_values(j) < alpha
                consec = consec + 1;
                if consec == 3
                    if betas(j) < 0
                        neg_count = neg_count + 1;
                    else
                        pos_count = pos_count + 1;
                    end
                end
            else
                consec = 0;
            end
        end
        if pos_count > 0 & neg_count > 0
            mixed_encoders{end+1} = unit;
        elseif pos_count > 0
            pos_encoders{end+1} = unit;
        elseif neg_count > 0
            neg_encoders{end+1} = unit;
        end
    end
end
save('encoders', 'pos_encoders', 'neg_encoders', 'mixed_encoders')