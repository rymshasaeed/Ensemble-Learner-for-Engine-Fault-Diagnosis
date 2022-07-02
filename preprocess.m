clc, clearvars, close all

% Features directory
folder = dir('features\*.mat');

% Initialize feature vectors
F0 = [];
F1 = [];
F2 = [];
F3 = [];
F4 = [];

% Feature labels
labels = [0, 1, 2, 3, 4];

for k = 1:length(folder)
    % Get features files
    if strcmp(folder(k).name(1), 'N')
        filename = folder(k).name;
    elseif strcmp(folder(k).name(1), 'L')
        filename = folder(k).name;
    elseif strcmp(folder(k).name(1), 'R')
        filename = folder(k).name;
    elseif strcmp(folder(k).name(1:2), 'SA')
        filename = folder(k).name;
    elseif strcmp(folder(k).name(1:2), 'SR')
        filename = folder(k).name;
    end
    
    % Read the features data
    data_segment = importdata(['features\', filename]);

    % Apply normalization
    data = data_segment/max(abs(data_segment));
    
    % Get length of the data
    n = length(data);
    
    % Apply Empirical Mode Decomposition to find Intrinsic Mode Functions (IMFs) and Residual (r)
    imf = emd(data); 
    
    % IMF 4, 5, 6, 7, and 8 for reconstruction of preprocessed Signal
    ps_data = imf(:,4)+imf(:,5)+imf(:,6)+imf(:,7)+imf(:,8);
    
    % IMF 2, 3, 4, 5, and 6 for reconstruction of preprocessed SDP Image
    pi_data = imf(:,2)+imf(:,3)+imf(:,4)+imf(:,5)+imf(:,6);

    % Set parameters
    L = 2;                       % Time Lag
    G = 75;                      % Gain
    A = [0 60 120 180 240 300];  % Angles

    % Initilize the variables
    r = zeros(1,n-L);
    th = zeros(numel(A), n-L);
    tr = zeros(numel(A), n-L);
    
    % Plot dot patterns using SDP Algorithm
    for i = 1:numel(A)
        for j = 1 : n-L
            r(1,j)= (pi_data(j));
            th(i,j)= (A(i)*pi/180)+(pi_data(j+L) )*(G*pi/180);
            tr(i,j)= (A(i)*pi/180)-(pi_data(j+L) )*(G*pi/180);
        end
        
        % Plot SDP image
        polarscatter(th(i,:), r, 1,'black')
        hold on
        polarscatter(tr(i,:), r, 1,'black')
        grid off
        ax = gca;
        ax.RTickLabel = [];
        ax.ThetaTickLabel = [];
        hold off
        set(gca, 'Visible', 'off');
        saveas(gcf, 'dot_pattern.png');
        close all
    end
    
    % Read the dot pattern image
    img = imread('dot_pattern.png');
    
    % Extract features
    sfeat = extractTDFeatures(ps_data);
    ifeat = extractImageFeatures(img);
    
    % Create feature vector
    F = [ifeat sfeat];
    
    % Combine with the previous features
    if folder(k).name(1) == 'N'
        F0 = [F0; [F, labels(1)]];
    elseif folder(k).name(1) == 'L'
        F1 = [F1; [F, labels(2)]];
    elseif folder(k).name(1) == 'R'
        F2 = [F2; [F, labels(3)]];
    elseif folder(k).name(1:2) == 'SA'
        F3 = [F3; [F, labels(4)]];
    elseif folder(k).name(1:2) == 'SR'
        F4 = [F4; [F, labels(5)]];
    end
    fprintf('Features file: %d/%d\n', k, length(folder))
end

% Write all features to local directory
writematrix([F0; F1; F2; F3; F4], 'Features.xlsx');
