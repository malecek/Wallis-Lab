function batch_master(LFP_or_neur, which_units, varargin)
% 1) batch_master(LFP_or_neur, which_units, func)
% 2) batch_master(LFP_or_neur, which_units, func1, func2)
% 
% This is the master function used to call a specified function on individual
% electrodes or neurons, all of them, just the significant encoders, or a
% specified subset of sessions.
% 
% Inputs
% ------
% LFP_or_neur : str
%   'LFP' or 'neur'
% 
% which_units : str
%   'all', 'encoders', or a matrix of session strings
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
if strcmp(which_units, 'encoders')
    cd('~/Science/wallis/regression_results')
    encoder_types = {'pos'; 'neg'; 'mixed'};
    if strcmp(LFP_or_neur, 'neur')
        load('encoders', 'pos_encoders', 'neg_encoders', 'mixed_encoders')
    else
        load('LFP_encoders', 'pos_encoders', 'neg_encoders')
        % Remove the frequency index.
        for i = size(encoder_types, 1)
            e_type = [encoder_types{i} '_encoders'];
            eval([e_type '_encoders = ' e_type '_encoders(:, 1:9);'])
            eval([e_type '_encoders = unique(' e_type '_encoders, ''rows'');'])
        end
    end
    if exist('func')
        n_encoder_types = 1;
        % Because each encoder will be processed individually,
        % keeping the types separate is unnecessary.
        pos_encoders = [pos_encoders; neg_encoders];
        n_encoders = [length(pos_encoders)];
    else
        n_encoder_types = 3;
        n_encoders = [length(pos_encoders) length(neg_encoders) ...
                      length(mixed_encoders)];
    end
    for i = 1:n_encoder_types
        e_type = [encoder_types{i} '_encoders'];
        for j = 1:n_encoders(i)
            if exist('func')
                match = eval(['regexp(' e_type '(j,:), ''-'', ''split'')']);
                session = match{1};
                unit = match{2};
                cd(session)
                [SpikeInfo, ~, ~, SpikeData] = spk_read([session, '.spk']);
                eval([func '(session, unit, SpikeInfo, SpikeData)'])
            else
                load(eval([e_type '(j, :)']))
                eval(['accum_' e_type '(j,:) = r_squareds'';'])
            end
        end
    end
else
    data_dir = '~/Science/wallis/data';
    cd(data_dir)
    count = 1;
    if strcmp(which_units, 'all')
        sessions = dir;
    else
        % Add two garbage rows to the front so that the for loop works.
        sessions = ['XXXX.spk'; 'XXXX.spk'; which_units];
    end
    for i = 3:length(sessions)
        if strcmp(which_units, 'all')
            session = sessions(i).name;
        else
            session = sessions(i, :);
        end
        if regexp(session, '[AB][0-9]{3}')
            % In case you've moved since you were last in data_dir,
            % return there.
            cd(data_dir)
            [SpikeInfo, ~, ~, SpikeData] = spk_read(session);
            session = session(1:end-4);
            if strcmp(LFP_or_neur, 'neur')
                units = SpikeInfo.NeuronID;
            else
                units = SpikeInfo.LFPID;
            end
            for j = 1:length(units)
                unit = units(j);
                if exist('func')
                    if strcmp(LFP_or_neur, 'neur')
                        trial_spikes = get_trial_spikes(SpikeInfo,...
                                                        SpikeData,unit);
                        save_string = ['spike_regression/' session '-' ...
                                       int2str(unit)];
                        eval([func '(SpikeInfo, trial_spikes, save_string)'])
                    else
                        eval([func '(session, unit, SpikeInfo, SpikeData)'])
                    end
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
    for i = 1:n_encoder_types
        accum_type = ['accum_' encoder_types{i} '_encoders'];
        eval([func2 '(' accum_type ', encoder_types{i})'])
    end
end