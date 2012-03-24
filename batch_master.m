function batch_master(LFP_or_neur, all_or_encoders, varargin)
% 1) batch_master(LFP_or_neur, all_or_encoders, func)
% 2) batch_master(LFP_or_neur, all_or_encoders, func1, func2)
% 
% This is the master function used to call a specified function on individual
% electrodes or neurons, all of them or just the significant encoders.
% 
% Inputs
% ------
% LFP_or_neur : str
%   'LFP' or 'neur'
% 
% all_or_encoders : str
%   'all' or 'encoders'
% 
% func : str
%   Function to be called on the specified neurons or electrodes.
% 
% func1 : str
%   Function to be called on the specified neurons or electrodes
%   that returns data to be accumulated.
% 
% func2 : str
%   Function to be called on the accumulated data.

if length(varargin) == 1
    func = varargin{1};
else
    func1 = varargin{1};
    func2 = varargin{2};
end
data_dir = '~/Documents/MATLAB/wallis/data';
cd(data_dir)
if length(all_or_encoders) == 8
    encoder_types = ['pos'; 'neg'];
    if LFP_or_neur == 'neur'
        load('encoders', 'pos_encoders', 'neg_encoders')
    else
        load('LFP_encoders', 'pos_encoders', 'neg_encoders')
        % Remove the frequency index.
        for i = size(encoder_types, 1)
            e_type = [encoder_types(i,:) '_encoders'];
            eval([e_type '_encoders = ' e_type '_encoders(:, 1:9);'])
            eval([e_type '_encoders = unique(' e_type '_encoders, ''rows'');'])
        end
    end
    if exist('func')
        rounds = 1;
        % Because each encoder will be processed individually,
        % keeping the types separate is unnecessary.
        pos_encoders = [pos_encoders; neg_encoders];
        n_encoders = [length(pos_encoders)];
    else
        rounds = 2;
        n_encoders = [length(pos_encoders) length(neg_encoders)];
    end
    for i = 1:rounds
        e_type = [encoder_types(i, :) '_encoders'];
        count = 1;
        for j = 1:n_encoders(i)
            match = eval(['regexp(' e_type '(j,:), ''-'', ''split'')']);
            session = match{1};
            unit = match{2};
            cd(session)
            [SpikeInfo, ~, ~, SpikeData] = spk_read([session, '.spk']);
            if exist('func')
                eval([func '(session, unit, SpikeInfo, SpikeData)'])
            else
                eval(['accum_' e_type '(count,:,:) = ' ...
                      func1 '(unit,SpikeInfo,SpikeData);'])
                count = count + 1;
            end
            cd('..')
        end
    end
else
    count = 1;
    sessions = dir;
    for i = 3:length(sessions)
        session = sessions(i).name;
        if regexp(session, '[AB][0-9]{3}')
            % In case you've moved since you were last in data_dir,
            % return there.
            cd(data_dir)
            [SpikeInfo, ~, ~, SpikeData] = spk_read(session);
            if LFP_or_neur == 'neur'
                units = SpikeInfo.NeuronID;
            else
                units = SpikeInfo.LFPID;
            end
            for j = 1:length(units)
                unit = units(j);
                if exist('func')
                    eval([func '(session, unit, SpikeInfo, SpikeData)'])
                else
                    accum(count,:,:)=eval([func1 ...
                                        '(session,unit,SpikeInfo,SpikeData)']);
                    count = count + 1;
                end
            end
        end
    end
end
if exist('func2')
    for i = 1:rounds
        accum_type = ['accum_' encoder_types(i, :) '_encoders'];
        eval([func2 '(accum_type, encoder_types(i, :))'])
    end
end