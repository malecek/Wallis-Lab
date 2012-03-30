cd ~/Science/wallis/regression_results
mat_files = dir;
pos_encoders = [];
neg_encoders = [];
mixed_encoders = [];
for i = 3:length(mat_files)
    neuron = mat_files(i).name;
    if regexp(neuron, '[AB][0-9]{3}-[0-9]{4}.mat')
        load(neuron(1:end-4), 'betas', 'r_squareds', 'p_values');
        pos_count = 0;
        neg_count = 0;
        for j = 32:200
            if p_values(j) < 0.001
                if betas(j) < 0
                    neg_count = neg_count + 1;
                else
                    pos_count = pos_count + 1;
                end
            end
        end
        if pos_count > 0 & neg_count > 0
            mixed_encoders = [mixed_encoders; neuron(1:end-4)];
        elseif pos_count > 0
            pos_encoders = [pos_encoders; neuron(1:end-4)];
        elseif neg_count > 0
            neg_encoders = [neg_encoders; neuron(1:end-4)];
        end
    end
end
save('encoders', 'pos_encoders', 'neg_encoders', 'mixed_encoders')