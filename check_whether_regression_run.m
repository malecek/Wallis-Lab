cd ~/Science/wallis/data
sessions = dir;
not_processed = [];
for i = 3:length(sessions)
    session = sessions(i).name;
    SpikeInfo = spk_read(session);
    for j = 1:length(SpikeInfo.NeuronID)
        mat_file = [session '-' int2str(SpikeInfo.NeuronID(j))];
        cd('../regression_results')
        try
            load(mat_file)
        catch
            not_processed = [not_processed; mat_file];
        end
    end
end
clear sessions session SpikeInfo betas p_values