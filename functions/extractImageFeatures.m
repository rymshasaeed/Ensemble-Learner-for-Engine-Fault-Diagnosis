function features = extractImageFeatures(img)

% Conver image to grayscle
img = rgb2gray(img);

% Local Binary Pattern (LBP) Features
lbp = extractLBPFeatures(img); 

% Create gray-level co-occurrence matrix from image
M = graycomatrix(img);

% Haralick Texture Features
ht = haralickTextureFeatures(M);

% Serial Fusion of both LBP and Haralick Features
features = [lbp, ht'];

end
