% Read the original image
original_image = imread('cameraman.jpg');

% Convert to grayscale if it's an RGB image
if size(original_image, 3) == 3
    original_image = rgb2gray(original_image);
end

% Generate Gaussian noise
sigma = 25; % Standard deviation of Gaussian noise
gaussian_noise = sigma * randn(size(original_image)); 

% Add Gaussian noise to the original image
noisy_image = double(original_image) + gaussian_noise; 

% Define the size of the filter
filterSize = 3;

% Compute the center index of the filter
center = (filterSize + 1) / 2;

% Initialize the triangular filter
triangular_filter = zeros(filterSize);

% Calculate weights based on the distance from the center
for i = 1:filterSize
    for j = 1:filterSize
        distance = abs(i - center) + abs(j - center); % Manhattan distance
        triangular_filter(i, j) = max(center - distance, 0); % Assign weight
    end
end

% Normalize the filter so that the sum of all elements equals 1
triangular_filter = triangular_filter / sum(triangular_filter(:));

% Display Kernel:
disp('Filter Size: ');
disp(filterSize);
disp('Triangular Filter Kernel: ');
disp(triangular_filter);

tic
% Apply the triangular filter using convolution to smooth the noisy image
smoothed_image = conv2(noisy_image, triangular_filter, 'same');
time = toc;

% Convert smoothed_image back to the same data type as original_image
smoothed_image = cast(smoothed_image, class(original_image));

% Calculate PSNR
max_intensity = double(max(original_image(:)));
mse = mean((double(original_image(:)) - double(smoothed_image(:))).^2);
psnr_value = 10 * log10(max_intensity^2 / mse);

% Display PSNR and MSE
fprintf('PSNR: %.2f dB\n', psnr_value);
fprintf('MSE: %.2f\n', mse);

% Display original, noisy, and filtered images
figure;
subplot(1, 3, 1);
imshow(original_image);
title('Original Image');

subplot(1, 3, 2);
imshow(uint8(noisy_image));
title('Noisy Image');

subplot(1, 3, 3);
imshow(uint8(smoothed_image));
title('Filtered Image');

% Time
disp("Time taken: ");
disp(time);