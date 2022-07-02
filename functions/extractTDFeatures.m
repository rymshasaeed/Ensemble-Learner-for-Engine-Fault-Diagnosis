function features = extractTDFeatures(data)

% Sampling frequency
Fs = 44000;
    
% Time Domain Features
time_F(:,1) = mean(data);                     % Mean
time_F(:,2) = std(data);                      % Standard Deviation
time_F(:,3) = skewness(data);                 % Skewness
time_F(:,4) = kurtosis(data);                 % Kurtosis
time_F(:,5) = peak2peak(data);                % Peak to Peak
time_F(:,6) = rms(data);                      % Root Mean Square
time_F(:,7) = max(data)/time_F(:,6);          % Crest Factor
time_F(:,8) = time_F(:,6)/mean(abs(data));    % Shape Factor
time_F(:,9) = max(data)/mean(abs(data));      % Impulse Factor
time_F(:,10) = max(data)/mean(abs(data)).^2;  % Margin Factor
time_F(:,11) = sum(data.^2);                  % Energy
time_F(:,12) = peak2rms(data);                % Peak to Root Mean Square
time_F(:,13) = rssq(data);                    % Root Sum of Squares
time_F(:,14) = wentropy(data,'shannon');      % Shannon Energy
time_F(:,15) = wentropy(data,'log energy');   % Log Energy

% Mel Frequency Cepstral Features (MFCCs)
cepFeatures = cepstralFeatureExtractor('SampleRate', Fs);
MFCC = cepFeatures(data);
MFCC = MFCC';

% Gammatone Cepstral Features (GTCCs)
GTCC = gtcc(data,Fs);
GTCC = mean(GTCC);

% Combine MFCCs and GTCCs
Cep_F = [MFCC, GTCC];

% Combine Time and Cepstral Features  
features = [time_F, Cep_F];

end

