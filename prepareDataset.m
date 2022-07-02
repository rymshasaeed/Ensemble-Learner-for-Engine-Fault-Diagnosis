clc, clearvars, close all

% Data directory
folder = dir('data\*.tdms');

% Initialize feature count
normal_count = 1;
lean_count = 1;
rich_count = 1;
spark_adv_count = 1;
spark_rtd_count = 1;

for i = 1:length(folder)
    % Read the data
    data = TDMS_getStruct(['data\', folder(i).name]);
    
    % Timestamp
    dt = data.Microphone_DAQ.CH1.Props.wf_increment;

    % Extract channel-1 data
    CH1 = data.Microphone_DAQ.CH1.data;

    % Sampling rate
    Fs = round(1/dt);

    % Takes a segment of 1 second from the signal
    data_segment = CH1;
    
    % Extract features
    F = [];
    X = CH1';
    for j = 1:length(X)/Fs
        S1 = X(((j-1)*Fs)+1:(j*Fs));
        S2 = X((j*Fs/2)+1:(j*Fs/2+Fs));
        F = [F, S1, S2];
    end
        
    % Write to output directory
    for k = 1:size(F, 2)
        % Set filenames for the features
        if strcmp(folder(i).name(1:end-10), 'Normal')
            filename = fullfile('features',sprintf('N(%d).mat', normal_count));
            normal_count = normal_count + 1;
        elseif strcmp(folder(i).name(1:end-10), 'Lean')
            filename = fullfile('features',sprintf('L(%d).mat', lean_count));
            lean_count = lean_count + 1;
        elseif strcmp(folder(i).name(1:end-10), 'Rich')
            filename = fullfile('features',sprintf('R(%d).mat', rich_count));
            rich_count = rich_count + 1;
        elseif strcmp(folder(i).name(1:end-10), 'Spark Adv')
            filename = fullfile('features',sprintf('SA(%d).mat', spark_adv_count));
            spark_adv_count = spark_adv_count + 1;
        elseif strcmp(folder(i).name(1:end-10), 'Spark Rtd')
            filename = fullfile('features',sprintf('SR(%d).mat', spark_rtd_count));
            spark_rtd_count = spark_rtd_count + 1;
        end
        
        Features = F(:, k);
        save(filename, 'Features');
    end
end
